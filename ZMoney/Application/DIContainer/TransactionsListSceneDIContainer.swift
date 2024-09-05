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
        let useCaseFactory = makeTransactionsUseCaseFactory()
        let dependencies = TransactionsListViewModel.Dependencies(
            useCaseFactory: useCaseFactory,
            actions: actions
        )
        let viewModel = TransactionsListViewModel(dependencies: dependencies)
        let view = TransactionsListView(viewModel: viewModel)
            .environmentObject(self.dependencies.appConfiguration.settings)
        return (UIHostingController(rootView: view), viewModel)
    }

    func makeTransactionDetailFlowCoordinator(
        from navigationController: UINavigationController,
        request: TransactionDetailFlowCoordinator.Request
    ) -> TransactionDetailFlowCoordinator {
        dependencies
            .transactionDetailDIContainer
            .makeTransactionDetailFlowCoordinator(
                navigationController: navigationController,
                request: request
            )
    }

    // MARK: UseCase

    private func makeTransactionsUseCaseFactory() -> TransactionsUseCaseFactory {
        return TransactionsUseCaseFactory(
            fetchByIDUseCase: fetchTransactionByIDUserCaseFactory,
            fetchByTimeUseCase: fetchTransactionsByTimeUserCaseFactory(requestValue:completion:),
            addUseCase: addTransactionsUserCaseFactory(requestValue:completion:),
            updateUseCase: updateTransactionsUserCaseFactory(requestValue:completion:),
            deleteUseCase: deleteTransactionsUserCaseFactory(requestValue:completion:)
        )
    }

    private func fetchTransactionByIDUserCaseFactory(
        requestValue: FetchTransactionByIDUseCase.RequestValue,
        completion: @escaping (FetchTransactionByIDUseCase.ResultValue) -> Void
    ) -> FetchTransactionByIDUseCase {
        FetchTransactionByIDUseCase(
            requestValue: requestValue,
            transactionRepository: makeTransactionRepository(),
            completion: completion
        )
    }

    private func fetchTransactionsByTimeUserCaseFactory(
        requestValue: FetchTransactionsByTimeUseCase.RequestValue,
        completion: @escaping (FetchTransactionsByTimeUseCase.ResultValue) -> Void
    ) -> FetchTransactionsByTimeUseCase {
        FetchTransactionsByTimeUseCase(
            requestValue: requestValue,
            transactionRepository: makeTransactionRepository(),
            completion: completion
        )
    }

    private func addTransactionsUserCaseFactory(
        requestValue: AddTransactionsUseCase.RequestValue,
        completion: @escaping (AddTransactionsUseCase.ResultValue) -> Void
    ) -> AddTransactionsUseCase {
        AddTransactionsUseCase(
            requestValue: requestValue,
            transactionRepository: makeTransactionRepository(),
            completion: completion
        )
    }

    private func updateTransactionsUserCaseFactory(
        requestValue: UpdateTransactionsUseCase.RequestValue,
        completion: @escaping (UpdateTransactionsUseCase.ResultValue) -> Void
    ) -> UpdateTransactionsUseCase {
        UpdateTransactionsUseCase(
            requestValue: requestValue,
            transactionRepository: makeTransactionRepository(),
            completion: completion
        )
    }

    private func deleteTransactionsUserCaseFactory(
        requestValue: DeleteTransactionsByIDsUseCase.RequestValue,
        completion: @escaping (DeleteTransactionsByIDsUseCase.ResultValue) -> Void
    ) -> DeleteTransactionsByIDsUseCase {
        DeleteTransactionsByIDsUseCase(
            requestValue: requestValue,
            transactionRepository: makeTransactionRepository(),
            completion: completion
        )
    }

    func makeFetchCategoriesUseCase(
        completion: @escaping (FetchCategoriesUseCase.ResultValue) -> Void
    ) -> UseCase {
        let categoryRepository = dependencies.categoriesDIContainer.makeCategoriesRepository()
        return FetchCategoriesUseCase(categoryRepository: categoryRepository, completion: completion)
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
