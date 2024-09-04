//
//  DefaultTransactionRepository.swift
//  DataModule
//
//  Created by Chien Pham on 29/08/2024.
//

import DomainModule

public final class DefaultTransactionRepository {
    private let storage: TransactionStorage

    public init(storage: TransactionStorage) {
        self.storage = storage
    }
}

extension DefaultTransactionRepository: TransactionRepository {
    public func fetchTransaction(
        by id: ID,
        completion: @escaping (Result<DMTransaction, DMError>) -> Void
    ) {
        storage.fetchTransaction(by: id, completion: completion)
    }

    public func fetchTransactions(
        startTime: TimeValue,
        endTime: TimeValue,
        completion: @escaping (Result<[DMTransaction], DMError>) -> Void
    ) {
        storage.fetchTransactions(startTime: startTime, endTime: endTime, completion: completion)
    }

    public func addTransactions(
        _ transactions: [DMTransaction],
        completion: @escaping (Result<[DMTransaction], DMError>) -> Void
    ) {
        storage.addTransactions(transactions, completion: completion)
    }

    public func updateTransactions(
        _ transactions: [DMTransaction],
        completion: @escaping (Result<[DMTransaction], DMError>) -> Void
    ) {
        storage.updateTransactions(transactions, completion: completion)
    }

    public func deleteTransactionsByIDs(
        _ transactionIDs: [ID],
        completion: @escaping (Result<[DMTransaction], DMError>) -> Void
    ) {
        storage.deleteTransactionsByIDs(transactionIDs, completion: completion)
    }
}
