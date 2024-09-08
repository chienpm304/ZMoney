//
//  DefaultSettingsRepository.swift
//  DomainModule
//
//  Created by Chien Pham on 07/09/2024.
//

import Foundation

public class DefaultSettingsRepository: SettingsRepository {
    private enum Keys: String {
        case settings
    }

    private let settingsStorage: SettingsStorage

    public init(settingsStorage: SettingsStorage) {
        self.settingsStorage = settingsStorage
    }

    public func fetchSettings() -> DMSettings {
        settingsStorage.fetchSettings(forKey: Keys.settings.rawValue)
    }

    public func updateSettings(
        _ settings: DMSettings,
        completion: @escaping (Result<DMSettings, DMError>) -> Void
    ) {
        settingsStorage.updateSettings(
            settings,
            forKey: Keys.settings.rawValue,
            completion: completion
        )
    }
}
