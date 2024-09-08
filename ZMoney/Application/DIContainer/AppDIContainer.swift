//
//  AppDIContainer.swift
//  ZMoney
//
//  Created by Chien Pham on 19/08/2024.
//

import Foundation
import DataModule
import DomainModule

final class AppDIContainer {

    lazy var appConfiguration: AppConfiguration = {
        let settingsStorage = SettingsUserDefaultStorage(userDefaultCoordinator: userDefaultCoordinator)
        let settingsRepository = DefaultSettingsRepository(settingsStorage: settingsStorage)
        let appSettings = AppSettings(settingRepository: settingsRepository)
        return AppConfiguration(settings: appSettings)
    }()

    lazy var coreDataStack: CoreDataStack = .shared

    lazy var userDefaultCoordinator: UserDefaultCoordinator = .init()

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
            transactionDetailDIContainer: transactionDetailSceneDIContainer,
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
            appConfiguration: appConfiguration,
            userDefaultCoordinator: userDefaultCoordinator
        )
        return SettingsSceneDIContainer(dependencies: dependencies)
    }()
}
