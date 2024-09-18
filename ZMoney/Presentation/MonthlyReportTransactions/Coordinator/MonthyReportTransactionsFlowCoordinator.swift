//
//  MonthlyReportTransactionsFlowCoordinator.swift
//  ZMoney
//
//  Created by Chien Pham on 16/09/2024.
//

import Foundation
import DomainModule

protocol MonthlyReportTransactionsFlowCoordinatorDependencies {
    func makeMonthlyReportTransactionsViewController(
        category: DMCategory,
        dateRange: DateRange,
        actions: MonthlyReportTransactionsViewModelActions
    ) -> (UIViewController, MonthlyReportTransactionsViewModel)

    func makeMonthlyReportTransactionsDetailFlowCoordinator(
        from navigationController: UINavigationController
    ) -> MonthlyReportTransactionsDetailFlowCoordinator
}

final class MonthlyReportTransactionsFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: MonthlyReportTransactionsFlowCoordinatorDependencies
    private var hostViewController: UIViewController?
    private var hostViewModel: MonthlyReportTransactionsViewModel?

    init(
        navigationController: UINavigationController? = nil,
        dependencies: MonthlyReportTransactionsFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start(category: DMCategory, dateRange: DateRange) {
        let actions = MonthlyReportTransactionsViewModelActions(
            didTapMonthlyReportItem: monthlyReportTransactionsDetailView
        )
        let reportView = dependencies.makeMonthlyReportTransactionsViewController(
            category: category,
            dateRange: dateRange,
            actions: actions
        )
        hostViewController = reportView.0
        hostViewModel = reportView.1
        navigationController?.pushViewController(reportView.0, animated: true)
    }

    private func monthlyReportTransactionsDetailView(category: DMCategory, timeValue: TimeValue) {
        guard let navigationController else { return }
        let date = timeValue.dateValue
        let fullDateRange = DateRange(
            startDate: date.dateAtStartOf(.year),
            endDate: date.dateAtEndOf(.year)
        )
        let selectedDateRange = DateRange(
            startDate: date.dateAtStartOf(.month),
            endDate: date.dateAtEndOf(.month)
        )
        dependencies
            .makeMonthlyReportTransactionsDetailFlowCoordinator(from: navigationController)
            .start(
                category: category,
                fullDateRange: fullDateRange,
                selectedDateRange: selectedDateRange
            )
    }
}
