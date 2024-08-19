//
//  FetchAllTransCategoriesUseCase.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

import Combine

final class FetchAllTransCategoriesUseCase: UseCase {
    typealias ResultValue = (Result<[TransCategory], Error>)

    private let completion: (ResultValue) -> Void
    private let categoryRepository: TransCategoryRepository

    init(
        completion: @escaping (ResultValue) -> Void,
        categoryRepository: TransCategoryRepository
    ) {
        self.completion = completion
        self.categoryRepository = categoryRepository
    }

    func start() -> Cancellable? {
        categoryRepository.fetchAllTransCategories(completion: completion)
        return nil
    }
}
