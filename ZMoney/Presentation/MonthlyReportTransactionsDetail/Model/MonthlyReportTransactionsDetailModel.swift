//
//  MonthlyReportTransactionsDetailModel.swift
//  ZMoney
//
//  Created by Chien Pham on 18/09/2024.
//

import Foundation
import DomainModule

struct MonthlyReportTransactionsDetailModel {
    private let transactions: [DMTransaction]
    let monthlyReportItems: [MonthlyReportTransactionsItemModel]

    init(transactions: [DMTransaction]) {
        self.transactions = transactions
        let monthlyItems = Dictionary(grouping: transactions) {
            $0.inputTime.timeValueAtStartOf(.month)
        }
        monthlyReportItems = monthlyItems
            .map { month, transactions in
                let total = transactions.reduce(0) { $0 + $1.amount }
                return MonthlyReportTransactionsItemModel(month: month.dateValue, amount: total)
            }
            .sorted { $0.month.timeValue < $1.month.timeValue }
    }

    func transactionListModel(for dateRange: DateRange) -> TransactionsListModel {
        let filteredTransactions = transactions
            .filter {
                $0.inputTime.dateValue.isInRange(
                    date: dateRange.startDate,
                    and: dateRange.endDate
                )
            }
        return .init(transactions: filteredTransactions)
    }

    func getTransaction(by id: ID) -> DMTransaction? {
        transactions.first(where: { $0.id == id })
    }
}
