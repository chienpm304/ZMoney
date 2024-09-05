//
//  TabViewSceneDIContainer.swift
//  ZMoney
//
//  Created by Chien Pham on 01/09/2024.
//

import Foundation
import UIKit

final class TabViewSceneDIContainer {
    struct Dependencies {
        let appDIContainer: AppDIContainer
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func makeTabViewSceneFlowCoodinator(window: UIWindow) -> TabViewFlowCoordinator {
        TabViewFlowCoordinator(window: window, dependencies: self)
    }
}

// MARK: TransactionsListFlowCoordinatorDependencies

extension TabViewSceneDIContainer: TabViewFlowCoordinatorDependencies {
    func makeTabViewController() -> UITabBarController {
        UITabBarController()
    }

    func makeTransactionDetailFlowCoordinator(
        navigationController: UINavigationController,
        request: TransactionDetailFlowCoordinator.Request
    ) -> TransactionDetailFlowCoordinator {
        dependencies
            .appDIContainer
            .transactionDetailSceneDIContainer
            .makeTransactionDetailFlowCoordinator(
                navigationController: navigationController,
                request: request
            )
    }

    func makeTransactionsFlowCoordinator(
        navigationController: UINavigationController
    ) -> TransactionsListFlowCoordinator {
        dependencies
            .appDIContainer
            .transactionsSceneDIContainer
            .makeTransactionsFlowCoordinator(
                navigationController: navigationController
            )
    }

    func makeCategoriesFlowCoordinator(
        navigationController: UINavigationController
    ) -> CategoriesFlowCoordinator {
        dependencies
            .appDIContainer
            .categoriesSceneDIContainer
            .makeCategoriesFlowCoordinator(
                navigationController: navigationController
            )
    }

    func makeSettingsFlowCoordinator(
        navigationController: UINavigationController
    ) -> SettingsFlowCoordinator {
        dependencies
            .appDIContainer
            .settingsSceneDIContainer
            .makeSettingsFlowCoordinator(
                navigationController: navigationController
            )
    }
}
