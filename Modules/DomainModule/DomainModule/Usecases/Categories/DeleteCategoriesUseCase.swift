//
//  DeleteCategoriesUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 23/08/2024.
//

import Combine

public final class DeleteCategoriesUseCase: AsyncUseCase {
    public struct Input {
        let categoryIDs: [ID]

        public init(categoryIDs: [ID]) {
            self.categoryIDs = categoryIDs
        }
    }

    public typealias Output = [DMCategory]

    private let categoryRepository: CategoryRepository

    public init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }

    public func execute(input: Input) async throws -> Output {
        try await categoryRepository.deleteCategories(input.categoryIDs)
    }
}
