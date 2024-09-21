//
//  DeleteTransactionsByIDsUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 27/08/2024.
//

import Combine

public final class DeleteTransactionsByIDsUseCase: AsyncUseCase {
    public struct Input {
        let transactionIDs: [ID]

        public init(transactionIDs: [ID]) {
            self.transactionIDs = transactionIDs
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
        try await transactionRepository.deleteTransactionsByIDs(input.transactionIDs)
    }
}
