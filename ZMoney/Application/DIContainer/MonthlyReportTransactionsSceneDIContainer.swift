//
//  MonthlyReportTransactionsSceneDIContainer.swift
//  ZMoney
//
//  Created by Chien Pham on 16/09/2024.
//

import Foundation
import DataModule
import DomainModule
import SwiftUI

final class MonthlyReportTransactionsSceneDIContainer {
    struct Dependencies {
        let coreDataStack: CoreDataStack
        let appConfiguration: AppConfiguration
    }

    private let dependencies: Dependencies

    lazy var transactionStorage: TransactionStorage = TransactionCoreDataStorage(
        coreData: dependencies.coreDataStack
    )

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: Flow

    func makeMonthlyReportTransactionsFlowCoordinator(
        navigationController: UINavigationController
    ) -> MonthlyReportTransactionsFlowCoordinator {
        MonthlyReportTransactionsFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
}

extension MonthlyReportTransactionsSceneDIContainer: MonthlyReportTransactionsFlowCoordinatorDependencies {
    func makeMonthlyReportTransactionsViewController(
        category: DMCategory,
        dateRange: DateRange,
        actions: MonthlyReportTransactionsViewModelActions
    ) -> (UIViewController, MonthlyReportTransactionsViewModel) {
        let dependencies = MonthlyReportTransactionsViewModel.Dependencies(
            getMonthlyTransactionsReportUseCaseFactory: makeGetMonthlyTransactionsReportUseCase,
            actions: actions

        )
        let viewModel = MonthlyReportTransactionsViewModel(
            category: category,
            dateRange: dateRange,
            dependencies: dependencies
        )
        let view = MonthlyReportTransactionsView(viewModel: viewModel)
            .environmentObject(self.dependencies.appConfiguration.settings)
        let viewController = UIHostingController(rootView: view)
        viewController.hidesBottomBarWhenPushed = true
        return (viewController, viewModel)
    }

    // MARK: UseCase

    private func makeGetMonthlyTransactionsReportUseCase(
    ) -> GetMonthlyTransactionsReportByCategoryUseCase {
        GetMonthlyTransactionsReportByCategoryUseCase(
            fetchTransactionsByCategoryUseCase: makeFetchTransactionsByCategoriesUseCase()
        )
    }

    private func makeFetchTransactionsByCategoriesUseCase() -> FetchTransactionsByCategoriesUseCase {
        FetchTransactionsByCategoriesUseCase(transactionRepository: makeTransactionRepository())
    }

    // MARK: Repository

    private func makeTransactionRepository() -> TransactionRepository {
        DefaultTransactionRepository(storage: transactionStorage)
    }

}
