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

    public func fetchSettings() async -> DMSettings {
        await withCheckedContinuation { continuation in
            let settings = settingsStorage.fetchSettings(forKey: Keys.settings.rawValue)
            continuation.resume(returning: settings)
        }
    }

    public func updateSettings(_ settings: DMSettings) async throws -> DMSettings {
        try await withCheckedThrowingContinuation { continuation in
            settingsStorage.updateSettings(
                settings,
                forKey: Keys.settings.rawValue
            ) { result in
                continuation.resume(with: result)
            }
        }
    }
}
