//
//  AppConfiguration.swift
//  ZMoney
//
//  Created by Chien Pham on 19/08/2024.
//

import Foundation
import DomainModule

final class AppConfiguration {
    let settings: AppSettings

    init() {
        self.settings = AppSettings()
    }
}

final class AppSettings: ObservableObject {
    @Published var currency: DMCurrency = .vnd
    @Published var language: DMLanguage = .vi

    var currencySymbol: String {
        currency.symbol
    }

    var maxMoneyDigits: Int { 12 }

    lazy var currencyFormatter: NumberFormatter = {
        let formatter = baseCurrencyFormatter
        formatter.positiveSuffix = " \(currencySymbol)"
        return formatter
    }()

    lazy var currencyFormatterWithoutSymbol: NumberFormatter = {
        let formatter = baseCurrencyFormatter
        formatter.positiveSuffix = ""
        return formatter
    }()

    private var baseCurrencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = ","
        formatter.positivePrefix = ""
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }
}
