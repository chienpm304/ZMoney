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

    lazy var transactionDetailSceneDIContainer: TransactionDetailSceneDIContainer = {
        let dependencies = TransactionDetailSceneDIContainer.Dependencies(
            coreDataStack: coreDataStack,
            appConfiguration: appConfiguration, 
            categoriesDIContainer: categoriesSceneDIContainer
        )
        return TransactionDetailSceneDIContainer(dependencies: dependencies)
    }()

    lazy var transactionsSceneDIContainer: TransactionsListSceneDIContainer = {
        let dependencies = TransactionsListSceneDIContainer.Dependencies(
            coreDataStack: coreDataStack,
            appConfiguration: appConfiguration,
            categoriesDIContainer: categoriesSceneDIContainer
        )
        return TransactionsListSceneDIContainer(dependencies: dependencies)
    }()

    lazy var categoriesSceneDIContainer: CategoriesSceneDIContainer = {
        let dependencies = CategoriesSceneDIContainer.Dependencies(
            coreDataStack: coreDataStack,
            appConfiguration: appConfiguration
        )
        return CategoriesSceneDIContainer(dependencies: dependencies)
    }()

    lazy var settingsSceneDIContainer: SettingsSceneDIContainer = {
        let dependencies = SettingsSceneDIContainer.Dependencies(
            appConfiguration: appConfiguration
        )
        return SettingsSceneDIContainer(dependencies: dependencies)
    }()
}
