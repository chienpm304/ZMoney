//
//  TransactionDetail.swift
//  ZMoney
//
//  Created by Chien Pham on 29/08/2024.
//

import SwiftUI
import DomainModule

struct TransactionDetail: View {
    private let transaction: DMTransaction?
    private let isNew: Bool

    init(transaction: DMTransaction? = nil, isNew: Bool) {
        self.transaction = transaction
        self.isNew = isNew
    }

    var body: some View {
        VStack {
            if let transaction {
                Text("amout: \(transaction.amount)")
                Text(transaction.memo ?? "")
            } else {
                Text("new transaction")
            }
        }
        .navigationTitle(isNew ? "New transaction" : "Edit transaction")
    }
}

#Preview {

    VStack {
        TransactionDetail(isNew: true)
        Divider()
        TransactionDetail(
            transaction: DMTransaction(
                inputTime: Date().timeValue,
                amount: 123423,
                memo: "Com ga",
                category: .defaultExpenseCategories.first!
            ),
            isNew: false
        )
    }
}
