//
//  CategoriesSceneDIContainer.swift
//  ZMoney
//
//  Created by Chien Pham on 19/08/2024.
//

import Foundation
import DataModule
import DomainModule
import SwiftUI

final class CategoriesSceneDIContainer: CategoriesFlowCoordinatorDependencies {
    struct Dependencies {
        let coreDataStack: CoreDataStack
        let appConfiguration: AppConfiguration
    }

    private let dependencies: Dependencies

    lazy var categoryStorage: CategoryStorage = CategoryCoreDataStorage(
        coreData: dependencies.coreDataStack
    )

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: Use Cases

    func makeFetchCategoriesUseCase(
        completion: @escaping (FetchCategoriesUseCase.ResultValue) -> Void
    ) -> UseCase {
        FetchCategoriesUseCase(
            categoryRepository: makeCategoriesRepository(),
            completion: completion
        )
    }

    func makeAddCategoriesUseCase(
        requestValue: AddCategoriesUseCase.RequestValue,
        completion: @escaping (AddCategoriesUseCase.ResultValue) -> Void
    ) -> UseCase {
        AddCategoriesUseCase(
            requestValue: requestValue,
            categoryRepository: makeCategoriesRepository(),
            completion: completion
        )
    }

    func makeUpdateCategoriesUseCase(
        requestValue: UpdateCategoriesUseCase.RequestValue,
        completion: @escaping (UpdateCategoriesUseCase.ResultValue) -> Void
    ) -> UseCase {
        UpdateCategoriesUseCase(
            requestValue: requestValue,
            categoryRepository: makeCategoriesRepository(),
            completion: completion
        )
    }

    func makeDeleteCategoriesUseCase() -> DeleteCategoriesUseCase {
        DeleteCategoriesUseCase(categoryRepository: makeCategoriesRepository())
    }

    // MARK: Repositories

    func makeCategoriesRepository() -> CategoryRepository {
        DefaultCategoryRepository(storage: categoryStorage)
    }

    // MARK: CategoriesFlowCoordinatorDependencies

    func makeCategoriesListViewController(
        type: DMTransactionType,
        actions: CategoriesListViewModelActions
    ) -> (UIViewController, CategoriesListViewModel) {
        let viewModel = makeCategoriesListViewModel(selectedType: type, actions: actions)
        let view = CategoriesListView(viewModel: viewModel)
            .environmentObject(dependencies.appConfiguration.settings)
        let viewController = UIHostingController(rootView: view)
        viewController.hidesBottomBarWhenPushed = true
        return (viewController, viewModel)
    }

    func makeCategoryDetailViewController(
        category: DMCategory,
        isNewCategory: Bool,
        actions: CategoryDetailViewModelActions
    ) -> UIViewController {
        let viewModel = makeCategoryDetailViewModel(
            category: category,
            isNewCategory: isNewCategory,
            actions: actions
        )
        let view = CategoryDetailView(viewModel: viewModel)
            .environmentObject(self.dependencies.appConfiguration.settings)
        let viewController = UIHostingController(rootView: view)
        viewController.hidesBottomBarWhenPushed = true
        return viewController
    }

    // MARK: ViewModel

    func makeCategoriesListViewModel(
        selectedType: DMTransactionType,
        actions: CategoriesListViewModelActions
    ) -> CategoriesListViewModel {
        let dependencies = CategoriesListViewModel.Dependencies(
            fetchUseCaseFactory: makeFetchCategoriesUseCase,
            updateUseCaseFactory: makeUpdateCategoriesUseCase,
            deleteUseCaseFactory: makeDeleteCategoriesUseCase,
            actions: actions
        )
        return CategoriesListViewModel(selectedType: selectedType, dependencies: dependencies)
    }

    func makeCategoryDetailViewModel(
        category: DMCategory,
        isNewCategory: Bool,
        actions: CategoryDetailViewModelActions
    ) -> CategoryDetailViewModel {
        let dependencies = CategoryDetailViewModel.Dependencies(
            addUseCaseFactory: makeAddCategoriesUseCase,
            updateUseCaseFactory: makeUpdateCategoriesUseCase,
            actions: actions
        )
        return CategoryDetailViewModel(
            category: category,
            isNewCategory: isNewCategory,
            dependencies: dependencies
        )
    }

    // MARK: - Flow

    func makeCategoriesFlowCoordinator(
        navigationController: UINavigationController
    ) -> CategoriesFlowCoordinator {
        CategoriesFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}
