//
//  TransactionStorage.swift
//  DataModule
//
//  Created by Chien Pham on 28/08/2024.
//

import DomainModule

public protocol TransactionStorage {
    func fetchTransaction(by id: ID) async throws -> DMTransaction

    func fetchTransactions(
        startTime: TimeValue,
        endTime: TimeValue
    ) async throws -> [DMTransaction]

    func fetchTransactions(
        category: DMCategory,
        startTime: TimeValue,
        endTime: TimeValue
    ) async throws -> [DMTransaction]

    func addTransactions(_ transactions: [DMTransaction]) async throws -> [DMTransaction]

    func updateTransactions(_ transactions: [DMTransaction]) async throws -> [DMTransaction]

    func deleteTransactionsByIDs(_ transactionIDs: [ID]) async throws -> [DMTransaction]

    func searchTransactions(keyword: String) async throws -> [DMTransaction]
}
