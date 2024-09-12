//
//  TransactionsListSceneDIContainer.swift
//  ZMoney
//
//  Created by Chien Pham on 29/08/2024.
//

import Foundation
import DataModule
import DomainModule
import SwiftUI

final class TransactionsListSceneDIContainer {
    struct Dependencies {
        let coreDataStack: CoreDataStack
        let appConfiguration: AppConfiguration
        let transactionDetailDIContainer: TransactionDetailSceneDIContainer
        let searchTransactionsDIContainer: SearchTransactionsDISceneDIContainer
        let categoriesDIContainer: CategoriesSceneDIContainer
    }

    private let dependencies: Dependencies

    lazy var transactionStorage: TransactionStorage = TransactionCoreDataStorage(
        coreData: dependencies.coreDataStack
    )

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: TransactionsListFlowCoordinatorDependencies

extension TransactionsListSceneDIContainer: TransactionsListFlowCoordinatorDependencies {
    func makeTransactionsListViewController(
        actions: TransactionsListViewModelActions
    ) -> (UIViewController, TransactionsListViewModel) {
        let dependencies = TransactionsListViewModel.Dependencies(
            fetchTransactionByTimeUseCaseFactory: makeFetchTransactionsByTimeUseCase,
            actions: actions
        )
        let viewModel = TransactionsListViewModel(dependencies: dependencies)
        let view = TransactionsListWithCalendarView(viewModel: viewModel)
            .environmentObject(self.dependencies.appConfiguration.settings)
        return (UIHostingController(rootView: view), viewModel)
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

    func makeSearchTransactionsFlowCoordinator(
        from navigationController: UINavigationController
    ) -> SearchTransactionsFlowCoordinator {
        dependencies
            .searchTransactionsDIContainer
            .makeSearchTransactionsFlowCoordinator(navigationController: navigationController)
    }

    // MARK: UseCase

    private func makeFetchTransactionsByTimeUseCase(
        requestValue: FetchTransactionsByTimeUseCase.RequestValue,
        completion: @escaping (FetchTransactionsByTimeUseCase.ResultValue) -> Void
    ) -> FetchTransactionsByTimeUseCase {
        FetchTransactionsByTimeUseCase(
            requestValue: requestValue,
            transactionRepository: makeTransactionRepository(),
            completion: completion
        )
    }

    // MARK: Repository

    private func makeTransactionRepository() -> TransactionRepository {
        DefaultTransactionRepository(storage: transactionStorage)
    }

    // MARK: Flow

    func makeTransactionsFlowCoordinator(
        navigationController: UINavigationController
    ) -> TransactionsListFlowCoordinator {
        TransactionsListFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}
