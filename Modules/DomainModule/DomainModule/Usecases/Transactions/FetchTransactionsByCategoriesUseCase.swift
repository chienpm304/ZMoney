//
//  FetchTransactionsByCategoriesUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 16/09/2024.
//

import Foundation

public final class FetchTransactionsByCategoriesUseCase: AsyncUseCase {
    public struct Input {
        let startTime: TimeValue
        let endTime: TimeValue
        let category: DMCategory

        public init(
            startTime: TimeValue,
            endTime: TimeValue,
            category: DMCategory
        ) {
            self.startTime = startTime
            self.endTime = endTime
            self.category = category
        }
    }

    public typealias Output = [DMTransaction]

    private let transactionRepository: TransactionRepository

    public init(transactionRepository: TransactionRepository) {
        self.transactionRepository = transactionRepository
    }

    public func execute(input: Input) async throws -> [DMTransaction] {
        try await transactionRepository.fetchTransactions(
            category: input.category,
            startTime: input.startTime,
            endTime: input.endTime
        )
    }
}
