//
//  AddCategoriesUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 24/08/2024.
//

import Combine

public final class AddCategoriesUseCase: AsyncUseCase {
    public struct Input {
        let categories: [DMCategory]

        public init(categories: [DMCategory]) {
            self.categories = categories
        }
    }

    public typealias Output = [DMCategory]

    private let categoryRepository: CategoryRepository

    public init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }

    public func execute(input: Input) async throws -> [DMCategory] {
        try await categoryRepository.addCategories(input.categories)
    }
}
