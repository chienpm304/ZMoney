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
    public func fetchCategories(completion: @escaping (Result<[DMCategory], Error>) -> Void) {
        coreData.performBackgroundTask { context in
            do {
                let request: NSFetchRequest = CDCategory.fetchRequest()
                request.sortDescriptors = [
                    NSSortDescriptor(key: #keyPath(CDCategory.sortIndex), ascending: true)
                ]
                let result = try context.fetch(request).map { $0.domain }
                completion(.success(result))
            } catch {
                completion(.failure(CoreDataError.fetchError(error)))
            }
        }
    }

    public func addCategories(
        _ categories: [DMCategory],
        completion: @escaping (Result<[DMCategory], Error>) -> Void
    ) {
        coreData.performBackgroundTask { context in
            do {
                let entities = categories.map { CDCategory(category: $0, insertInto: context) }
                try context.save()
                completion(.success(entities.map { $0.domain }))
            } catch {
                completion(.failure(CoreDataError.saveError(error)))
            }
        }
    }

    public func updateCategories(
        _ categories: [DMCategory],
        completion: @escaping (Result<[DMCategory], Error>) -> Void
    ) {
        coreData.performBackgroundTask { context in
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
                completion(.success(entities.map { $0.domain }))
            } catch {
                completion(.failure(CoreDataError.saveError(error)))
            }
        }
    }

    public func deleteCategories(
        _ categoryIDs: [ID],
        completion: @escaping (Result<[DMCategory], CategoryDeleteError>) -> Void
    ) {
        coreData.performBackgroundTask { context in
            do {
                let fetchRequest: NSFetchRequest<CDCategory> = CDCategory.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id IN %@", categoryIDs)

                let entities = try context.fetch(fetchRequest)
                guard !entities.isEmpty else {
                    completion(.failure(.categoryNotFound))
                    return
                }
                let deletedCategories = entities.map { $0.domain }
                entities.forEach { context.delete($0) }
                try context.save()
                completion(.success(deletedCategories))
            } catch {
                if (error as NSError).code == NSValidationRelationshipDeniedDeleteError {
                    completion(.failure(.violateRelationshipConstraintError))
                } else {
                    completion(.failure(.error(error)))
                }
            }
        }
    }
}
