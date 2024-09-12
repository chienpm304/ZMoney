//
//  FetchSettingsUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 07/09/2024.
//

import Combine

public final class FetchSettingsUseCase: AsyncUseCase {
    public typealias Input = Void
    public typealias Output = DMSettings

    private let repository: SettingsRepository

    public init(repository: SettingsRepository) {
        self.repository = repository
    }

    public func execute(input: Input) async -> Output {
        await repository.fetchSettings()
    }
}
