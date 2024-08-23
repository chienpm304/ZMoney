//
//  FetchTransCategoriesUseCase.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

import Combine

public final class FetchTransCategoriesUseCase: UseCase {
    public typealias ResultValue = (Result<[TransCategory], Error>)

    private let categoryRepository: TransCategoryRepository
    private let completion: (ResultValue) -> Void

    public init(
        categoryRepository: TransCategoryRepository,
        completion: @escaping (ResultValue) -> Void
    ) {
        self.categoryRepository = categoryRepository
        self.completion = completion
    }

    public func execute() -> Cancellable? {
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
