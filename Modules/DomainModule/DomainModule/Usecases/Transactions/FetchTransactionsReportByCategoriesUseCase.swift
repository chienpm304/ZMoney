//
//  FetchTransactionsReportByCategoriesUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 14/09/2024.
//

import Foundation

public final class FetchTransactionsReportByCategoriesUseCase: AsyncUseCase {
    public struct Input {
        let startTime: TimeValue
        let endTime: TimeValue

        public init(startTime: TimeValue, endTime: TimeValue) {
            self.startTime = startTime
            self.endTime = endTime
        }
    }

    public typealias Output = [(DMCategory, MoneyValue)]

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
                switch result {
                case .success(let transactions):
                    let summary = Dictionary(grouping: transactions) { $0.category }
                        .mapValues {
                            $0.reduce(into: 0) { partialResult, tran in
                                partialResult += tran.amount
                            }
                        }
                        .map { (key: DMCategory, value: Int64) in
                            (key, value)
                        }
                    continuation.resume(returning: summary)

                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
