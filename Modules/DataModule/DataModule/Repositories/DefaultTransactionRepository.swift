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
    public func fetchTransaction(by id: ID) async throws -> DMTransaction {
        try await storage.fetchTransaction(by: id)
    }

    public func fetchTransactions(startTime: TimeValue, endTime: TimeValue) async throws -> [DMTransaction] {
        try await storage.fetchTransactions(startTime: startTime, endTime: endTime)
    }

    public func fetchTransactions(
        category: DMCategory,
        startTime: TimeValue,
        endTime: TimeValue
    ) async throws -> [DMTransaction] {
        try await storage.fetchTransactions(category: category, startTime: startTime, endTime: endTime)
    }

    public func addTransactions(_ transactions: [DMTransaction]) async throws -> [DMTransaction] {
        try await storage.addTransactions(transactions)
    }

    public func updateTransactions(_ transactions: [DMTransaction]) async throws -> [DMTransaction] {
        try await storage.updateTransactions(transactions)
    }

    public func deleteTransactionsByIDs(_ transactionIDs: [ID]) async throws -> [DMTransaction] {
        try await storage.deleteTransactionsByIDs(transactionIDs)
    }

    public func searchTransactions(keyword: String) async throws -> [DMTransaction] {
        try await storage.searchTransactions(keyword: keyword)
    }
}
