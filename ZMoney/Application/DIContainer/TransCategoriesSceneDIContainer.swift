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
        let coreDataStack: CoreDataStack
    }

    private let dependencies: Dependencies

    lazy var transCategoryStorage: TransCategoryStorage = TransCategoryCoreDataStorage(
        coreData: dependencies.coreDataStack
    )

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: Use Cases
    func makeTransCategoriesUseCaseFactory() -> TransCategoriesUseCaseFactory {
        TransCategoriesUseCaseFactory(
            fetchUseCase: makeFetchTransCategoriesUseCase,
            addUseCase: makeAddTransCategoriesUseCase,
            updateUseCase: makeUpdateTransCategoriesUseCase,
            deleteUseCase: makeDeleteTransCategoriesUseCase
        )
    }
    func makeFetchTransCategoriesUseCase(
        completion: @escaping (FetchTransCategoriesUseCase.ResultValue) -> Void
    ) -> UseCase {
        FetchTransCategoriesUseCase(
            categoryRepository: makeTransCategoriesRepository(),
            completion: completion
        )
    }

    func makeAddTransCategoriesUseCase(
        requestValue: AddTransCategoriesUseCase.RequestValue,
        completion: @escaping (AddTransCategoriesUseCase.ResultValue) -> Void
    ) -> UseCase {
        AddTransCategoriesUseCase(
            requestValue: requestValue,
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

    func makeDeleteTransCategoriesUseCase(
        requestValue: DeleteTransCategoriesUseCase.RequestValue,
        completion: @escaping (DeleteTransCategoriesUseCase.ResultValue) -> Void
    ) -> UseCase {
        DeleteTransCategoriesUseCase(
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

    func makeTransCategoryDetailViewController(
        category: TransCategory,
        isNewCategory: Bool,
        actions: TransCategoryDetailViewModelActions
    ) -> UIViewController {
        let viewModel = makeTransCategoryDetailViewModel(
            category: category,
            isNewCategory: isNewCategory,
            actions: actions
        )
        let view = TransCategoryDetailView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }

    // MARK: ViewModel

    func makeTransCategoriesListViewModel(
        actions: TransCategoriesListViewModelActions
    ) -> TransCategoriesListViewModel {
        let dependencies = TransCategoriesListViewModel.Dependencies(
            useCaseFactory: makeTransCategoriesUseCaseFactory(),
            actions: actions
        )
        return TransCategoriesListViewModel(dependencies: dependencies)
    }

    func makeTransCategoryDetailViewModel(
        category: TransCategory,
        isNewCategory: Bool,
        actions: TransCategoryDetailViewModelActions
    ) -> TransCategoryDetailViewModel {
        let dependencies = TransCategoryDetailViewModel.Dependencies(
            useCaseFactory: makeTransCategoriesUseCaseFactory(),
            actions: actions
        )
        return TransCategoryDetailViewModel(
            category: category,
            isNewCategory: isNewCategory,
            dependencies: dependencies
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
