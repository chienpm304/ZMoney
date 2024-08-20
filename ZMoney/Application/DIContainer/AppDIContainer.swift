//
//  AppDIContainer.swift
//  ZMoney
//
//  Created by Chien Pham on 19/08/2024.
//

import Foundation

final class AppDIContainer {

    lazy var appConfiguration = AppConfiguration()

    // MARK: - DIContainers of scenes

    func makeMainSceneDIContainer() -> TransCategoriesSceneDIContainer {
        let dependencies = TransCategoriesSceneDIContainer.Dependencies()
        return TransCategoriesSceneDIContainer(dependencies: dependencies)
    }
}
