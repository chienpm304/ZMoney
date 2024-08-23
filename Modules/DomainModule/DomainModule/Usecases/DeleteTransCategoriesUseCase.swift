//
//  DeleteTransCategoriesUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 23/08/2024.
//

import Combine

public final class DeleteTransCategoriesUseCase: UseCase {
    public struct RequestValue {
        let categoryIDs: [ID]
        public init(categoryIDs: [ID]) {
            self.categoryIDs = categoryIDs
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
        categoryRepository.deleteTransCategories(
            requestValue.categoryIDs,
            completion: completion
        )
        return nil
    }
}
