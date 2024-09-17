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
    case adaptive
    case report
    case custom(Color)
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
            .foregroundColor(textColor)
    }

    var textColor: Color {
        switch style {
        case .income:
            return .blue
        case .expense:
            return .red
        case .adaptive:
            return value > 0 ? .blue : .red
        case .report:
            return .primary
        case .custom(let color):
            return color
        }
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
