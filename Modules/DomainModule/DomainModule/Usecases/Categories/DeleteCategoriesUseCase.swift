//
//  DeleteCategoriesUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 23/08/2024.
//

import Combine

public final class DeleteCategoriesUseCase: UseCase {
    public struct RequestValue {
        let categoryIDs: [ID]

        public init(categoryIDs: [ID]) {
            self.categoryIDs = categoryIDs
        }
    }

    public typealias ResultValue = (Result<[DMCategory], CategoryDeleteError>)

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
        categoryRepository.deleteCategories(
            requestValue.categoryIDs,
            completion: completion
        )
        return nil
    }
}
