//
//  SearchTransactionsFlowCoordinator.swift
//  ZMoney
//
//  Created by Chien Pham on 12/09/2024.
//

import UIKit
import DomainModule

protocol SearchTransactionsFlowCoordinatorDependencies {
    func makeSearchTransactionsViewController(
        actions: SearchTransactionsViewModelActions
    ) -> (UIViewController, SearchTransactionsViewModel)

    func makeTransactionDetailFlowCoordinator(
        from navigationController: UINavigationController,
        request: TransactionDetailFlowCoordinator.Request,
        response: TransactionDetailFlowCoordinator.Response?
    ) -> TransactionDetailFlowCoordinator
}

final class SearchTransactionsFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: SearchTransactionsFlowCoordinatorDependencies
    private var searchTransactionsViewController: UIViewController?
    private var searchTransactionsViewModel: SearchTransactionsViewModel?

    init(
        navigationController: UINavigationController? = nil,
        dependencies: SearchTransactionsFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let actions = SearchTransactionsViewModelActions(editTransaction: editTransactionView)
        let searchView = dependencies.makeSearchTransactionsViewController(actions: actions)
        self.searchTransactionsViewController = searchView.0
        self.searchTransactionsViewModel = searchView.1
        navigationController?.pushViewController(searchView.0, animated: true)
    }

    private func editTransactionView(transaction: DMTransaction) {
        guard let navigationController else { return }
        let request = TransactionDetailFlowCoordinator.Request(
            navigationType: .push,
            newTransactionInputDate: nil,
            editTransaction: transaction
        )

        let response = TransactionDetailFlowCoordinator.Response { [weak self] _ in
            if let hostViewController = self?.searchTransactionsViewController {
                self?.navigationController?.popToViewController(hostViewController, animated: true)
            }
            self?.searchTransactionsViewModel?.refreshData()
        } didCancelTransactionDetail: { [weak self] in
            if let hostViewController = self?.searchTransactionsViewController {
                self?.navigationController?.popToViewController(hostViewController, animated: true)
            }
        }

        dependencies
            .makeTransactionDetailFlowCoordinator(
                from: navigationController,
                request: request,
                response: response
            )
            .start()
    }
}
