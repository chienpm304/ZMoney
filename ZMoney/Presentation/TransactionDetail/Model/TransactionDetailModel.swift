//
//  TransactionDetailModel.swift
//  ZMoney
//
//  Created by Chien Pham on 03/09/2024.
//

import DomainModule

struct TransactionDetailModel {
    var id: ID
    var inputTime: Date
    var amount: MoneyValue
    var memo: String
    var category: CategoryDetailModel

    var transactionType: CategoryTab {
        get { category.type.toViewModel }
        set { category.type = newValue.domainType }
    }
}

extension TransactionDetailModel {
    init(transaction: DMTransaction) {
        self.id = transaction.id
        self.inputTime = transaction.inputTime.dateValue
        self.amount = transaction.amount
        self.memo = transaction.memo ?? ""
        self.category = CategoryDetailModel(category: transaction.category)
        self.transactionType = category.type.toViewModel
    }

    var domain: DMTransaction {
        .init(
            id: id,
            inputTime: inputTime.timeValue,
            amount: amount,
            memo: memo,
            category: category.domain
        )
    }

    private static var defaultTransactionType: DMTransactionType { .expense }

    static func defaultTransaction(inputDate: Date = .now) -> TransactionDetailModel {
        let categoryPlaceHolder = DMCategory(type: Self.defaultTransactionType)
        return TransactionDetailModel(
            id: .generate(),
            inputTime: inputDate,
            amount: 0,
            memo: "",
            category: CategoryDetailModel(category: categoryPlaceHolder)
        )
    }
}
