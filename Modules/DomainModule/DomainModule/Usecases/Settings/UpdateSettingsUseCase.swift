//
//  UpdateSettingsUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 07/09/2024.
//

import Combine

final public class UpdateSettingsUseCase: UseCase {
    public struct RequestValue {
        let settings: DMSettings
    }

    public typealias ResultValue = (Result<DMSettings, DMError>)

    private let requestValue: RequestValue
    private let repository: SettingsRepository
    private let completion: (ResultValue) -> Void

    public init(
        requestValue: RequestValue,
        repository: SettingsRepository,
        completion: @escaping (ResultValue) -> Void
    ) {
        self.requestValue = requestValue
        self.repository = repository
        self.completion = completion
    }

    public func execute() -> Cancellable? {
        repository.updateSettings(
            requestValue.settings,
            completion: completion
        )
        return nil
    }
}
