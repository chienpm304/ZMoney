//
//  SettingsUseCaseFactory.swift
//  DomainModule
//
//  Created by Chien Pham on 07/09/2024.
//

import Foundation

public typealias FetchSettingsUseCaseFactory = () -> FetchSettingsUseCase

public typealias UpdateSettingsUseCaseFactory = () -> UpdateSettingsUseCase

public struct SettingsUseCaseFactory {
    public let fetchUseCase: FetchSettingsUseCaseFactory
    public let updateUseCase: UpdateSettingsUseCaseFactory

    public init(
        fetchUseCase: @escaping FetchSettingsUseCaseFactory,
        updateUseCase: @escaping UpdateSettingsUseCaseFactory
    ) {
        self.fetchUseCase = fetchUseCase
        self.updateUseCase = updateUseCase
    }
}
