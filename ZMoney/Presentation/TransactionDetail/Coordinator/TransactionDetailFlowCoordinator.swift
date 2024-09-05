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
    private weak var detailViewController: UIViewController?
    private weak var detailViewModel: TransactionDetailViewModel?

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
        let transactionDetail = dependencies.makeTransactionDetailViewController(
            forNewTransactionAt: request.newTransactionInputDate,
            forEditTransaction: request.editTransaction,
            actions: actions,
            navigationType: request.navigationType
        )
        let viewController = transactionDetail.0
        detailViewController = viewController
        detailViewModel = transactionDetail.1

        switch request.navigationType {
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
        switch request.navigationType {
        case .push:
            detailViewModel?.prepareForNextTransaction()
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
