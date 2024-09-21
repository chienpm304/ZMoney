//
//  CategoryCoreDataStorage.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

import DomainModule
import CoreData

public final class CategoryCoreDataStorage {
    private let coreData: CoreDataStack

    public init(coreData: CoreDataStack = .shared) {
        self.coreData = coreData
    }
}

extension CategoryCoreDataStorage: CategoryStorage {
    public func fetchCategories() async throws -> [DMCategory] {
        try await coreData.performBackgroundTask { context in
            do {
                let request: NSFetchRequest = CDCategory.fetchRequest()
                request.sortDescriptors = [
                    NSSortDescriptor(key: #keyPath(CDCategory.sortIndex), ascending: true)
                ]
                return try context.fetch(request).map { $0.domain }
            } catch {
                throw DMError.fetchError(error)
            }
        }
    }

    public func addCategories(_ categories: [DMCategory]) async throws -> [DMCategory] {
        try await coreData.performBackgroundTask { context in
            do {
                // By right we can simply ensure the data uniqueness by specify attribute constraint
                // But with CoreData (or sqlite) limitation, Entity CDCategory cannot have uniqueness
                // constraints and to-one mandatory inverse relationship CDTransaction.category
                // So we handle the uqniueness checking muanlually.

                // Check for existing categories with the same IDs
                let existingCategoryIDs = Set(categories.map { $0.id })
                let fetchRequest: NSFetchRequest<CDCategory> = CDCategory.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id IN %@", existingCategoryIDs)

                let existingCategories = try context.fetch(fetchRequest)
                let existingCategoryIDsSet = Set(existingCategories.map { $0.id })

                let newCategories = categories.filter { !existingCategoryIDsSet.contains($0.id) }
                if newCategories.isEmpty {
                    throw DMError.duplicated
                }

                // Create new entities for categories that do not exist yet
                let entities = newCategories.map { CDCategory(category: $0, insertInto: context) }
                try context.save()
                return entities.map { $0.domain }
            } catch {
                throw DMError.addError(error)
            }
        }
    }

    public func updateCategories(_ categories: [DMCategory]) async throws -> [DMCategory] {
        try await coreData.performBackgroundTask { context in
            do {
                let categoriesIDs = categories.map { $0.id }
                let categoriesDict = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0) })
                let fetchRequest: NSFetchRequest<CDCategory> = CDCategory.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id IN %@", categoriesIDs)
                fetchRequest.sortDescriptors = [
                    NSSortDescriptor(key: #keyPath(CDCategory.sortIndex), ascending: true)
                ]
                let entities = try context.fetch(fetchRequest)
                for entity in entities {
                    if let entityID = entity.id, let category = categoriesDict[entityID] {
                        entity.name = category.name
                        entity.icon = category.icon
                        entity.color = category.color
                        entity.sortIndex = category.sortIndex
                    }
                }
                try context.save()
                return entities.map { $0.domain }
            } catch {
                throw DMError.updateError(error)
            }
        }
    }

    public func deleteCategories(_ categoryIDs: [ID]) async throws -> [DMCategory] {
        try await coreData.performBackgroundTask { context in
            do {
                let fetchRequest: NSFetchRequest<CDCategory> = CDCategory.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id IN %@", categoryIDs)

                let entities = try context.fetch(fetchRequest)
                guard !entities.isEmpty else {
                    throw DMError.notFound
                }
                let deletedCategories = entities.map { $0.domain }
                entities.forEach { context.delete($0) }
                try context.save()
                return deletedCategories
            } catch {
                if (error as NSError).code == NSValidationRelationshipDeniedDeleteError {
                    throw DMError.violateRelationshipConstraint
                } else {
                    throw DMError.deleteError(error)
                }
            }
        }
    }
}
