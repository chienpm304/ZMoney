//
//  ReportTransactionsModel.swift
//  ZMoney
//
//  Created by Chien Pham on 14/09/2024.
//

import Foundation
import DomainModule

struct ReportTransactionsModel {
    private let transactions: [DMTransaction]

    var selectedType: CategoryTab

    init(transactions: [DMTransaction], selectedType: CategoryTab = .expense) {
        self.transactions = transactions
        self.selectedType = selectedType
    }

    var itemsModel: [ReportTransactionItemModel] {
        let totalAmountForType = filteredTransactions
            .map { $0.amount }
            .reduce(0, +)

        guard totalAmountForType != 0 else { return [] }

        return Dictionary(grouping: filteredTransactions) {
            $0.category
        }.map { key, value in
            let totalCategoryAmount = value.reduce(into: 0) { partialResult, transaction in
                partialResult += transaction.amount
            }

            // Calculate the percentage of the total amount for this category
            let percent = (Double(totalCategoryAmount) / Double(totalAmountForType)) * 100

            return ReportTransactionItemModel(
                category: CategoryDetailModel(category: key),
                amount: totalCategoryAmount,
                percent: percent
            )
        }.sorted { $0.amount > $1.amount }
    }

    var totalExpense: MoneyValue { totalAmount(of: .expense) }

    var totalIncome: MoneyValue { totalAmount(of: .income) }

    var total: MoneyValue { totalIncome - totalExpense }

    // MARK: Private

    private var filteredTransactions: [DMTransaction] {
        transactions.filter { $0.category.type == selectedType.domainType }
    }

    private func totalAmount(of type: DMTransactionType) -> MoneyValue {
        transactions
            .filter { $0.category.type == type }
            .map { $0.amount }
            .reduce(0, +)
    }
}
