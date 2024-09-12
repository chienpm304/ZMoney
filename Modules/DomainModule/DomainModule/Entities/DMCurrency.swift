//
//  DMCurrency.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

public enum DMCurrency: String, CaseIterable {
    case vnd = "VND"
    case usd = "USD"
}

extension DMCurrency {
    public static var defaultValue: Self { .vnd }

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
