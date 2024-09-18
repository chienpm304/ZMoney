//
//  MonthlyReportTransactionsDetailSceneDIContainer.swift
//  ZMoney
//
//  Created by Chien Pham on 18/09/2024.
//

import Foundation
import DataModule
import DomainModule
import SwiftUI

final class MonthlyReportTransactionsDetailSceneDIContainer {
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

    // MARK: Flow

    func makeMonthlyReportTransactionsDetailFlowCoordinator(
        navigationController: UINavigationController
    ) -> MonthlyReportTransactionsDetailFlowCoordinator {
        MonthlyReportTransactionsDetailFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}

extension MonthlyReportTransactionsDetailSceneDIContainer: MonthlyReportTransactionsDetailFlowCoordinatorDependencies {
    func makeMonthlyReportTransactionsDetailViewController(
        category: DomainModule.DMCategory,
        fullDateRange: DateRange,
        selectedDateRange: DateRange,
        actions: MonthlyReportTransactionsDetailViewModel.Actions
    ) -> (UIViewController, MonthlyReportTransactionsDetailViewModel) {
        let dependencies = MonthlyReportTransactionsDetailViewModel.Dependencies(
            actions: actions,
            getTransactionsByCategoriesUseCaseFactory: makeFetchTransactionsByCategoriesUseCase
        )
        let viewModel = MonthlyReportTransactionsDetailViewModel(
            category: category,
            fullDateRange: fullDateRange,
            selectedDateRange: selectedDateRange,
            dependencies: dependencies
        )
        let view = MonthlyReportTransactionsDetailView(viewModel: viewModel)
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

    private func makeFetchTransactionsByCategoriesUseCase() -> FetchTransactionsByCategoriesUseCase {
        FetchTransactionsByCategoriesUseCase(transactionRepository: makeTransactionRepository())
    }

    // MARK: Repository

    private func makeTransactionRepository() -> TransactionRepository {
        DefaultTransactionRepository(storage: transactionStorage)
    }

}
