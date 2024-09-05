//
//  TransactionDetailFlowCoordinator.swift
//  ZMoney
//
//  Created by Chien Pham on 05/09/2024.
//

import UIKit
import DomainModule

protocol TransactionDetailFlowCoordinatorDependencies {
    func makeCreateTransactionViewController(
        inputDate: Date,
        actions: TransactionDetailViewModelActions
    ) -> (UIViewController, TransactionDetailViewModel)

    func makeCategoriesFlowCoordinator(
        from navigationController: UINavigationController
    ) -> CategoriesFlowCoordinator
}

final class TransactionDetailFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: TransactionDetailFlowCoordinatorDependencies
    private weak var detailViewController: UIViewController?
    private weak var detailViewModel: TransactionDetailViewModel?

    init(
        navigationController: UINavigationController? = nil,
        dependencies: TransactionDetailFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    func start() {
        let actions = TransactionDetailViewModelActions(
            editCategoriesList: editCategoriesList,
            notifyDidUpdateTransactionDetail: didUpdateTransactionDetail,
            notifyDidCancelTransactionDetail: didCancelTransactionDetail
        )
        let transactionDetail = dependencies.makeCreateTransactionViewController(
            inputDate: .now,
            actions: actions
        )
        detailViewController = transactionDetail.0
        detailViewModel = transactionDetail.1
        navigationController?.pushViewController(transactionDetail.0, animated: true)
    }

    private func editCategoriesList() {
        guard let navigationController else { return }
        let categoriesCoordinator = dependencies.makeCategoriesFlowCoordinator(
            from: navigationController
        )
        categoriesCoordinator.start()
    }

    private func didUpdateTransactionDetail(_ transaction: DMTransaction) {
        detailViewModel?.prepareForNextTransaction()
    }

    private func didCancelTransactionDetail() {
        // do nothing
    }
}
