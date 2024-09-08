//
//  DMLanguage.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

// swiftlint:disable identifier_name

public enum DMLanguage: String, CaseIterable, Identifiable, Codable {
    case vi
    case en

    public var id: String { rawValue }
}

extension DMLanguage {
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
