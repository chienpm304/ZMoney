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
            didTapMonthlyReportItem: monthlyReportDetailView
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

    private func monthlyReportDetailView(
        category: DMCategory,
        timeValue: TimeValue
    ) {
        // TODO: wire report detail view detail here
        print("wire report detail view detail here")
    }

}
