//
//  SettingsRepository.swift
//  DomainModule
//
//  Created by Chien Pham on 07/09/2024.
//

import Foundation

public protocol SettingsRepository {
    func fetchSettings() -> DMSettings

    func updateSettings(
        _ settings: DMSettings,
        completion: @escaping (Result<DMSettings, DMError>) -> Void
    )
}
