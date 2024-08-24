//
//  CategoriesFlowCoordinator.swift
//  Presentation
//
//  Created by Chien Pham on 20/08/2024.
//

import UIKit
import DomainModule

protocol CategoriesFlowCoordinatorDependencies {
    func makeCategoriesListViewController(
        actions: CategoriesListViewModelActions
    ) -> UIViewController

    func makeCategoryDetailViewController(
        category: DMCategory,
        isNewCategory: Bool,
        actions: CategoryDetailViewModelActions
    ) -> UIViewController
}

final class CategoriesFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: CategoriesFlowCoordinatorDependencies
    private var categoriesListViewController: UIViewController?

    init(
        navigationController: UINavigationController? = nil,
        dependencies: CategoriesFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    public func start() {
        let actions = CategoriesListViewModelActions(
            editCategoryDetail: editCategoryDetail,
            addCategoryDetail: addCategoryDetail
        )
        let tranCategoriesListVC = dependencies.makeCategoriesListViewController(actions: actions)
        categoriesListViewController = tranCategoriesListVC
        navigationController?.pushViewController(tranCategoriesListVC, animated: true)
    }

    private func editCategoryDetail(category: DMCategory) {
        addOrEditCategoryDetail(category: category, isNewCategory: false)
    }

    private func addCategoryDetail(type: TransType) {
        let categoryPlaceholder = DMCategory(type: type, sortIndex: Index.max - 1)
        addOrEditCategoryDetail(category: categoryPlaceholder, isNewCategory: true)
    }

    private func addOrEditCategoryDetail(category: DMCategory, isNewCategory: Bool) {
        let actions = CategoryDetailViewModelActions { [weak self] _ in
            if let listViewController = self?.categoriesListViewController {
                self?.navigationController?.popToViewController(listViewController, animated: true)
            }
        }
        let detailVC = dependencies.makeCategoryDetailViewController(
            category: category,
            isNewCategory: isNewCategory,
            actions: actions
        )
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
