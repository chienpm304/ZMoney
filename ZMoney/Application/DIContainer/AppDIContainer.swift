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
    func makeCategorySceneDIContainer() -> CategorySceneDIContainer {
        let dependencies = CategorySceneDIContainer.Dependencies()
        return CategorySceneDIContainer(dependencies: dependencies)
    }
}
