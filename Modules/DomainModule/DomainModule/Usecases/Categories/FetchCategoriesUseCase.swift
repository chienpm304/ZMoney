//
//  FetchCategoriesUseCase.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

import Combine

public final class FetchCategoriesUseCase: UseCase {
    public typealias ResultValue = (Result<[DMCategory], DMError>)

    private let categoryRepository: CategoryRepository
    private let completion: (ResultValue) -> Void

    public init(
        categoryRepository: CategoryRepository,
        completion: @escaping (ResultValue) -> Void
    ) {
        self.categoryRepository = categoryRepository
        self.completion = completion
    }

    public func execute() -> Cancellable? {
        categoryRepository.fetchCategories { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let categories):
                guard !categories.isEmpty else {
                    let generatedCategories = self.generateDefaultCategories()
                    self.categoryRepository.addCategories(generatedCategories) { result in
                        print("[Category] Generated default categories")
                        self.completion(result)
                    }
                    return
                }
                self.completion(.success(categories))
            case .failure(let error):
                self.completion(.failure(error))
            }
        }
        return nil
    }

    private func generateDefaultCategories() -> [DMCategory] {
        DMCategory.defaultExpenseCategories + DMCategory.defaultIncomeCategories
    }
}
