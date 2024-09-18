//
//  MonthlyReportTransactionsDetailFlowCoordinator.swift
//  ZMoney
//
//  Created by Chien Pham on 18/09/2024.
//

import Foundation
import DomainModule
import SwiftUI

protocol MonthlyReportTransactionsDetailFlowCoordinatorDependencies {
    func makeMonthlyReportTransactionsDetailViewController(
        category: DMCategory,
        fullDateRange: DateRange,
        selectedDateRange: DateRange,
        actions: MonthlyReportTransactionsDetailViewModel.Actions
    ) -> (UIViewController, MonthlyReportTransactionsDetailViewModel)

    func makeTransactionDetailFlowCoordinator(
        from navigationController: UINavigationController,
        request: TransactionDetailFlowCoordinator.Request,
        response: TransactionDetailFlowCoordinator.Response?
    ) -> TransactionDetailFlowCoordinator
}

final class MonthlyReportTransactionsDetailFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: MonthlyReportTransactionsDetailFlowCoordinatorDependencies
    private var hostViewController: UIViewController?
    private var hostViewModel: MonthlyReportTransactionsDetailViewModel?

    init(
        navigationController: UINavigationController? = nil,
        dependencies: MonthlyReportTransactionsDetailFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start(
        category: DMCategory,
        fullDateRange: DateRange,
        selectedDateRange: DateRange
    ) {
        let actions = MonthlyReportTransactionsDetailViewModel.Actions(
            didTapTransaction: handleDidTapTransaction,
            didFinishPresentation: handleDidFinishPresentReportDetail

        )
        let reportView = dependencies.makeMonthlyReportTransactionsDetailViewController(
            category: category,
            fullDateRange: fullDateRange,
            selectedDateRange: selectedDateRange,
            actions: actions
        )
        hostViewController = reportView.0
        hostViewModel = reportView.1
        navigationController?.pushViewController(reportView.0, animated: true)
    }

    private func handleDidTapTransaction(_ transaction: DMTransaction) {
        guard let navigationController else { return }
        let request = TransactionDetailFlowCoordinator.Request(
            navigationType: .present,
            newTransactionInputDate: nil,
            editTransaction: transaction
        )

        let response = TransactionDetailFlowCoordinator.Response { [weak self] _ in
            Task { @MainActor [weak self] in
                await self?.hostViewModel?.refreshData()
            }
        } didCancelTransactionDetail: {
            // do nothing
        }

        dependencies
            .makeTransactionDetailFlowCoordinator(
                from: navigationController,
                request: request,
                response: response
            )
            .start()
    }

    private func handleDidFinishPresentReportDetail() {
        Task { @MainActor [weak self] in
            await self?.hostViewModel?.refreshData()
        }
    }
}
