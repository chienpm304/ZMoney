//
//  MoneyText.swift
//  ZMoney
//
//  Created by Chien Pham on 02/09/2024.
//

import SwiftUI
import DomainModule

struct MoneyText: View {
    @EnvironmentObject var appSettings: AppSettings
    private let value: MoneyValue
    private let type: DMTransactionType
    private let hideCurrencySymbol: Bool

    init(
        value: MoneyValue,
        type: DMTransactionType,
        hideCurrencySymbol: Bool = false
    ) {
        self.value = value
        self.type = type
        self.hideCurrencySymbol = hideCurrencySymbol
    }

    var body: some View {
        Text(formattedValue)
            .foregroundColor(type == .expense ? .red : .blue)
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
