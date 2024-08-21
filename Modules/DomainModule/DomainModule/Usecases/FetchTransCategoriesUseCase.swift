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
        categoryRepository.fetchAllTransCategories { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let categories):
                guard !categories.isEmpty else {
                    let generatedCategories = self.generateDefaultCategories()
                    self.categoryRepository.addTransCategories(generatedCategories, completion: completion)
                    return
                }
                self.completion(.success(categories))
            case .failure(let error):
                self.completion(.failure(error))
            }
        }
        return nil
    }

    private func generateDefaultCategories() -> [TransCategory] {
        TransCategory.defaultExpenseCategories + TransCategory.defaultIncomeCategories
    }
}
