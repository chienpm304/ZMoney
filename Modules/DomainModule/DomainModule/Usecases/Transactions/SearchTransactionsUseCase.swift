//
//  SearchTransactionsUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 12/09/2024.
//

import Foundation


public final class SearchTransactionsUseCase: AsyncUseCase {
    public struct SearchParams {
        let keyword: String

        public init(keyword: String) {
            self.keyword = keyword
        }
    }

    public typealias Input = SearchParams
    public typealias Output = [DMTransaction]

    private let repository: TransactionRepository

    public init(repository: TransactionRepository) {
        self.repository = repository
    }

    public func execute(input: Input) async throws -> Output {
        try await repository.searchTransactions(keyword: input.keyword)
    }
}
