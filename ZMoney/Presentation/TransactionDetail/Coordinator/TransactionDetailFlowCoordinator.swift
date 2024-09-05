//
//  TransactionDetailFlowCoordinator.swift
//  ZMoney
//
//  Created by Chien Pham on 05/09/2024.
//

import UIKit
import DomainModule

protocol TransactionDetailFlowCoordinatorDependencies {
    func makeTransactionDetailViewController(
        forNewTransactionAt inputDate: Date?,
        forEditTransaction transaction: DMTransaction?,
        actions: TransactionDetailViewModelActions,
        navigationType: NavigationType
    ) -> (UIViewController, TransactionDetailViewModel)

    func makeCategoriesFlowCoordinator(
        from navigationController: UINavigationController
    ) -> CategoriesFlowCoordinator
}

final class TransactionDetailFlowCoordinator {
    struct Request {
        let navgationType: NavigationType
        let newTransactionInputDate: Date?
        let editTransaction: DMTransaction?
    }

    private weak var navigationController: UINavigationController?
    private let dependencies: TransactionDetailFlowCoordinatorDependencies
    private let request: Request
    private weak var detailViewController: UIViewController?
    private weak var detailViewModel: TransactionDetailViewModel?

    init(
        navigationController: UINavigationController? = nil,
        dependencies: TransactionDetailFlowCoordinatorDependencies,
        request: Request
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.request = request
    }

    func start() {
        let actions = TransactionDetailViewModelActions(
            editCategoriesList: editCategoriesList,
            notifyDidUpdateTransactionDetail: didUpdateTransactionDetail,
            notifyDidCancelTransactionDetail: didCancelTransactionDetail
        )
        let transactionDetail = dependencies.makeTransactionDetailViewController(
            forNewTransactionAt: request.newTransactionInputDate,
            forEditTransaction: request.editTransaction,
            actions: actions,
            navigationType: request.navgationType
        )
        let viewController = transactionDetail.0
        detailViewController = viewController
        detailViewModel = transactionDetail.1

        switch request.navgationType {
        case .push:
            navigationController?.pushViewController(viewController, animated: true)
        case .present:
            let presentedNavigationController = UINavigationController(rootViewController: viewController)
            navigationController?.present(presentedNavigationController, animated: true, completion: nil)
        }
    }

    private func editCategoriesList() {
        guard let navigationController else { return }
        let categoriesCoordinator = dependencies.makeCategoriesFlowCoordinator(
            from: navigationController
        )
        categoriesCoordinator.start()
    }

    private func didUpdateTransactionDetail(_ transaction: DMTransaction) {
        switch request.navgationType {
        case .push:
            detailViewModel?.prepareForNextTransaction()
        case .present:
            detailViewController?.dismiss(animated: true)
        }
    }

    private func didCancelTransactionDetail() {
        switch request.navgationType {
        case .push:
            assertionFailure()
        case .present:
            detailViewController?.dismiss(animated: true)
        }
    }
}
