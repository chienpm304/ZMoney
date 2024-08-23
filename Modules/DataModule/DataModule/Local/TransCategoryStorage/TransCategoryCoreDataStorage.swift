//
//  TransCategoryCoreDataStorage.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

import DomainModule
import CoreData

public final class TransCategoryCoreDataStorage {
    private let coreData: CoreDataStack

    public init(coreData: CoreDataStack = .shared) {
        self.coreData = coreData
    }
}

extension TransCategoryCoreDataStorage: TransCategoryStorage {
    public func fetchAllTransCategories(completion: @escaping (Result<[TransCategory], Error>) -> Void) {
        coreData.performBackgroundTask { context in
            do {
                let request: NSFetchRequest = TransCategoryEntity.fetchRequest()
                request.sortDescriptors = [
                    NSSortDescriptor(key: #keyPath(TransCategoryEntity.sortIndex), ascending: true)
                ]
                let result = try context.fetch(request).map { $0.domain }
                completion(.success(result))
            } catch {
                completion(.failure(CoreDataError.readError(error)))
            }
        }
    }

    public func addTransCategories(
        _ categories: [TransCategory],
        completion: @escaping (Result<[TransCategory], Error>) -> Void
    ) {
        coreData.performBackgroundTask { context in
            do {
                let entities = categories.map { TransCategoryEntity(category: $0, insertInto: context) }
                try context.save()
                completion(.success(entities.map { $0.domain }))
            } catch {
                completion(.failure(CoreDataError.saveError(error)))
            }
        }
    }

    public func updateTransCategories(
        _ categories: [TransCategory],
        completion: @escaping (Result<[TransCategory], Error>) -> Void
    ) {
        coreData.performBackgroundTask { context in
            do {
                let categoriesIDs = categories.map { $0.id }
                let categoriesDict = Dictionary(uniqueKeysWithValues: categories.map { ($0.id, $0) })
                let fetchRequest: NSFetchRequest<TransCategoryEntity> = TransCategoryEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id IN %@", categoriesIDs)
                let entities = try context.fetch(fetchRequest)
                for entity in entities {
                    if let category = categoriesDict[entity.id] {
                        entity.name = category.name
                        entity.icon = category.icon
                        entity.color = category.color
                        entity.sortIndex = category.sortIndex
                    }
                }
                try context.save()
                completion(.success(entities.map { $0.domain }.sorted(by: { $0.sortIndex < $1.sortIndex })))
            } catch {
                completion(.failure(CoreDataError.saveError(error)))
            }
        }
    }

    public func deleteTransCategory(
        byId id: ID,
        completion: @escaping (Result<TransCategory, Error>) -> Void
    ) {
        coreData.performBackgroundTask { context in
            do {
                let fetchRequest: NSFetchRequest = TransCategoryEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

                guard let entity = try context.fetch(fetchRequest).first else {
                    completion(.failure(CoreDataError.notFound))
                    return
                }
                let deletedCategory = entity.domain
                context.delete(entity)
                try context.save()
                completion(.success(deletedCategory))
            } catch {
                completion(.failure(CoreDataError.deleteError(error)))
            }
        }
    }
}
