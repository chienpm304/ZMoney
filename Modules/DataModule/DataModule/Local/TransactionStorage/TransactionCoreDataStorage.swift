//
//  TransactionCoreDataStorage.swift
//  DataModule
//
//  Created by Chien Pham on 28/08/2024.
//

import DomainModule
import CoreData
import SwiftDate

public final class TransactionCoreDataStorage {
    private let coreData: CoreDataStack

    public init(coreData: CoreDataStack) {
        self.coreData = coreData
    }
}

extension TransactionCoreDataStorage: TransactionStorage {
    public func fetchTransaction(
        by id: ID,
        completion: @escaping (Result<DMTransaction, DMError>) -> Void
    ) {
        coreData.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<CDTransaction> = CDTransaction.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            do {
                if let entity = try context.fetch(fetchRequest).first {
                    completion(.success(entity.domain))
                } else {
                    completion(.failure(.notFound))
                }
            } catch {
                completion(.failure(.fetchError(error)))
            }
        }
    }

    public func fetchTransactions(
        startTime: TimeValue,
        endTime: TimeValue,
        completion: @escaping (Result<[DMTransaction], DMError>) -> Void
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
#if DEBUG
                // TODO: remove test
                if entities.isEmpty {
                    self.generateMockTransactions(
                        startTime: startTime,
                        endTime: endTime,
                        context: context,
                        completion: completion
                    )
                    return
                }
                // end test
#endif
                completion(.success(entities.map { $0.domain }))
            } catch {
                completion(.failure(.fetchError(error)))
            }
        }
    }

    public func addTransactions(
        _ transactions: [DMTransaction],
        completion: @escaping (Result<[DMTransaction], DMError>) -> Void
    ) {
        coreData.performBackgroundTask { context in
            do {
                let entities = transactions.map { CDTransaction(transaction: $0, insertInto: context) }
                try context.save()
                completion(.success(entities.map { $0.domain }))
            } catch {
                if (error as NSError).code == NSManagedObjectConstraintMergeError {
                    completion(.failure(.duplicated))
                } else {
                    completion(.failure(.addError(error)))
                }
            }
        }
    }

    public func updateTransactions(
        _ transactions: [DMTransaction],
        completion: @escaping (Result<[DMTransaction], DMError>) -> Void
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
                completion(.failure(.updateError(error)))
            }
        }
    }

    public func deleteTransactionsByIDs(
        _ transactionIDs: [ID],
        completion: @escaping (Result<[DMTransaction], DMError>) -> Void
    ) {
        coreData.performBackgroundTask { context in
            do {
                let fetchRequest = CDTransaction.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id IN %@", transactionIDs)

                let entities = try context.fetch(fetchRequest)
                guard !entities.isEmpty else {
                    completion(.failure(.notFound))
                    return
                }
                let deletedTransactions = entities.map { $0.domain }
                entities.forEach { context.delete($0) }
                try context.save()
                completion(.success(deletedTransactions))
            } catch {
                completion(.failure(.deleteError(error)))
            }
        }
    }

#if DEBUG
    private func generateMockTransactions(
        startTime: TimeValue,
        endTime: TimeValue,
        context: NSManagedObjectContext,
        completion: @escaping (Result<[DMTransaction], DMError>) -> Void
    ) {
        let categoryRepository = DefaultCategoryRepository(
            storage: CategoryCoreDataStorage(coreData: self.coreData)
        )
        categoryRepository.fetchCategories { result in
            switch result {
            case .success(let categories):
                if categories.isEmpty {
                    completion(.success([]))
                    return
                }
                let transactions: [DMTransaction] = (0...50).map {
                    let date = DateInRegion.randomDate(
                        between: startTime.dateValue.inDefaultRegion(),
                        and: endTime.dateValue.inDefaultRegion()
                    ).date

                    return .init(
                        inputTime: date.timeValue,
                        amount: MoneyValue.random(in: 1...100) * 10_000_00,
                        memo: "Test note \($0)",
                        category: categories[Int.random(in: 0..<categories.count)]
                    )
                }
                print("[Transaction] Generated mock transactions")
                self.addTransactions(transactions, completion: completion)

            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
#endif
}
