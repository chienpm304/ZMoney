//
//  SettingsRepository.swift
//  DomainModule
//
//  Created by Chien Pham on 07/09/2024.
//

import Foundation

public protocol SettingsRepository {
    func fetchSettings() async -> DMSettings

    func updateSettings(_ settings: DMSettings) async throws -> DMSettings
}
