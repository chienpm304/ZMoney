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
    
    // TODO: make SettingsJson and map with DMSettings
    public func fetchSettings(forKey key: String) -> DMSettings {
        return userDefaultCoordinator.get(
            forKey: key,
            as: DMSettings.self
        ) ?? .defaultSetting
    }

    public func updateSettings(
        _ settings: DMSettings,
        forKey key: String,
        completion: @escaping (Result<DMSettings, DMError>) -> Void
    ) {
        let result = userDefaultCoordinator.set(settings, forKey: key)
        completion(result)
    }
}
