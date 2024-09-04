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

    func makeCreateTransactionViewController(
        inputDate: Date,
        actions: TransactionDetailViewModelActions
    ) -> UIViewController

    func makeEditTransactionViewController(
        transaction: DMTransaction,
        actions: TransactionDetailViewModelActions
    ) -> UIViewController

    func makeCategoriesFlowCoordinator(
        from navigationController: UINavigationController
    ) -> CategoriesFlowCoordinator
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
            createTransaction: openCreateTransactionView,
            editTransaction: openEditTransactionView
        )
        let transactionsList = dependencies.makeTransactionsListViewController(
            actions: actions
        )
        transactionsListViewController = transactionsList.0
        transactionsListViewModel = transactionsList.1
        navigationController?.pushViewController(transactionsList.0, animated: true)
    }

    private func openCreateTransactionView(inputDate: Date) {
        let transactionDetailVC = dependencies.makeCreateTransactionViewController(
            inputDate: inputDate,
            actions: makeTransactionDetailViewModelActions()
        )
        presentTransactionDetailViewController(transactionDetailVC)
    }

    private func openEditTransactionView(transaction: DMTransaction) {
        let transactionDetailVC = dependencies.makeEditTransactionViewController(
            transaction: transaction,
            actions: makeTransactionDetailViewModelActions()
        )
        presentTransactionDetailViewController(transactionDetailVC)
    }

    private func presentTransactionDetailViewController(_ viewController: UIViewController) {
        transactionDetailViewController = viewController

        let presentedNavigationController = UINavigationController(rootViewController: viewController)
        navigationController?.present(presentedNavigationController, animated: true, completion: nil)
    }

    private func makeTransactionDetailViewModelActions() -> TransactionDetailViewModelActions {
        TransactionDetailViewModelActions(
            editCategoriesList: editCategoriesList,
            notifyDidUpdateTransactionDetail: didUpdateTransactionDetail,
            notifyDidCancelTransactionDetail: didCancelTransactionDetail
        )
    }

    private func editCategoriesList() {
        guard let navigationController = transactionDetailViewController?.navigationController
        else { return }
        let categoriesCoordinator = dependencies.makeCategoriesFlowCoordinator(
            from: navigationController
        )
        categoriesCoordinator.start()
    }

    private func didUpdateTransactionDetail(_ transaction: DMTransaction) {
        transactionDetailViewController?.dismiss(animated: true)
        transactionsListViewModel?.refreshTransactions()
    }

    private func didCancelTransactionDetail() {
        transactionDetailViewController?.dismiss(animated: true)
    }
}
