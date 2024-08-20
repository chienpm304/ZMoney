//
//  TransCategoriesFlowCoordinator.swift
//  Presentation
//
//  Created by Chien Pham on 20/08/2024.
//

import UIKit

protocol TransCategoriesFlowCoordinatorDependencies {
    func makeTransCategoryListViewController() -> UIViewController
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
        let transCategoryViewController = dependencies.makeTransCategoryListViewController()
        navigationController?.pushViewController(transCategoryViewController, animated: true)
    }
}
