//
//  TabViewFlowCoordinator.swift
//  ZMoney
//
//  Created by Chien Pham on 01/09/2024.
//

import Foundation
import UIKit
import DomainModule

protocol TabViewFlowCoordinatorDependencies {
    func makeTabViewController(
    ) -> UITabBarController

    func makeTransactionDetailFlowCoordinator(
        navigationController: UINavigationController,
        request: TransactionDetailFlowCoordinator.Request,
        response: TransactionDetailFlowCoordinator.Response?
    ) -> TransactionDetailFlowCoordinator

    func makeTransactionsFlowCoordinator(
        navigationController: UINavigationController
    ) -> TransactionsListFlowCoordinator

    func makeReportTransactionsFlowCoordinator(
        navigationController: UINavigationController
    ) -> ReportTransactionsFlowCoordinator

    func makeSettingsFlowCoordinator(
        navigationController: UINavigationController
    ) -> SettingsFlowCoordinator
}

final class TabViewFlowCoordinator: NSObject {
    private let dependencies: TabViewFlowCoordinatorDependencies
    private let window: UIWindow
    private var _tabBarController: UITabBarController?

    init(
        window: UIWindow,
        dependencies: TabViewFlowCoordinatorDependencies
    ) {
        self.window = window
        self.dependencies = dependencies
    }

    func start() {
        let tabViewController = dependencies.makeTabViewController()
        let pages = TabViewType.allCases.sorted(by: {$0.index < $1.index })
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        prepareTabBarController(with: controllers, tabBarController: tabViewController)
    }

    private func getTabController(_ tabType: TabViewType) -> UINavigationController {
        let navController = UINavigationController()

        switch tabType {
        case .createTransaction:
            let request = TransactionDetailFlowCoordinator.Request(
                navigationType: .push,
                newTransactionInputDate: .now,
                editTransaction: nil
            )
            let createTransactionFlowCoordinator = dependencies.makeTransactionDetailFlowCoordinator(
                navigationController: navController,
                request: request,
                response: nil
            )
            createTransactionFlowCoordinator.start()
        case .transactions:
            let transactionsFlowCoordinator = dependencies.makeTransactionsFlowCoordinator(
                navigationController: navController
            )
            transactionsFlowCoordinator.start()
        case .report:
            let reportTransactionsFlowCoordinator = dependencies.makeReportTransactionsFlowCoordinator(
                navigationController: navController
            )
            reportTransactionsFlowCoordinator.start()
        case .settings:
            let settingsFlowCoordinator = dependencies.makeSettingsFlowCoordinator(
                navigationController: navController
            )
            settingsFlowCoordinator.start()
        }

        navController.tabBarItem = UITabBarItem(
            title: NSLocalizedString(tabType.title, comment: "Tab name"),
            image: UIImage(systemName: tabType.tabIcon),
            tag: tabType.index
        )

        return navController
    }

    private func prepareTabBarController(
        with tabControllers: [UIViewController],
        tabBarController: UITabBarController
    ) {
        tabBarController.delegate = self
        tabBarController.setViewControllers(tabControllers, animated: true)
        tabBarController.selectedIndex = TabViewType.primaryTab.index
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.barStyle = .default
        tabBarController.tabBar.backgroundColor = UIColor.systemBackground

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        _tabBarController = tabBarController
    }
}

extension TabViewFlowCoordinator: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        didSelect viewController: UIViewController
    ) {
        // Some implementation
    }
}
