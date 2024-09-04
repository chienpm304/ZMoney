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
        let transactionsListVC = dependencies.makeTransactionsListViewController(
            actions: actions
        )
        transactionsListViewController = transactionsListVC
        navigationController?.pushViewController(transactionsListVC, animated: true)
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
        TransactionDetailViewModelActions { [weak self] in
            guard let self, let navigationController = transactionDetailViewController?.navigationController
            else { return }
            let categoriesCoordinator = self.dependencies.makeCategoriesFlowCoordinator(
                from: navigationController
            )
            categoriesCoordinator.start()
        } notifyDidSaveTransactionDetail: { [weak self] _ in
            self?.transactionDetailViewController?.dismiss(animated: true)
        } notifyDidCancelTransactionDetail: { [weak self] in
            self?.transactionDetailViewController?.dismiss(animated: true)
        }
    }
}
