//
//  AddTransCategoriesUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 24/08/2024.
//

import Combine

public final class AddTransCategoriesUseCase: UseCase {
    public struct RequestValue {
        let categories: [TransCategory]

        public init(categories: [TransCategory]) {
            self.categories = categories
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
        categoryRepository.addTransCategories(
            requestValue.categories,
            completion: completion
        )
        return nil
    }
}
