//
//  UpdateCategoriesUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 23/08/2024.
//

import Combine

public final class UpdateCategoriesUseCase: AsyncUseCase {
    public struct Input {
        let categories: [DMCategory]
        let needUpdateSortOrder: Bool

        public init(categories: [DMCategory], needUpdateSortOrder: Bool = false) {
            self.categories = categories
            self.needUpdateSortOrder = needUpdateSortOrder
        }
    }

    public typealias Output = [DMCategory]

    private let categoryRepository: CategoryRepository

    public init(categoryRepository: CategoryRepository) {
        self.categoryRepository = categoryRepository
    }

    public func execute(input: Input) async throws -> [DMCategory] {
        let toUpdateCategories: [DMCategory]
        if input.needUpdateSortOrder {
            toUpdateCategories = input.categories.enumerated().map { index, category in
                DMCategory(
                    id: category.id,
                    name: category.name,
                    icon: category.icon,
                    color: category.color,
                    sortIndex: Index(index),
                    type: category.type
                )
            }
        } else {
            toUpdateCategories = input.categories
        }
        return try await categoryRepository.updateCategories(toUpdateCategories)
    }
}
