//
//  FetchCategoriesUseCase.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

import Combine

public final class FetchCategoriesUseCase: AsyncUseCase {
    public typealias Input = Void
    public typealias Output = [DMCategory]

    private let categoryRepository: CategoryRepository

    public init(
        categoryRepository: CategoryRepository
    ) {
        self.categoryRepository = categoryRepository
    }

    public func execute(input: Void) async throws -> [DMCategory] {
        let categories = try await categoryRepository.fetchCategories()
        guard !categories.isEmpty else {
            let generatedCategories = await generateDefaultCategories()
            let addedCategories = try await categoryRepository.addCategories(generatedCategories)
            return addedCategories
        }
        return categories
    }

    private func generateDefaultCategories() async -> [DMCategory] {
        await categoryRepository.fetchDefaultCategories()
    }
}
