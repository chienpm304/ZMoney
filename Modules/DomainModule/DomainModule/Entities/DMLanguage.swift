//
//  DMLanguage.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

// swiftlint:disable identifier_name

public enum DMLanguage: String {
    case vi
    case en
}

extension DMLanguage {
    public static var defaultValue: Self {
        guard let currentLanguageCode = Locale.current.languageCode,
              let currentLanguage = DMLanguage(rawValue: currentLanguageCode)
        else {
            return .en
        }
        return currentLanguage
    }

    public var displayName: String {
        switch self {
        case .vi:
            "Tiếng Việt"
        case .en:
            "English"
        }
    }

    public var languageCode: String {
        switch self {
        case .vi:
            return "vi"
        case .en:
            return "en"
        }
    }
}

// swiftlint:enable identifier_name
