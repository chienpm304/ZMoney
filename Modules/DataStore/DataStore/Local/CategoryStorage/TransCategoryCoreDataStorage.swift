//
//  TransCategoryCoreDataStorage.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

import Domain
import Common
import CoreData

final class TransCategoryCoreDataStorage {
    private let coreData: CoreDataStack

    init(coreData: CoreDataStack = .shared) {
        self.coreData = coreData
    }
}

extension TransCategoryCoreDataStorage: TransCategoryStorage {
    func fetchAllTransCategories(completion: @escaping (Result<[TransCategory], Error>) -> Void) {
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

    func addTransCategory(
        _ category: TransCategory,
        completion: @escaping (Result<TransCategory, Error>) -> Void
    ) {
        coreData.performBackgroundTask { context in
            do {
                let entity = TransCategoryEntity(category: category, insertInto: context)
                try context.save()
                completion(.success(entity.domain))
            } catch {
                completion(.failure(CoreDataError.saveError(error)))
            }
        }
    }

    func updateTransCategory(
        _ category: TransCategory,
        completion: @escaping (Result<TransCategory, Error>) -> Void
    ) {
        coreData.performBackgroundTask { context in
            do {
                let fetchRequest: NSFetchRequest<TransCategoryEntity> = TransCategoryEntity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", category.id as CVarArg)

                guard  let entity = try context.fetch(fetchRequest).first else {
                    completion(.failure(CoreDataError.notFound))
                    return
                }
                entity.name = category.name
                entity.icon = category.icon
                entity.color = category.color
                entity.sortIndex = category.sortIndex
                try context.save()
                completion(.success(entity.domain))
            } catch {
                completion(.failure(CoreDataError.saveError(error)))
            }
        }
    }

    func deleteTransCategory(
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
