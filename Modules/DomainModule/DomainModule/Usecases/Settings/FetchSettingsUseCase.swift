//
//  FetchSettingsUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 07/09/2024.
//

import Combine

public final class FetchSettingsUseCase: UseCase {
    public typealias ResultValue = (DMSettings)

    private let repository: SettingsRepository
    private let completion: ((ResultValue) -> Void)?

    public init(
        repository: SettingsRepository,
        completion: ((ResultValue) -> Void)?
    ) {
        self.repository = repository
        self.completion = completion
    }

    public func execute() -> Cancellable? {
        let settings = repository.fetchSettings()
        completion?(settings)
        return nil
    }

    public func executeSync() -> ResultValue {
        repository.fetchSettings()
    }
}
