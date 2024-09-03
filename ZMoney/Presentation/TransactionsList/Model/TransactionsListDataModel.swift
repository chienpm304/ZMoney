//
//  TransactionsListDataModel.swift
//  ZMoney
//
//  Created by Chien Pham on 02/09/2024.
//

import Foundation
import DomainModule

struct TransactionsListDataModel {
    private let dateToItems: [Date: [TransactionsListItemModel]]
    private let transactions: [DMTransaction]

    init(
        transactions: [DMTransaction]
    ) {
        self.transactions = transactions
        let items = transactions.map(TransactionsListItemModel.init)
        self.dateToItems = Dictionary(grouping: items, by: { $0.inputDate.dateAtStartOf(.day).date })
    }

    // MARK: Public

    var topScrollDate: Date? { earliestDate(from: dateToItems) }

    func totalExpense(in date: Date) -> MoneyValue { totalAmount(of: .expense, in: date) }

    func totalIncome(in date: Date) -> MoneyValue { totalAmount(of: .income, in: date) }

    var totalExpense: MoneyValue { totalAmount(of: .expense) }

    var totalIncome: MoneyValue { totalAmount(of: .income) }

    var total: MoneyValue { totalIncome - totalExpense }

    func transaction(by id: ID) -> DMTransaction? { transactions.first(where: { $0.id == id }) }

    var sortedDates: [Date] { dateToItems.keys.sorted() }

    func items(inSameDateAs date: Date) -> (Date, [TransactionsListItemModel])? {
        guard let dateInModel = dateToItems.keys.first(where: {
            Calendar.current.isDate($0, inSameDayAs: date)
        })
        else { return nil }
        return (dateInModel, dateToItems[dateInModel] ?? [])
    }

    // MARK: Private

    private func totalAmount(of type: DMTransactionType, in date: Date) -> MoneyValue {
        transactions
            .filter {
                Calendar.current.isDate($0.inputTime.dateValue, inSameDayAs: date)
            }
            .filter { $0.category.type == type }
            .map { $0.amount }
            .reduce(0, +)
    }

    private func totalAmount(of type: DMTransactionType) -> MoneyValue {
        transactions
            .filter { $0.category.type == type }
            .map { $0.amount }
            .reduce(0, +)
    }

    private func earliestDate(from itemsMap: [Date: [TransactionsListItemModel]]) -> Date? {
        itemsMap.keys.sorted().first?.dateByAdding(-1, .day).date
    }
}
