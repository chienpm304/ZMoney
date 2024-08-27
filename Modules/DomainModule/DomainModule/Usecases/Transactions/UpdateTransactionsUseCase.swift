//
//  UpdateTransactionsUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 27/08/2024.
//

import Combine

public final class UpdateTransactionsUseCase: UseCase {
    public struct RequestValue {
        let transactions: [DMTransaction]

        public init(transactions: [DMTransaction]) {
            self.transactions = transactions
        }
    }

    public typealias ResultValue = (Result<[DMTransaction], Error>)

    private let requestValue: RequestValue
    private let transactionRepository: TransactionRepository
    private let completion: (ResultValue) -> Void

    public init(
        requestValue: RequestValue,
        transactionRepository: TransactionRepository,
        completion: @escaping (ResultValue) -> Void
    ) {
        self.requestValue = requestValue
        self.transactionRepository = transactionRepository
        self.completion = completion
    }

    public func execute() -> Cancellable? {
        transactionRepository.updateTransactions(
            requestValue.transactions,
            completion: completion
        )
        return nil
    }
}
