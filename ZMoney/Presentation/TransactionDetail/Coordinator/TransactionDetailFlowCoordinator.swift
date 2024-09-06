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
    ) -> UIViewController

    func makeCategoriesFlowCoordinator(
        from navigationController: UINavigationController
    ) -> CategoriesFlowCoordinator
}

final class TransactionDetailFlowCoordinator {
    struct Request {
        let navigationType: NavigationType
        let newTransactionInputDate: Date?
        let editTransaction: DMTransaction?
    }

    struct Response {
        let didUpdateTransactionDetail: (DMTransaction) -> Void
        let didCancelTransactionDetail: () -> Void
    }

    private weak var navigationController: UINavigationController?
    private let dependencies: TransactionDetailFlowCoordinatorDependencies
    private let request: Request
    private let response: Response?
    private var detailViewController: UIViewController?

    init(
        navigationController: UINavigationController? = nil,
        dependencies: TransactionDetailFlowCoordinatorDependencies,
        request: Request,
        response: Response?
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
        self.request = request
        self.response = response
    }

    func start() {
        let actions = TransactionDetailViewModelActions(
            editCategoriesList: editCategoriesList,
            didUpdateTransactionDetail: didUpdateTransactionDetail,
            didCancelTransactionDetail: didCancelTransactionDetail
        )
        let transactionDetailVC = dependencies.makeTransactionDetailViewController(
            forNewTransactionAt: request.newTransactionInputDate,
            forEditTransaction: request.editTransaction,
            actions: actions,
            navigationType: request.navigationType
        )
        detailViewController = transactionDetailVC

        switch request.navigationType {
        case .push:
            navigationController?.pushViewController(transactionDetailVC, animated: true)
        case .present:
            let presentedNavigationController = UINavigationController(
                rootViewController: transactionDetailVC
            )
            navigationController?.present(presentedNavigationController, animated: true, completion: nil)
        }
    }

    private func editCategoriesList() {
        let presentingNavigationController: UINavigationController?
        switch request.navigationType {
        case .push:
            presentingNavigationController = self.navigationController
        case .present:
            presentingNavigationController = detailViewController?.navigationController
        }

        guard let presentingNavigationController else { return }
        let categoriesCoordinator = dependencies.makeCategoriesFlowCoordinator(
            from: presentingNavigationController
        )
        categoriesCoordinator.start()
    }

    private func didUpdateTransactionDetail(_ transaction: DMTransaction) {
        switch request.navigationType {
        case .push:
            break
        case .present:
            detailViewController?.dismiss(animated: true)
        }
        response?.didUpdateTransactionDetail(transaction)
    }

    private func didCancelTransactionDetail() {
        switch request.navigationType {
        case .push:
            assertionFailure()
        case .present:
            detailViewController?.dismiss(animated: true)
        }
        response?.didCancelTransactionDetail()
    }
}
