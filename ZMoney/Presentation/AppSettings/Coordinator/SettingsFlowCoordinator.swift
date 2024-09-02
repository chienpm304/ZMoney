//
//  SettingsFlowCoordinator.swift
//  ZMoney
//
//  Created by Chien Pham on 02/09/2024.
//

import Foundation
import UIKit

protocol SettingsFlowCoordinatorDependencies {
    func makeSettingsListViewController() -> UIViewController
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
        let settingsVC = dependencies.makeSettingsListViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}
