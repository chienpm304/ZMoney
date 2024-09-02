//
//  SettingsSceneDIContainer.swift
//  ZMoney
//
//  Created by Chien Pham on 02/09/2024.
//

import Foundation
import UIKit
import SwiftUI

final class SettingsSceneDIContainer: SettingsFlowCoordinatorDependencies {
    private let dependencies: Dependencies

    struct Dependencies {
        // TODO: UserDefault storage to make app configuration persistent
        let appConfiguration: AppConfiguration
    }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func makeSettingsFlowCoordinator(
        navigationController: UINavigationController
    ) -> SettingsFlowCoordinator {
        SettingsFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }

    // MARK: SettingsFlowCoordinatorDependencies
    func makeSettingsListViewController() -> UIViewController {
        let view = AppSettingsView(appSettings: self.dependencies.appConfiguration.settings)
        return UIHostingController(rootView: view)
    }
}
