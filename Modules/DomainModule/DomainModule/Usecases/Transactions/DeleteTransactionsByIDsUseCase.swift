//
//  DeleteTransactionsByIDsUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 27/08/2024.
//

import Combine

public final class DeleteTransactionsByIDsUseCase: UseCase {
    public struct RequestValue {
        let transactionIDs: [ID]

        public init(transactionIDs: [ID]) {
            self.transactionIDs = transactionIDs
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
        transactionRepository.deleteTransactionsByIDs(
            requestValue.transactionIDs,
            completion: completion
        )
        return nil
    }
}
