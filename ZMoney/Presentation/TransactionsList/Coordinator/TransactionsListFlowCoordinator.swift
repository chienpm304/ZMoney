//
//  TransactionsListFlowCoordinator.swift
//  ZMoney
//
//  Created by Chien Pham on 29/08/2024.
//

import UIKit
import DomainModule

protocol TransactionsListFlowCoordinatorDependencies {
    func makeTransactionsListViewController(
        actions: TransactionsListViewModelActions
    ) -> UIViewController

    func makeCreateTransactionViewController(
        inputDate: Date
    ) -> UIViewController

    func makeEditTransactionViewController(
        transaction: DMTransaction
    ) -> UIViewController
}

final class TransactionsListFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: TransactionsListFlowCoordinatorDependencies

    init(
        navigationController: UINavigationController? = nil,
        dependencies: TransactionsListFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let actions = TransactionsListViewModelActions(
            createTransaction: openCreateTransactionView,
            editTransaction: openEditTransactionView
        )
        let transactionsListVC = dependencies.makeTransactionsListViewController(
            actions: actions
        )
        navigationController?.pushViewController(transactionsListVC, animated: true)
    }

    private func openCreateTransactionView(inputDate: Date) {
        let transactionDetailVC = dependencies.makeCreateTransactionViewController(inputDate: inputDate)
        navigationController?.present(transactionDetailVC, animated: true)
    }

    private func openEditTransactionView(transaction: DMTransaction) {
        let transactionDetailVC = dependencies.makeEditTransactionViewController(transaction: transaction)
        navigationController?.present(transactionDetailVC, animated: true)
    }
}
