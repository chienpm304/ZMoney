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

    func makeMainSceneDIContainer() -> TransCategoriesSceneDIContainer {
        let dependencies = TransCategoriesSceneDIContainer.Dependencies(
            coreDataStack: coreDataStack
        )
        return TransCategoriesSceneDIContainer(dependencies: dependencies)
    }
}
