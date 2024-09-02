//
//  DMCurrency.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

public enum DMCurrency: String, CaseIterable, Identifiable {
    case vnd = "VND"
    case usd = "USD"

    public var id: String { rawValue }
}

extension DMCurrency {
    public var symbol: String {
        switch self {
        case .vnd:
            return "₫"
        case .usd:
            return "$"
        }
    }

    public var displayName: String {
        switch self {
        case .vnd:
            return "Vietnamese Dong (\(symbol))"
        case .usd:
            return "US Dollar (\(symbol))"
        }
    }
}
