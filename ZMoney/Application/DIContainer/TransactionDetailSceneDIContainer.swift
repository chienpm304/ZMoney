//
//  TransactionDetailSceneDIContainer.swift
//  ZMoney
//
//  Created by Chien Pham on 05/09/2024.
//

import Foundation
import DataModule
import DomainModule
import SwiftUI

final class TransactionDetailSceneDIContainer: TransactionDetailFlowCoordinatorDependencies {
    struct Dependencies {
        let coreDataStack: CoreDataStack
        let appConfiguration: AppConfiguration
        let categoriesDIContainer: CategoriesSceneDIContainer
    }

    private let dependencies: Dependencies

    lazy var transactionStorage: TransactionStorage = TransactionCoreDataStorage(
        coreData: dependencies.coreDataStack
    )

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: Flow

    func makeTransactionDetailFlowCoordinator(
        navigationController: UINavigationController,
        request: TransactionDetailFlowCoordinator.Request,
        response: TransactionDetailFlowCoordinator.Response?
    ) -> TransactionDetailFlowCoordinator {
        TransactionDetailFlowCoordinator(
            navigationController: navigationController,
            dependencies: self,
            request: request,
            response: response
        )
    }

    // MARK: TransactionDetailFlowCoordinatorDependencies

    func makeTransactionDetailViewController(
        forNewTransactionAt inputDate: Date?,
        forEditTransaction transaction: DMTransaction?,
        actions: TransactionDetailViewModelActions,
        navigationType: NavigationType
    ) -> UIViewController {
        let viewModel = makeTransactionDetailViewModel(
            forNewTransactionAt: inputDate,
            forEditTransaction: transaction,
            actions: actions
        )
        let view = TransactionDetailView(viewModel: viewModel, navigationType: navigationType)
            .environmentObject(dependencies.appConfiguration.settings)
        return UIHostingController(rootView: view)
    }

    func makeCategoriesFlowCoordinator(
        from navigationController: UINavigationController
    ) -> CategoriesFlowCoordinator {
        dependencies
            .categoriesDIContainer
            .makeCategoriesFlowCoordinator(navigationController: navigationController)
    }

    // MARK: ViewModel

    func makeTransactionDetailViewModel(
        forNewTransactionAt inputDate: Date?,
        forEditTransaction transaction: DMTransaction?,
        actions: TransactionDetailViewModelActions
    ) -> TransactionDetailViewModel {
        let dependencies = TransactionDetailViewModel.Dependencies(
            actions: actions,
            fetchCategoriesUseCaseFactory: makeFetchCategoriesUseCase,
            addTransactionsUseCaseFactory: makeAddTransactionsUseCase,
            updateTransactionsUseCaseFactory: makeUpdateTransactionsUseCase,
            deleteTransactionsUseCaseFactory: makeDeleteTransactionsUseCase
        )
        if let transaction {
            return TransactionDetailViewModel(
                forEditTransaction: transaction,
                dependencies: dependencies
            )
        } else {
            return TransactionDetailViewModel(
                forNewTransactionAt: inputDate,
                dependencies: dependencies
            )
        }
    }

    // MARK: UseCases

    func makeFetchCategoriesUseCase() -> FetchCategoriesUseCase {
        let categoryRepository = dependencies.categoriesDIContainer.makeCategoriesRepository()
        return FetchCategoriesUseCase(categoryRepository: categoryRepository)
    }

    private func fetchTransactionByIDUseCaseFactory(
        requestValue: FetchTransactionByIDUseCase.RequestValue,
        completion: @escaping (FetchTransactionByIDUseCase.ResultValue) -> Void
    ) -> FetchTransactionByIDUseCase {
        FetchTransactionByIDUseCase(
            requestValue: requestValue,
            transactionRepository: makeTransactionRepository(),
            completion: completion
        )
    }

    private func makeAddTransactionsUseCase(
        requestValue: AddTransactionsUseCase.RequestValue,
        completion: @escaping (AddTransactionsUseCase.ResultValue) -> Void
    ) -> AddTransactionsUseCase {
        AddTransactionsUseCase(
            requestValue: requestValue,
            transactionRepository: makeTransactionRepository(),
            completion: completion
        )
    }

    private func makeUpdateTransactionsUseCase() -> UpdateTransactionsUseCase {
        UpdateTransactionsUseCase(transactionRepository: makeTransactionRepository())
    }

    private func makeDeleteTransactionsUseCase() -> DeleteTransactionsByIDsUseCase {
        DeleteTransactionsByIDsUseCase(transactionRepository: makeTransactionRepository())
    }

    // MARK: Repository

    private func makeTransactionRepository() -> TransactionRepository {
        DefaultTransactionRepository(storage: transactionStorage)
    }
}
