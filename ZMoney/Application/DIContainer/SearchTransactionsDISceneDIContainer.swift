//
//  SearchTransactionsDISceneDIContainer.swift
//  ZMoney
//
//  Created by Chien Pham on 12/09/2024.
//

import Foundation
import DomainModule
import DataModule
import SwiftUI

final class SearchTransactionsDISceneDIContainer {
    struct Dependencies {
        let coreDataStack: CoreDataStack
        let appConfiguration: AppConfiguration
        let transactionDetailDIContainer: TransactionDetailSceneDIContainer
    }

    private let dependencies: Dependencies

    lazy var transactionStorage: TransactionStorage = TransactionCoreDataStorage(
        coreData: dependencies.coreDataStack
    )

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: SearchTransactionsFlowCoordinatorDependencies

extension SearchTransactionsDISceneDIContainer: SearchTransactionsFlowCoordinatorDependencies {
    func makeSearchTransactionsViewController(
        actions: SearchTransactionsViewModelActions
    ) -> (UIViewController, SearchTransactionsViewModel) {
        let dependencies = SearchTransactionsViewModel.Dependencies(
            searchTransactionsUseCaseFactory: makeSearchTransactionsUseCase,
            actions: actions
        )
        let viewModel = SearchTransactionsViewModel(dependencies: dependencies)
        let view = SearchTransactionsView(viewModel: viewModel)
            .environmentObject(self.dependencies.appConfiguration.settings)
        let viewController = UIHostingController(rootView: view)
        viewController.hidesBottomBarWhenPushed = true
        return (viewController, viewModel)
    }

    func makeTransactionDetailFlowCoordinator(
        from navigationController: UINavigationController,
        request: TransactionDetailFlowCoordinator.Request,
        response: TransactionDetailFlowCoordinator.Response?
    ) -> TransactionDetailFlowCoordinator {
        dependencies
            .transactionDetailDIContainer
            .makeTransactionDetailFlowCoordinator(
                navigationController: navigationController,
                request: request,
                response: response
            )
    }

    // MARK: UseCase

    private func makeSearchTransactionsUseCase() -> SearchTransactionsUseCase {
        SearchTransactionsUseCase(repository: makeTransactionRepository())
    }

    // MARK: Repository

    private func makeTransactionRepository() -> TransactionRepository {
        DefaultTransactionRepository(storage: transactionStorage)
    }

    // MARK: Flow

    func makeSearchTransactionsFlowCoordinator(
        navigationController: UINavigationController
    ) -> SearchTransactionsFlowCoordinator {
        SearchTransactionsFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}
