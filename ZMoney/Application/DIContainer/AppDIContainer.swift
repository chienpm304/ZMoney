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

    func makeMainSceneDIContainer() -> TransactionsListSceneDIContainer {
        let dependencies = TransactionsListSceneDIContainer.Dependencies(
            coreDataStack: coreDataStack
        )
        return TransactionsListSceneDIContainer(dependencies: dependencies)
    }

    func makeCategoriesSceneDIContainer() -> CategoriesSceneDIContainer {
        let dependencies = CategoriesSceneDIContainer.Dependencies(
            coreDataStack: coreDataStack
        )
        return CategoriesSceneDIContainer(dependencies: dependencies)
    }
}
