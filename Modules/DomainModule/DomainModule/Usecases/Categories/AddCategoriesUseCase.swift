//
//  AddCategoriesUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 24/08/2024.
//

import Combine

public final class AddCategoriesUseCase: UseCase {
    public struct RequestValue {
        let categories: [DMCategory]

        public init(categories: [DMCategory]) {
            self.categories = categories
        }
    }

    public typealias ResultValue = (Result<[DMCategory], DMError>)

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
        categoryRepository.addCategories(
            requestValue.categories,
            completion: completion
        )
        return nil
    }
}
