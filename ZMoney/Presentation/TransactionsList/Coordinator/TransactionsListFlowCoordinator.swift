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
    ) -> (UIViewController, TransactionsListViewModel)

    func makeTransactionDetailFlowCoordinator(
        from navigationController: UINavigationController,
        request: TransactionDetailFlowCoordinator.Request,
        response: TransactionDetailFlowCoordinator.Response?
    ) -> TransactionDetailFlowCoordinator
}

final class TransactionsListFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: TransactionsListFlowCoordinatorDependencies
    private var transactionsListViewController: UIViewController?
    private var transactionsListViewModel: TransactionsListViewModel?

    private var transactionDetailViewController: UIViewController?

    init(
        navigationController: UINavigationController? = nil,
        dependencies: TransactionsListFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let actions = TransactionsListViewModelActions(
            createTransaction: createTransactionView,
            editTransaction: editTransactionView
        )
        let transactionsList = dependencies.makeTransactionsListViewController(
            actions: actions
        )
        transactionsListViewController = transactionsList.0
        transactionsListViewModel = transactionsList.1
        navigationController?.pushViewController(transactionsList.0, animated: true)
    }

    private func createTransactionView(inputDate: Date) {
        createOrEditTransactionView(innputDate: inputDate, transaction: nil)
    }

    private func editTransactionView(transaction: DMTransaction) {
        createOrEditTransactionView(innputDate: nil, transaction: transaction)
    }

    private func createOrEditTransactionView(innputDate: Date?, transaction: DMTransaction?) {
        guard let navigationController else { return }
        let request = TransactionDetailFlowCoordinator.Request(
            navgationType: .present,
            newTransactionInputDate: innputDate,
            editTransaction: transaction
        )

        let response = TransactionDetailFlowCoordinator.Response { [weak self] _ in
            self?.transactionsListViewModel?.refreshTransactions()
        } didCancelTransactionDetail: {
            // do nothing
        }

        let coordinator = dependencies.makeTransactionDetailFlowCoordinator(
            from: navigationController,
            request: request,
            response: response
        )
        coordinator.start()
    }
}
