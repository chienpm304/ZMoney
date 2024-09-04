//
//  TransactionStorage.swift
//  DataModule
//
//  Created by Chien Pham on 28/08/2024.
//

import DomainModule

public protocol TransactionStorage {
    func fetchTransaction(
        by id: ID,
        completion: @escaping (Result<DMTransaction, DMError>) -> Void
    )

    func fetchTransactions(
        startTime: TimeValue,
        endTime: TimeValue,
        completion: @escaping (Result<[DMTransaction], DMError>) -> Void
    )

    func addTransactions(
        _ transactions: [DMTransaction],
        completion: @escaping (Result<[DMTransaction], DMError>) -> Void
    )

    func updateTransactions(
        _ transactions: [DMTransaction],
        completion: @escaping (Result<[DMTransaction], DMError>) -> Void
    )

    func deleteTransactionsByIDs(
        _ transactionIDs: [ID],
        completion: @escaping (Result<[DMTransaction], DMError>) -> Void
    )
}
