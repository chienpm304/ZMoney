//
//  SettingsStorage.swift
//  DomainModule
//
//  Created by Chien Pham on 07/09/2024.
//

import Foundation
import DomainModule

public protocol SettingsStorage {
    func fetchSettings(forKey key: String) -> DMSettings

    func updateSettings(
        _ settings: DMSettings,
        forKey key: String,
        completion: @escaping (Result<DMSettings, DMError>) -> Void
    )
}
