//
//  TransactionRepository.swift
//  DomainModule
//
//  Created by Chien Pham on 27/08/2024.
//

import Foundation

public protocol TransactionRepository {
    func fetchTransaction(
        by id: ID,
        completion: @escaping (Result<DMTransaction, Error>) -> Void
    )

    func fetchTransactions(
        startTime: TimeValue,
        endTime: TimeValue,
        completion: @escaping (Result<[DMTransaction], Error>) -> Void
    )

    func addTransactions(
        _ transactions: [DMTransaction],
        completion: @escaping (Result<[DMTransaction], Error>) -> Void
    )

    func updateTransactions(
        _ transactions: [DMTransaction],
        completion: @escaping (Result<[DMTransaction], Error>) -> Void
    )

    func deleteTransactions(
        transactionIDs: [ID],
        completion: @escaping (Result<[DMTransaction], Error>) -> Void
    )
}
