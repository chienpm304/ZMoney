//
//  FetchTransactionsByTimeUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 27/08/2024.
//

import Combine

public final class FetchTransactionsByTimeUseCase: UseCase {
    public struct RequestValue {
        let startTime: TimeValue
        let endTime: TimeValue

        public init(startTime: TimeValue, endTime: TimeValue) {
            self.startTime = startTime
            self.endTime = endTime
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
        transactionRepository.fetchTransactions(
            startTime: requestValue.startTime,
            endTime: requestValue.endTime,
            completion: completion
        )
        return nil
    }
}
