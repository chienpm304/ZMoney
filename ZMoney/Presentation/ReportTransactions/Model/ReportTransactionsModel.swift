//
//  ReportTransactionsModel.swift
//  ZMoney
//
//  Created by Chien Pham on 14/09/2024.
//

import Foundation
import DomainModule

struct ReportTransactionsModel {
    private let transactions: [(DMCategory, MoneyValue)]

    var selectedType: CategoryTab

    init(transactions: [(DMCategory, MoneyValue)], selectedType: CategoryTab = .expense) {
        self.transactions = transactions
        self.selectedType = selectedType
    }

    var itemsModel: [ReportTransactionItemModel] {
        let totalAmountForType = filteredTransactions
            .reduce(into: 0) { $0 += $1.1 }

        guard totalAmountForType != 0 else { return [] }

        return filteredTransactions
            .map { (category, amount) in
                let percent = (Double(amount) / Double(totalAmountForType)) * 100

                return ReportTransactionItemModel(
                    category: CategoryDetailModel(category: category),
                    amount: amount,
                    percent: percent
                )
            }
            .sorted { $0.amount > $1.amount }
    }

    var totalExpense: MoneyValue { totalAmount(of: .expense) }

    var totalIncome: MoneyValue { totalAmount(of: .income) }

    var total: MoneyValue { totalIncome - totalExpense }

    // MARK: Private

    private var filteredTransactions: [(DMCategory, MoneyValue)] {
        transactions
            .filter { $0.0.type == selectedType.domainType }
    }

    private func totalAmount(of type: DMTransactionType) -> MoneyValue {
        transactions
            .filter { $0.0.type == type }
            .reduce(into: 0) { $0 += $1.1 }
    }
}
