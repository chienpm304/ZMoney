//
//  FetchTransactionsByTimeAsyncUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 14/09/2024.
//

import Foundation

public final class FetchTransactionsByTimeAsyncUseCase: AsyncUseCase {
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

    public init(transactionRepository: TransactionRepository) {
        self.transactionRepository = transactionRepository
    }

    public func execute(input: Input) async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            transactionRepository.fetchTransactions(
                startTime: input.startTime,
                endTime: input.endTime
            ) { result in
                continuation.resume(with: result)
            }
        }
    }
}
