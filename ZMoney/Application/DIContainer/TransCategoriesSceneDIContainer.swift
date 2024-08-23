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
            categoryRepository: makeTransCategoriesRepository(),
            completion: completion
        )
    }

    func makeUpdateTransCategoriesUseCase(
        requestValue: UpdateTransCategoriesUseCase.RequestValue,
        completion: @escaping (UpdateTransCategoriesUseCase.ResultValue) -> Void
    ) -> UseCase {
        UpdateTransCategoriesUseCase(
            requestValue: requestValue,
            categoryRepository: makeTransCategoriesRepository(),
            completion: completion
        )
    }

    // MARK: Repositories

    func makeTransCategoriesRepository() -> TransCategoryRepository {
        DefaultTransCategoryRepository(storage: transCategoryStorage)
    }

    // MARK: TransCategoriesFlowCoordinatorDependencies

    func makeTransCategoriesListViewController(
        actions: TransCategoriesListViewModelActions
    ) -> UIViewController {
        let viewModel = makeTransCategoriesListViewModel(actions: actions)
        let view = TransCategoriesListView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }

    func makeTransCategoriesListViewModel(
        actions: TransCategoriesListViewModelActions
    ) -> TransCategoriesListViewModel {
        return TransCategoriesListViewModel(
            fetchTransCategoriesUseCaseFactory: makeFetchTransCategoriesUseCase,
            updateTransCategoriesUseCaseFactory: makeUpdateTransCategoriesUseCase,
            actions: actions
        )
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
