//
//  CurrencyTextField.swift
//  ZMoney
//
//  Created by Chien Pham on 03/09/2024.
//

import SwiftUI
import DomainModule

struct CurrencyTextField: View {
    @EnvironmentObject var appSettings: AppSettings
    let titleKey: LocalizedStringKey
    @Binding var amount: MoneyValue
    @State private var formattedAmount: String = ""
    init(
        _ titleKey: LocalizedStringKey,
        amount: Binding<MoneyValue>
    ) {
        self.titleKey = titleKey
        self._amount = amount
    }

    var body: some View {
        TextField(titleKey, text: Binding(
            get: {
                print("raw: \(formattedAmount), \(formattedAmount.count)")
                return String(formattedAmount.prefix(16))
            },
            set: { newValue in
                let cleanAmount = newValue.filter { $0.isNumber }

                if let value = MoneyValue(cleanAmount) {
                    amount = value
                    formattedAmount = formatAmount(amount)
                } else {
                    formattedAmount = "0"
                }
            }
        ))
        .keyboardType(.decimalPad)
        .onAppear {
            formattedAmount = formatAmount(amount)
        }
        .onChange(of: amount) { newAmount in
            formattedAmount = formatAmount(newAmount)
        }
    }

    private func formatAmount(_ amount: MoneyValue) -> String {
        let formatter = appSettings.currencyFormatterWithoutSymbol
        let result = formatter.string(from: amount as NSNumber) ?? ""
        print("amount: \(amount) - str: \(result)")
        return result
    }
}

#Preview {
    List {
        CurrencyTextField("Enter value", amount: .constant(123456))
        CurrencyTextField("Enter value", amount: .constant(0))
    }
    .environmentObject(AppSettings())
}
