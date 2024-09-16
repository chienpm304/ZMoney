//
//  ReportTransactionsFlowCoordinator.swift
//  ZMoney
//
//  Created by Chien Pham on 14/09/2024.
//

import Foundation
import DomainModule

protocol ReportTransactionsFlowCoordinatorDependencies {
    func makeReportTransactionsViewController(
        actions: ReportTransactionsViewModelActions
    ) -> (UIViewController, ReportTransactionsViewModel)

    func makeSearchTransactionsFlowCoordinator(
        from navigationController: UINavigationController
    ) -> SearchTransactionsFlowCoordinator

    func makeMonthlyReportTransactionsFlowCoordinator(
        from navigationController: UINavigationController
    ) -> MonthlyReportTransactionsFlowCoordinator
}

final class ReportTransactionsFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: ReportTransactionsFlowCoordinatorDependencies
    private var hostViewController: UIViewController?
    private var hostViewModel: ReportTransactionsViewModel?

    init(
        navigationController: UINavigationController? = nil,
        dependencies: ReportTransactionsFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let actions = ReportTransactionsViewModelActions(
            didTapReportItem: reportDetailView,
            didTapSearch: searchTransactions
        )
        let reportView = dependencies.makeReportTransactionsViewController(actions: actions)
        hostViewController = reportView.0
        hostViewModel = reportView.1
        navigationController?.pushViewController(reportView.0, animated: true)
    }

    private func reportDetailView(
        category: DMCategory,
        dateRange: DateRange,
        dateRangeType: DateRangeType
    ) {
        switch dateRangeType {
        case .month:
            // TODO: handle monthly detail as well
            return
        case .year:
            monthlyReportTransactionsView(dateRange: dateRange, category: category)
        }
    }

    private func monthlyReportTransactionsView(dateRange: DateRange, category: DMCategory) {
        guard let navigationController else { return }
        let newDateRange = DateRange(
            startDate: dateRange.startDate.dateAtStartOf(.year),
            endDate: dateRange.endDate.dateAtEndOf(.year)
        )
        dependencies
            .makeMonthlyReportTransactionsFlowCoordinator(from: navigationController)
            .start(category: category, dateRange: newDateRange)
    }

    private func searchTransactions() {
        guard let navigationController else { return }
        dependencies
            .makeSearchTransactionsFlowCoordinator(from: navigationController)
            .start()
    }
}
