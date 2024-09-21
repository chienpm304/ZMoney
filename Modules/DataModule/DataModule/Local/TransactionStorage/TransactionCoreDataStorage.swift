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
    public func fetchTransaction(by id: ID) async throws -> DMTransaction {
        try await coreData.performBackgroundTask { context in
            let fetchRequest: NSFetchRequest<CDTransaction> = CDTransaction.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            do {
                if let entity = try context.fetch(fetchRequest).first {
                    return entity.domain
                } else {
                    throw DMError.notFound
                }
            } catch {
                throw DMError.fetchError(error)
            }
        }
    }

    public func fetchTransactions(startTime: TimeValue, endTime: TimeValue) async throws -> [DMTransaction] {
        let transactions = try await coreData.performBackgroundTask { context in
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
                return entities.map { $0.domain }
            } catch {
                throw DMError.fetchError(error)
            }
        }

#if DEBUG
        // TODO: remove test
        if transactions.isEmpty {
            return try await generateMockTransactions(startTime: startTime, endTime: endTime)
        } else {
            return transactions
        }
        // end test
#else
        return transactions
#endif
    }

    public func fetchTransactions(
        category: DMCategory,
        startTime: TimeValue,
        endTime: TimeValue
    ) async throws -> [DMTransaction] {
        try await coreData.performBackgroundTask { context in
            do {
                let fetchRequest = CDTransaction.fetchRequest()
                fetchRequest.predicate = NSPredicate(
                    format: "category != nil AND category.id == %@ && inputTime != nil AND inputTime >= %@ AND inputTime <= %@",
                    category.id as CVarArg,
                    startTime.dateValue as NSDate,
                    endTime.dateValue as NSDate
                )
                fetchRequest.sortDescriptors = [
                    NSSortDescriptor(key: #keyPath(CDTransaction.inputTime), ascending: false)
                ]

                let entities = try context.fetch(fetchRequest)
                return entities.map { $0.domain }
            } catch {
                throw DMError.fetchError(error)
            }
        }
    }

    public func addTransactions(_ transactions: [DMTransaction]) async throws -> [DMTransaction] {
        try await coreData.performBackgroundTask { context in
            do {
                let entities = transactions.map { CDTransaction(transaction: $0, insertInto: context) }
                try context.save()
                return entities.map { $0.domain }
            } catch {
                if (error as NSError).code == NSManagedObjectConstraintMergeError {
                    throw DMError.duplicated
                } else {
                    throw DMError.addError(error)
                }
            }
        }
    }

    public func updateTransactions(_ transactions: [DMTransaction]) async throws -> [DMTransaction] {
        try await coreData.performBackgroundTask { context in
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
                return entities.map { $0.domain }
            } catch {
                throw DMError.updateError(error)
            }
        }
    }

    public func deleteTransactionsByIDs(_ transactionIDs: [ID]) async throws -> [DMTransaction] {
        try await coreData.performBackgroundTask { context in
            do {
                let fetchRequest = CDTransaction.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id IN %@", transactionIDs)

                let entities = try context.fetch(fetchRequest)
                guard !entities.isEmpty else {
                    throw DMError.notFound
                }
                let deletedTransactions = entities.map { $0.domain }
                entities.forEach { context.delete($0) }
                try context.save()
                return deletedTransactions
            } catch {
                throw DMError.deleteError(error)
            }
        }
    }

    public func searchTransactions(keyword: String) async throws -> [DMTransaction] {
        try await withCheckedThrowingContinuation { continuation in
            coreData.performBackgroundTask { context in
                let fetchRequest: NSFetchRequest<CDTransaction> = CDTransaction.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "memo CONTAINS[c] %@", keyword)
                fetchRequest.sortDescriptors = [
                    NSSortDescriptor(key: #keyPath(CDTransaction.inputTime), ascending: false)
                ]

                do {
                    let entities = try context.fetch(fetchRequest)
                    let transactions = entities.map { $0.domain }
                    continuation.resume(returning: transactions)
                } catch {
                    continuation.resume(throwing: DMError.fetchError(error))
                }
            }
        }
    }

#if DEBUG
    private func generateMockTransactions(
        startTime: TimeValue,
        endTime: TimeValue
    ) async throws -> [DMTransaction] {
        do {
            let categoryRepository = DefaultCategoryRepository(
                storage: CategoryCoreDataStorage(coreData: self.coreData)
            )
            let categories = try await categoryRepository.fetchCategories()
            if categories.isEmpty {
                return []
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
            let addedTransactions = try await addTransactions(transactions)
            print("[Transaction] Generated mock transactions")
            return addedTransactions
        } catch {
            throw DMError.unknown(error)
        }
    }
#endif
}
