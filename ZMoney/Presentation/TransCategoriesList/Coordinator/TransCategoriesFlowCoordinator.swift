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
        category: TransCategory?,
        type: TransType,
        actions: TransCategoryDetailViewModelActions
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
            editTransCategoryDetail: editCategoryDetail,
            addTransCategoryDetail: addCategoryDetail
        )
        let tranCategoriesListVC = dependencies.makeTransCategoriesListViewController(actions: actions)
        navigationController?.pushViewController(tranCategoriesListVC, animated: true)
    }

    private func editCategoryDetail(category: TransCategory) {
        addOrEditCategoryDetail(category: category, type: category.type)
    }

    private func addCategoryDetail(type: TransType) {
        addOrEditCategoryDetail(type: type)
    }

    private func addOrEditCategoryDetail(category: TransCategory? = nil, type: TransType) {
        let actions = TransCategoryDetailViewModelActions { category in
            print("added or edited category: \(category)")
        }
        let detailVC = dependencies.makeTransCategoryDetailViewController(
            category: category,
            type: type,
            actions: actions
        )
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
