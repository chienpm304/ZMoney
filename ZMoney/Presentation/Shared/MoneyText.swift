//
//  MoneyText.swift
//  ZMoney
//
//  Created by Chien Pham on 02/09/2024.
//

import SwiftUI
import DomainModule

enum MoneyTextStyle {
    case income
    case expense
    case report
}

fileprivate extension DMTransactionType {
    var moneyTextStyle: MoneyTextStyle {
        switch self {
        case .expense:
            return .expense
        case .income:
            return .income
        }
    }
}

struct MoneyText: View {
    @EnvironmentObject var appSettings: AppSettings
    private let value: MoneyValue
    private let style: MoneyTextStyle
    private let hideCurrencySymbol: Bool

    init(
        value: MoneyValue,
        type: DMTransactionType,
        hideCurrencySymbol: Bool = false
    ) {
        self.value = value
        self.style = type.moneyTextStyle
        self.hideCurrencySymbol = hideCurrencySymbol
    }

    init(
        value: MoneyValue,
        style: MoneyTextStyle,
        hideCurrencySymbol: Bool = false
    ) {
        self.value = value
        self.style = style
        self.hideCurrencySymbol = hideCurrencySymbol
    }

    var body: some View {
        Text(formattedValue)
            .foregroundColor(style == .report ? .primary : (style == .expense ? .red : .blue))
    }

    private var formattedValue: String {
        let formatter = appSettings.currencyFormatter
        formatter.positiveSuffix = hideCurrencySymbol ? "" : " \(appSettings.currencySymbol)"
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

#Preview {
    VStack {
        MoneyText(value: 123456, type: .expense)
            .font(.title.weight(.medium))
        MoneyText(value: 123456, type: .income)
    }
}
