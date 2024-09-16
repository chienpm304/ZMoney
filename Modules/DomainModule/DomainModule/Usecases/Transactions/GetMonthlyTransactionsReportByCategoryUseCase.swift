//
//  GetMonthlyTransactionsReportByCategoryUseCase.swift
//  DomainModule
//
//  Created by Chien Pham on 16/09/2024.
//

import Foundation
import SwiftDate

public final class GetMonthlyTransactionsReportByCategoryUseCase: AsyncUseCase {
    public struct Input {
        let category: DMCategory
        let timeRange: DMTimeRange

        public init(category: DMCategory, timeRange: DMTimeRange) {
            self.category = category
            self.timeRange = timeRange
        }
    }

    public typealias Output = [(TimeValue, MoneyValue)] /* start date of month : total amount */

    private let fetchTransactionsByCategoryUseCase: FetchTransactionsByCategoriesUseCase

    public init(fetchTransactionsByCategoryUseCase: FetchTransactionsByCategoriesUseCase) {
        self.fetchTransactionsByCategoryUseCase = fetchTransactionsByCategoryUseCase
    }

    public func execute(input: Input) async throws -> [(TimeValue, MoneyValue)] {
        let startTime = input.timeRange.startTime
        let endTime = input.timeRange.endTime

        let transactions = try await fetchTransactionsByCategoryUseCase.execute(
            input: .init(
                startTime: startTime,
                endTime: endTime,
                category: input.category
            )
        )

        var monthlyTotals: [TimeValue: MoneyValue] = [:]

        for transaction in transactions {
            let transactionMonth = transaction.inputTime.timeValueAtStartOf(.month)

            if let existingTotal = monthlyTotals[transactionMonth] {
                monthlyTotals[transactionMonth] = existingTotal + transaction.amount
            } else {
                monthlyTotals[transactionMonth] = transaction.amount
            }
        }

        var constructedItems: [(TimeValue, MoneyValue)] = []
        var currentMonth = startTime.dateValue.dateAtStartOf(.month)
        let endMonth = endTime.dateValue.dateAtStartOf(.month)

        while currentMonth <= endMonth {
            let totalAmount = monthlyTotals[currentMonth.timeValue] ?? 0
            constructedItems.append((currentMonth.timeValue, totalAmount))
            currentMonth = currentMonth.dateByAdding(1, .month).date
        }

        return constructedItems
    }
}
