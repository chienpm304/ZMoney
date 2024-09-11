//
//  UpdateSettingsUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 07/09/2024.
//

import Combine

final public class UpdateSettingsUseCase: AsyncUseCase {

    public struct Input {
        let settings: DMSettings

        public init(settings: DMSettings) {
            self.settings = settings
        }
    }

    public typealias Output = DMSettings

    private let repository: SettingsRepository

    public init(
        repository: SettingsRepository
    ) {
        self.repository = repository
    }

    public func execute(input: Input) async throws -> Output {
        try await repository.updateSettings(input.settings)
    }
}
