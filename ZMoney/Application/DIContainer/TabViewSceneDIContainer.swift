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

    func makeTransactionsFlowCoordinator(
        navigationController: UINavigationController
    ) -> TransactionsListFlowCoordinator {
        dependencies
            .appDIContainer
            .makeTransactionsSceneDIContainer()
            .makeTransactionsFlowCoordinator(
                navigationController: navigationController
            )
    }

    func makeCategoriesFlowCoordinator(
        navigationController: UINavigationController
    ) -> CategoriesFlowCoordinator {
        dependencies
            .appDIContainer
            .makeCategoriesSceneDIContainer()
            .makeCategoriesFlowCoordinator(
                navigationController: navigationController
            )
    }

    func makeSettingsFlowCoordinator(
        navigationController: UINavigationController
    ) -> SettingsFlowCoordinator {
        dependencies
            .appDIContainer
            .makeSettingsSceneDIContainer()
            .makeSettingsFlowCoordinator(
                navigationController: navigationController
            )
    }
}
