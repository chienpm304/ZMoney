//
//  SettingsModel.swift
//  ZMoney
//
//  Created by Chien Pham on 12/09/2024.
//

import Foundation
import DomainModule

struct SettingsModel: Equatable {
    var currency: DMCurrency
    var language: DMLanguage

    init (domain: DMSettings) {
        self.currency = domain.currency
        self.language = domain.language
    }

    var domain: DMSettings {
        DMSettings(currency: currency, language: language)
    }
}

extension DMLanguage: Identifiable {
    public var id: String { rawValue }
}

extension DMCurrency: Identifiable {
    public var id: String { rawValue }
}
