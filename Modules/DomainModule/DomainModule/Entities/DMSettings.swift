//
//  DMSettings.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

public struct DMSettings: Codable {
    public var currency: DMCurrency
    public var language: DMLanguage
}

extension DMSettings {
    public static var defaultSetting: Self {
        DMSettings(currency: .vnd, language: .vi)
    }
}
