//
//  TransactionsListItemModel.swift
//  ZMoney
//
//  Created by Chien Pham on 29/08/2024.
//

import Foundation
import DomainModule

struct TransactionsListItemModel: Identifiable {
    let id: ID
    let inputDate: Date
    let amount: MoneyValue
    let memo: String?
    let categoryName: String
    let categoryIcon: String
    let categoryColor: String
    let transactionType: DMTransactionType

    init(transaction: DMTransaction) {
        self.id = transaction.id
        self.inputDate = transaction.inputTime.dateValue
        self.amount = transaction.amount
        self.memo = transaction.memo
        self.categoryName = transaction.category.name
        self.categoryIcon = transaction.category.icon
        self.categoryColor = transaction.category.color
        self.transactionType = transaction.category.type
    }
}
