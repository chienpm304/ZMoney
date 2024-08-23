//
//  TransCategoriesFlowCoordinator.swift
//  Presentation
//
//  Created by Chien Pham on 20/08/2024.
//

import UIKit
import DomainModule

protocol TransCategoriesFlowCoordinatorDependencies {
    func makeTransCategoriesListViewController(
        actions: TransCategoriesListViewModelActions
    ) -> UIViewController

    func makeTransCategoryDetailViewController(
        category: TransCategory
    ) -> UIViewController
}

final class TransCategoriesFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: TransCategoriesFlowCoordinatorDependencies

    init(
        navigationController: UINavigationController? = nil,
        dependencies: TransCategoriesFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    public func start() {
        let actions = TransCategoriesListViewModelActions(
            showTransCategoryDetail: showCategoryDetail,
            addNewTransCategory: addNewCategory
        )
        let tranCategoriesListVC = dependencies.makeTransCategoriesListViewController(actions: actions)
        navigationController?.pushViewController(tranCategoriesListVC, animated: true)
    }

    private func showCategoryDetail(category: TransCategory) {
        let detailVC = dependencies.makeTransCategoryDetailViewController(category: category)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    private func addNewCategory(type: TransType, sortIndex: Int) {
        let dummyCategory = TransCategory(type: type, sortIndex: Index(sortIndex))
        let detailVC = dependencies.makeTransCategoryDetailViewController(category: dummyCategory)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
