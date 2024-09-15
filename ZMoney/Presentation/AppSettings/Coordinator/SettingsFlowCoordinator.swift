//
//  SettingsFlowCoordinator.swift
//  ZMoney
//
//  Created by Chien Pham on 02/09/2024.
//

import Foundation
import UIKit

protocol SettingsFlowCoordinatorDependencies {
    func makeSettingsListViewController(
        actions: SettingsViewModelActions
    ) -> UIViewController

    func makeCategoriesFlowCoordinator(
        from navigationController: UINavigationController
    ) -> CategoriesFlowCoordinator
}

final class SettingsFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: SettingsFlowCoordinatorDependencies

    init(
        navigationController: UINavigationController? = nil,
        dependencies: SettingsFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    public func start() {
        let actions = SettingsViewModelActions(didTapCategoies: openCategoriesListView)
        let settingsVC = dependencies.makeSettingsListViewController(actions: actions)
        navigationController?.pushViewController(settingsVC, animated: true)
    }

    private func openCategoriesListView() {
        guard let navigationController else { return }
        let categoriesCoordinator = dependencies.makeCategoriesFlowCoordinator(
            from: navigationController
        )
        categoriesCoordinator.start()
    }
}
