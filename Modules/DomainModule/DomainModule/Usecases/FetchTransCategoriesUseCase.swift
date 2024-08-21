//
//  FetchTransCategoriesUseCase.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

import Combine

public final class FetchTransCategoriesUseCase: UseCase {
    public typealias ResultValue = (Result<[TransCategory], Error>)

    private let completion: (ResultValue) -> Void
    private let categoryRepository: TransCategoryRepository

    public init(
        completion: @escaping (ResultValue) -> Void,
        categoryRepository: TransCategoryRepository
    ) {
        self.completion = completion
        self.categoryRepository = categoryRepository
    }

    public func start() -> Cancellable? {
        categoryRepository.fetchAllTransCategories(completion: completion)
        return nil
    }
}
