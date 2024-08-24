//
//  AppFlowCoordinator.swift
//  ZMoney
//
//  Created by Chien Pham on 19/08/2024.
//

import UIKit

final class AppFlowCoordinator {
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer

    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let mainSceneDIContainer = appDIContainer.makeMainSceneDIContainer()
        let mainFlow = mainSceneDIContainer.makeCategoriesFlowCoordinator(
            navigationController: navigationController
        )
        mainFlow.start()
    }
}
