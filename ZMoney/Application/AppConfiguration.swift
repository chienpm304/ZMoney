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

    var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.positivePrefix = ""
        formatter.positiveSuffix = " \(currencySymbol)"
        return formatter
    }
}
