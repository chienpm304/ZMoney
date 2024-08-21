//
//  TransCategoriesSceneDIContainer.swift
//  ZMoney
//
//  Created by Chien Pham on 19/08/2024.
//

import Foundation
import DataModule
import DomainModule
import SwiftUI

final class TransCategoriesSceneDIContainer: TransCategoriesFlowCoordinatorDependencies {

    struct Dependencies {

    }

    private let dependencies: Dependencies
    lazy var transCategoryStorage: TransCategoryStorage = TransCategoryCoreDataStorage()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: Use Cases

    func makeFetchTransCategoriesUseCase(
        completion: @escaping (FetchTransCategoriesUseCase.ResultValue) -> Void
    ) -> UseCase {
        FetchTransCategoriesUseCase(
            completion: completion,
            categoryRepository: makeTransCategoriesRepository()
        )
    }

    // MARK: Repositories

    func makeTransCategoriesRepository() -> TransCategoryRepository {
        DefaultTransCategoryRepository(storage: transCategoryStorage)
    }

    // MARK: TransCategoriesFlowCoordinatorDependencies

    func makeTransCategoryListViewController() -> UIViewController {
        let view = TransCategoryListView(transCategoryStorage: transCategoryStorage)
        return UIHostingController(rootView: view)
    }

    // MARK: - Flow

    func makeTransCategoriesFlowCoordinator(
        navigationController: UINavigationController
    ) -> TransCategoriesFlowCoordinator {
        TransCategoriesFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }

}
