//
//  FetchTransactionsUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 27/08/2024.
//

import Combine

public final class FetchTransactionByIDUseCase: AsyncUseCase {
    public struct Input {
        let transactionID: ID

        public init(transactionID: ID) {
            self.transactionID = transactionID
        }
    }

    public typealias Output = DMTransaction

    private let transactionRepository: TransactionRepository

    public init(
        transactionRepository: TransactionRepository
    ) {
        self.transactionRepository = transactionRepository
    }

    public func execute() -> Cancellable? {

        return nil
    }

    public func execute(input: Input) async throws -> DMTransaction {
        try await transactionRepository.fetchTransaction(by: input.transactionID)
    }
}
