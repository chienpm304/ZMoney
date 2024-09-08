//
//  Setting+Mapping.swift
//  DataModule
//
//  Created by Chien Pham on 08/09/2024.
//

import Foundation
import DomainModule

struct SettingsCodable: Codable {
    let currency: String
    let language: String

    init(from settings: DMSettings) {
        self.currency = settings.currency.rawValue
        self.language = settings.language.rawValue
    }
}

extension SettingsCodable {
    var domain: DMSettings {
        DMSettings(
            currency: DMCurrency(rawValue: currency) ?? .defaultValue,
            language: DMLanguage(rawValue: language) ?? .defaultValue
        )
    }
}
