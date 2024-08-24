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
        category: TransCategory,
        isNewCategory: Bool,
        actions: TransCategoryDetailViewModelActions
    ) -> UIViewController
}

final class TransCategoriesFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: TransCategoriesFlowCoordinatorDependencies
    private var transCategoriesListViewController: UIViewController?

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
        transCategoriesListViewController = tranCategoriesListVC
        navigationController?.pushViewController(tranCategoriesListVC, animated: true)
    }

    private func editCategoryDetail(category: TransCategory) {
        addOrEditCategoryDetail(category: category, isNewCategory: false)
    }

    private func addCategoryDetail(type: TransType) {
        let categoryPlaceholder = TransCategory(type: type, sortIndex: Index.max - 1)
        addOrEditCategoryDetail(category: categoryPlaceholder, isNewCategory: true)
    }

    private func addOrEditCategoryDetail(category: TransCategory, isNewCategory: Bool) {
        let actions = TransCategoryDetailViewModelActions { [weak self] _ in
            if let listViewController = self?.transCategoriesListViewController {
                self?.navigationController?.popToViewController(listViewController, animated: true)
            }
        }
        let detailVC = dependencies.makeTransCategoryDetailViewController(
            category: category,
            isNewCategory: isNewCategory,
            actions: actions
        )
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
