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

    private func reportDetailView(category: DMCategory, dateRange: DateRange) {
        // TODO: wire report detail view detail here
        print("wire report detail view detail here")
    }

    private func searchTransactions() {
        guard let navigationController else { return }
        dependencies
            .makeSearchTransactionsFlowCoordinator(from: navigationController)
            .start()
    }
}
