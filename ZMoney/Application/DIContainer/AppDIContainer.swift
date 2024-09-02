//
//  AppDIContainer.swift
//  ZMoney
//
//  Created by Chien Pham on 19/08/2024.
//

import Foundation
import DataModule

final class AppDIContainer {

    lazy var appConfiguration = AppConfiguration()

    lazy var coreDataStack: CoreDataStack = .shared

    // MARK: - DIContainers of scenes

    func makeMainSceneDIContainer() -> TabViewSceneDIContainer {
        let dependencies = TabViewSceneDIContainer.Dependencies(
            appDIContainer: self
        )
        return TabViewSceneDIContainer(dependencies: dependencies)
    }

    func makeTransactionsSceneDIContainer() -> TransactionsListSceneDIContainer {
        let dependencies = TransactionsListSceneDIContainer.Dependencies(
            coreDataStack: coreDataStack,
            appConfiguration: appConfiguration
        )
        return TransactionsListSceneDIContainer(dependencies: dependencies)
    }

    func makeCategoriesSceneDIContainer() -> CategoriesSceneDIContainer {
        let dependencies = CategoriesSceneDIContainer.Dependencies(
            coreDataStack: coreDataStack,
            appConfiguration: appConfiguration
        )
        return CategoriesSceneDIContainer(dependencies: dependencies)
    }

    func makeSettingsSceneDIContainer() -> SettingsSceneDIContainer {
        let dependencies = SettingsSceneDIContainer.Dependencies(appConfiguration: appConfiguration)
        return SettingsSceneDIContainer(dependencies: dependencies)
    }
}
