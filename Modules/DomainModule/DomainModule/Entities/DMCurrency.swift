//
//  DMCurrency.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

public enum DMCurrency: String {
    case vnd = "VND"
    case usd = "USD"
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
}
