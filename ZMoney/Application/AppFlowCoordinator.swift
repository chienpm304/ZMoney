//
//  AppFlowCoordinator.swift
//  ZMoney
//
//  Created by Chien Pham on 19/08/2024.
//

import UIKit

final class AppFlowCoordinator {
    var window: UIWindow
    private let appDIContainer: AppDIContainer

    init(
        window: UIWindow,
        appDIContainer: AppDIContainer
    ) {
        self.window = window
        self.appDIContainer = appDIContainer
    }

    func start() {
        let mainSceneDIContainer = appDIContainer.makeMainSceneDIContainer()
        let mainFlow = mainSceneDIContainer.makeTabViewSceneFlowCoodinator(
            window: window
        )
        mainFlow.start()
    }
}
