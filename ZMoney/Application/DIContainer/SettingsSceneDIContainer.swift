//
//  SettingsSceneDIContainer.swift
//  ZMoney
//
//  Created by Chien Pham on 02/09/2024.
//

import Foundation
import UIKit
import SwiftUI
import DataModule
import DomainModule

final class SettingsSceneDIContainer: SettingsFlowCoordinatorDependencies {
    private let dependencies: Dependencies

    struct Dependencies {
        let appConfiguration: AppConfiguration
        let userDefaultCoordinator: UserDefaultCoordinator
        let categoriesDIContainer: CategoriesSceneDIContainer
    }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: Flow

    func makeSettingsFlowCoordinator(
        navigationController: UINavigationController
    ) -> SettingsFlowCoordinator {
        SettingsFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }

    // MARK: SettingsFlowCoordinatorDependencies

    func makeSettingsListViewController(actions: SettingsViewModelActions) -> UIViewController {
        let viewModel = dependencies.appConfiguration.settings
        viewModel.updateActions(actions)
        let view = SettingsView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }

    func makeCategoriesFlowCoordinator(
        from navigationController: UINavigationController
    ) -> CategoriesFlowCoordinator {
        dependencies
            .categoriesDIContainer
            .makeCategoriesFlowCoordinator(navigationController: navigationController)
    }
}
