//
//  MonthlyReportTransactionsModel.swift
//  ZMoney
//
//  Created by Chien Pham on 16/09/2024.
//

import Foundation
import DomainModule

struct MonthlyReportTransactionsItemModel: Identifiable {
    var id: Date { month }

    let month: Date
    let amount: MoneyValue
}

struct MonthlyReportTransactionsModel {
    var itemModels: [MonthlyReportTransactionsItemModel]
    var timeRange: DateRange

    init(
        timeRange: DateRange,
        reportData: [(TimeValue, MoneyValue)]
    ) {
        self.timeRange = timeRange
        self.itemModels = reportData.map { (timeValue, amount) in
            MonthlyReportTransactionsItemModel(month: timeValue.dateValue, amount: amount)
        }
    }

    var totalAmount: MoneyValue {
        itemModels.reduce(into: 0) { $0 += $1.amount }
    }

    var averageAmount: MoneyValue {
        guard !itemModels.isEmpty else { return 0 }
        return totalAmount / Int64(itemModels.count)
    }
}
