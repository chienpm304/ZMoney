//
//  FetchTransactionsByTimeUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 27/08/2024.
//

import Combine

public final class FetchTransactionsByTimeUseCase: AsyncUseCase {
    public struct Input {
        let startTime: TimeValue
        let endTime: TimeValue

        public init(startTime: TimeValue, endTime: TimeValue) {
            self.startTime = startTime
            self.endTime = endTime
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
        try await transactionRepository.fetchTransactions(
            startTime: input.startTime,
            endTime: input.endTime
        )
    }
}
