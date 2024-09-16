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
        let monthlyReportTransactionsDIContainer: MonthlyReportTransactionsSceneDIContainer
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
            fetchTransactionsByTimeUseCaseFactory: makeFetchTransactionsReportByCategoriesUseCase,
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

    func makeMonthlyReportTransactionsFlowCoordinator(
        from navigationController: UINavigationController
    ) -> MonthlyReportTransactionsFlowCoordinator {
        dependencies
            .monthlyReportTransactionsDIContainer
            .makeMonthlyReportTransactionsFlowCoordinator(navigationController: navigationController)
    }

    // MARK: UseCase

    private func makeFetchTransactionsReportByCategoriesUseCase()
    -> FetchTransactionsReportByCategoriesUseCase {
        FetchTransactionsReportByCategoriesUseCase(
            transactionRepository: makeTransactionRepository()
        )
    }

    // MARK: Repository

    private func makeTransactionRepository() -> TransactionRepository {
        DefaultTransactionRepository(storage: transactionStorage)
    }
}
