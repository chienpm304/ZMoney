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
    public static var defaultValue: Self { .vi }

    public var displayName: String {
        switch self {
        case .vi:
            "Tiếng Việt"
        case .en:
            "English"
        }
    }
}

// swiftlint:enable identifier_name
