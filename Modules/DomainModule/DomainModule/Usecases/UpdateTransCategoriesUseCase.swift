//
//  UpdateTransCategoriesUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 23/08/2024.
//

import Combine

public final class UpdateTransCategoriesUseCase: UseCase {
    public struct RequestValue {
        let categories: [TransCategory]
        let needUpdateSortOrder: Bool

        public init(categories: [TransCategory], needUpdateSortOrder: Bool = false) {
            self.categories = categories
            self.needUpdateSortOrder = needUpdateSortOrder
        }
    }

    public typealias ResultValue = (Result<[TransCategory], Error>)

    private let requestValue: RequestValue
    private let categoryRepository: TransCategoryRepository
    private let completion: (ResultValue) -> Void

    public init(
        requestValue: RequestValue,
        categoryRepository: TransCategoryRepository,
        completion: @escaping (ResultValue) -> Void
    ) {
        self.requestValue = requestValue
        self.categoryRepository = categoryRepository
        self.completion = completion
    }

    public func execute() -> Cancellable? {
        let toUpdateCategories: [TransCategory]
        if requestValue.needUpdateSortOrder {
            toUpdateCategories = requestValue.categories.enumerated().map { index, category in
                TransCategory(
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
        categoryRepository.updateTransCategories(
            toUpdateCategories,
            completion: completion
        )
        return nil
    }
}
