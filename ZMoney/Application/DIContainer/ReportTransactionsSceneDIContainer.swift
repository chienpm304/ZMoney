//
//  ReportTransactionsSceneDIContainer.swift
//  ZMoney
//
//  Created by Chien Pham on 14/09/2024.
//

import Foundation
import DataModule
import DomainModule
import SwiftUI

final class ReportTransactionsSceneDIContainer {
    struct Dependencies {
        let coreDataStack: CoreDataStack
        let appConfiguration: AppConfiguration
        let searchTransactionsDIContainer: SearchTransactionsDISceneDIContainer
    }

    private let dependencies: Dependencies

    lazy var transactionStorage: TransactionStorage = TransactionCoreDataStorage(
        coreData: dependencies.coreDataStack
    )

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: Flow

    func makeReportTransactionsFlowCoordinator(
        navigationController: UINavigationController
    ) -> ReportTransactionsFlowCoordinator {
        ReportTransactionsFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}

extension ReportTransactionsSceneDIContainer: ReportTransactionsFlowCoordinatorDependencies {
    func makeReportTransactionsViewController(
        actions: ReportTransactionsViewModelActions
    ) -> (UIViewController, ReportTransactionsViewModel) {
        let dependencies = ReportTransactionsViewModel.Dependencies(
            fetchTransactionsByTimeUseCaseFactory: makeFetchTransactionsByTimeUseCase,
            actions: actions
        )
        let viewModel = ReportTransactionsViewModel(dependencies: dependencies)
        let view = ReportTransactionsView(viewModel: viewModel)
            .environmentObject(self.dependencies.appConfiguration.settings)
        return (UIHostingController(rootView: view), viewModel)
    }

    func makeSearchTransactionsFlowCoordinator(
        from navigationController: UINavigationController
    ) -> SearchTransactionsFlowCoordinator {
        dependencies
            .searchTransactionsDIContainer
            .makeSearchTransactionsFlowCoordinator(navigationController: navigationController)
    }

    // MARK: UseCase

    private func makeFetchTransactionsByTimeUseCase() -> FetchTransactionsByTimeAsyncUseCase {
        FetchTransactionsByTimeAsyncUseCase(
            transactionRepository: makeTransactionRepository()
        )
    }

    // MARK: Repository

    private func makeTransactionRepository() -> TransactionRepository {
        DefaultTransactionRepository(storage: transactionStorage)
    }
}
