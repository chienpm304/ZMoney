//
//  DMSettings.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

public struct DMSettings {
    public var currency: DMCurrency
    public var language: DMLanguage

    public init(currency: DMCurrency, language: DMLanguage) {
        self.currency = currency
        self.language = language
    }
}

extension DMSettings {
    public static var defaultValue: Self {
        DMSettings(
            currency: .defaultValue,
            language: .defaultValue
        )
    }
}
