//
//  UpdateCategoriesUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 23/08/2024.
//

import Combine

public final class UpdateCategoriesUseCase: UseCase {
    public struct RequestValue {
        let categories: [DMCategory]
        let needUpdateSortOrder: Bool

        public init(categories: [DMCategory], needUpdateSortOrder: Bool = false) {
            self.categories = categories
            self.needUpdateSortOrder = needUpdateSortOrder
        }
    }

    public typealias ResultValue = (Result<[DMCategory], Error>)

    private let requestValue: RequestValue
    private let categoryRepository: CategoryRepository
    private let completion: (ResultValue) -> Void

    public init(
        requestValue: RequestValue,
        categoryRepository: CategoryRepository,
        completion: @escaping (ResultValue) -> Void
    ) {
        self.requestValue = requestValue
        self.categoryRepository = categoryRepository
        self.completion = completion
    }

    public func execute() -> Cancellable? {
        let toUpdateCategories: [DMCategory]
        if requestValue.needUpdateSortOrder {
            toUpdateCategories = requestValue.categories.enumerated().map { index, category in
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
            toUpdateCategories = requestValue.categories
        }
        categoryRepository.updateCategories(
            toUpdateCategories,
            completion: completion
        )
        return nil
    }
}
