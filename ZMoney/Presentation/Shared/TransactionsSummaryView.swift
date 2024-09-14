//
//  TransactionsSummaryView.swift
//  ZMoney
//
//  Created by Chien Pham on 14/09/2024.
//

import SwiftUI
import DomainModule

struct TransactionsSummaryView: View {
    let totalIncome: MoneyValue
    let totalExpense: MoneyValue
    let total: MoneyValue

    var body: some View {
        HStack {
            VStack {
                Text("Income")
                MoneyText(value: totalIncome, type: .income)
            }
            Spacer()
            VStack {
                Text("Expense")
                MoneyText(value: totalExpense, type: .expense)
            }
            Spacer()
            VStack {
                Text("Total")
                MoneyText(
                    value: total,
                    type: total > 0 ? .income : .expense
                )
            }
        }
    }
}
