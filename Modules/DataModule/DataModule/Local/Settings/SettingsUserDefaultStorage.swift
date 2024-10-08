//
//  SettingsUserDefaultStorage.swift
//  DomainModule
//
//  Created by Chien Pham on 07/09/2024.
//

import DomainModule

public final class SettingsUserDefaultStorage: SettingsStorage {

    private let userDefaultCoordinator: UserDefaultCoordinator

    public init(userDefaultCoordinator: UserDefaultCoordinator) {
        self.userDefaultCoordinator = userDefaultCoordinator
    }

    public func fetchSettings(forKey key: String) -> DMSettings {
        userDefaultCoordinator.get(
            forKey: key,
            as: SettingsCodable.self
        )?.domain ?? .defaultValue
    }

    public func updateSettings(_ settings: DMSettings, forKey key: String) async throws -> DMSettings {
        try await withCheckedThrowingContinuation { continuation in
            let settingsCodable = SettingsCodable(from: settings)
            let result = userDefaultCoordinator.set(settingsCodable, forKey: key)
            continuation.resume(with: result.map({ $0.domain }))
        }
    }
}
