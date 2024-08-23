//
//  TransCategoriesFlowCoordinator.swift
//  Presentation
//
//  Created by Chien Pham on 20/08/2024.
//

import UIKit

protocol TransCategoriesFlowCoordinatorDependencies {
    func makeTransCategoriesListViewController(
        actions: TransCategoriesListViewModelActions
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
        let actions = TransCategoriesListViewModelActions { category in
            print("> should show detail for \(category.name)")
        }
        let tranCategoriesListVC = dependencies.makeTransCategoriesListViewController(actions: actions)
        navigationController?.pushViewController(tranCategoriesListVC, animated: true)
    }
}
