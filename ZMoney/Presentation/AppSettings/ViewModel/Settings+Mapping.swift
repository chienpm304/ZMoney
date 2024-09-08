//
//  Settings+Mapping.swift
//  ZMoney
//
//  Created by Chien Pham on 08/09/2024.
//

import Foundation
import DomainModule

extension DMSettings: Equatable {
    public static func == (lhs: DMSettings, rhs: DMSettings) -> Bool {
        lhs.currency == rhs.currency
        && lhs.language == rhs.language
    }
}

extension DMLanguage: Identifiable, CaseIterable {
    public var id: String { rawValue }

    public static var allCases: [DMLanguage] {
        [.vi, .en]
    }
}

extension DMCurrency: Identifiable, CaseIterable {
    public var id: String { rawValue }

    public static var allCases: [DMCurrency] {
        [.vnd, .usd]
    }
}
