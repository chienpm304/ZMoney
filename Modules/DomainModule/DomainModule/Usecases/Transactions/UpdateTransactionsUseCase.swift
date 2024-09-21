//
//  UpdateTransactionsUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 27/08/2024.
//

import Combine

public final class UpdateTransactionsUseCase: AsyncUseCase {
    public struct Input {
        let transactions: [DMTransaction]

        public init(transactions: [DMTransaction]) {
            self.transactions = transactions
        }
    }

    public typealias Output = [DMTransaction]

    private let transactionRepository: TransactionRepository

    public init(
        transactionRepository: TransactionRepository
    ) {
        self.transactionRepository = transactionRepository
    }

    public func execute(input: Input) async throws -> [DMTransaction] {
        try await transactionRepository.updateTransactions(input.transactions)
    }
}
