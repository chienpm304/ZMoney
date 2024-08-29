//
//  TransactionCoreDataStorage.swift
//  DataModule
//
//  Created by Chien Pham on 28/08/2024.
//

import DomainModule
import CoreData

public final class TransactionCoreDataStorage {
    private let coreData: CoreDataStack

    public init(coreData: CoreDataStack) {
        self.coreData = coreData
    }
}

extension TransactionCoreDataStorage: TransactionStorage {
    public func fetchTransaction(
        by id: ID,
        completion: @escaping (Result<DMTransaction, Error>) -> Void
    ) {
        coreData.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<CDTransaction> = CDTransaction.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            do {
                if let entity = try context.fetch(fetchRequest).first {
                    completion(.success(entity.domain))
                } else {
                    completion(.failure(CoreDataError.notFound))
                }
            } catch {
                completion(.failure(CoreDataError.fetchError(error)))
            }
        }
    }

    public func fetchTransactions(
        startTime: TimeValue,
        endTime: TimeValue,
        completion: @escaping (Result<[DMTransaction], Error>) -> Void
    ) {
        coreData.performBackgroundTask { context in
            do {
                let fetchRequest = CDTransaction.fetchRequest()
                fetchRequest.predicate = NSPredicate(
                    format: "inputTime != nil AND inputTime >= %@ AND inputTime <= %@",
                    startTime.dateValue as NSDate,
                    endTime.dateValue as NSDate
                )
                fetchRequest.sortDescriptors = [
                    NSSortDescriptor(key: #keyPath(CDTransaction.inputTime), ascending: false)
                ]

                let entities = try context.fetch(fetchRequest)
                completion(.success(entities.map { $0.domain }))
            } catch {
                completion(.failure(CoreDataError.fetchError(error)))
            }
        }
    }

    public func addTransactions(
        _ transactions: [DMTransaction],
        completion: @escaping (Result<[DMTransaction], Error>) -> Void
    ) {
        coreData.performBackgroundTask { context in
            do {
                let entities = transactions.map { CDTransaction(transaction: $0, insertInto: context) }
                try context.save()
                completion(.success(entities.map { $0.domain }))
            } catch {
                completion(.failure(CoreDataError.saveError(error)))
            }
        }
    }

    public func updateTransactions(
        _ transactions: [DMTransaction],
        completion: @escaping (Result<[DMTransaction], Error>) -> Void
    ) {
        coreData.performBackgroundTask { context in
            do {
                let transactionsIDs = transactions.map { $0.id }
                let transactionsDict = Dictionary(uniqueKeysWithValues: transactions.map { ($0.id, $0) })
                let fetchRequest = CDTransaction.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id IN %@", transactionsIDs)
                fetchRequest.sortDescriptors = [
                    NSSortDescriptor(key: #keyPath(CDTransaction.inputTime), ascending: false)
                ]
                let entities = try context.fetch(fetchRequest)
                for entity in entities {
                    guard let entityID = entity.id, let transaction = transactionsDict[entityID] else {
                        assertionFailure()
                        continue
                    }
                    entity.update(with: transaction, context: context)
                }
                try context.save()
                completion(.success(entities.map { $0.domain }))
            } catch {
                completion(.failure(CoreDataError.saveError(error)))
            }
        }
    }

    public func deleteTransactionsByIDs(
        _ transactionIDs: [ID],
        completion: @escaping (Result<[DMTransaction], Error>) -> Void
    ) {
        coreData.performBackgroundTask { context in
            do {
                let fetchRequest = CDTransaction.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id IN %@", transactionIDs)

                let entities = try context.fetch(fetchRequest)
                guard !entities.isEmpty else {
                    completion(.failure(CoreDataError.notFound))
                    return
                }
                let deletedTransactions = entities.map { $0.domain }
                entities.forEach { context.delete($0) }
                try context.save()
                completion(.success(deletedTransactions))
            } catch {
                completion(.failure(CoreDataError.deleteError(error)))
            }
        }
    }
}
