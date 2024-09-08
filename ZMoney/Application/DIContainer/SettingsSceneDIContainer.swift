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
    }

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    lazy var settingsStorage: SettingsStorage = SettingsUserDefaultStorage(
        userDefaultCoordinator: dependencies.userDefaultCoordinator
    )

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

    func makeSettingsListViewController() -> UIViewController {
        let viewModel = dependencies.appConfiguration.settings
        let view = SettingsView(viewModel: viewModel)
        return UIHostingController(rootView: view)
    }

    // MARK: UseCase

    func makeSettingsUseCaseFactory() -> SettingsUseCaseFactory {
        SettingsUseCaseFactory(
            fetchUseCase: makeFetchSettingsUseCaseFactory(completion:),
            updateUseCase: makeUpdateSettingsUseCaseFactory(requestValue:completion:)
        )
    }

    func makeFetchSettingsUseCaseFactory(
        completion: ((FetchSettingsUseCase.ResultValue) -> Void)?
    ) -> UseCase {
        FetchSettingsUseCase(
            repository: makeSettingsRespository(),
            completion: completion
        )
    }

    func makeUpdateSettingsUseCaseFactory(
        requestValue: UpdateSettingsUseCase.RequestValue,
        completion: @escaping (UpdateSettingsUseCase.ResultValue) -> Void
    ) -> UseCase {
        UpdateSettingsUseCase(
            requestValue: requestValue,
            repository: makeSettingsRespository(),
            completion: completion
        )
    }

    // MARK: Repository

    func makeSettingsRespository() -> SettingsRepository {
        DefaultSettingsRepository(settingsStorage: settingsStorage)
    }
}
