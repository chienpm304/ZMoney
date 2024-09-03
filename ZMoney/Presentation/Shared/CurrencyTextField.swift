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
                formattedAmount
            },
            set: { newValue in
                let cleanAmount = newValue
                    .replacingOccurrences(of: ",", with: "")
                    .replacingOccurrences(of: ".", with: "")

                if let value = MoneyValue(cleanAmount) {
                    amount = value
                    formattedAmount = formatAmount(amount)
                } else {
                    formattedAmount = ""
                }
            }
        ))
        .keyboardType(.decimalPad)
        .onAppear {
            formattedAmount = formatAmount(amount)
        }
    }

    private func formatAmount(_ amount: MoneyValue) -> String {
        let formatter = appSettings.currencyFormatterWithoutSymbol
        return formatter.string(from: amount as NSNumber) ?? ""
    }
}

#Preview {
    List {
        CurrencyTextField("Enter value", amount: .constant(123456))
        CurrencyTextField("Enter value", amount: .constant(0))
    }
    .environmentObject(AppSettings())
}
