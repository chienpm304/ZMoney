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

    func makeMonthlyReportTransactionsDetailFlowCoordinator(
        from navigationController: UINavigationController
    ) -> MonthlyReportTransactionsDetailFlowCoordinator
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
            monthlyReportTransactionsDetailView(dateRange: dateRange, category: category)
            return
        case .year:
            monthlyReportTransactionsView(dateRange: dateRange, category: category)
        }
    }

    private func monthlyReportTransactionsDetailView(dateRange: DateRange, category: DMCategory) {
        guard let navigationController else { return }
        let fullDateRange = DateRange(
            startDate: dateRange.startDate.dateAtStartOf(.year),
            endDate: dateRange.startDate.dateAtEndOf(.year)
        )
        dependencies
            .makeMonthlyReportTransactionsDetailFlowCoordinator(from: navigationController)
            .start(
                category: category,
                fullDateRange: fullDateRange,
                selectedDateRange: dateRange
            )
    }

    private func monthlyReportTransactionsView(dateRange: DateRange, category: DMCategory) {
        guard let navigationController else { return }
        let yearDateRange = DateRange(
            startDate: dateRange.startDate.dateAtStartOf(.year),
            endDate: dateRange.endDate.dateAtEndOf(.year)
        )
        dependencies
            .makeMonthlyReportTransactionsFlowCoordinator(from: navigationController)
            .start(category: category, dateRange: yearDateRange)
    }

    private func searchTransactions() {
        guard let navigationController else { return }
        dependencies
            .makeSearchTransactionsFlowCoordinator(from: navigationController)
            .start()
    }
}
