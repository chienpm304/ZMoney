//
//  Date+Extensions.swift
//  ZMoney
//
//  Created by Chien Pham on 01/09/2024.
//

import Foundation

extension Date {
    static func numberOfWeeksBetween(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current

        // Calculate the range of weeks
        let startWeek = calendar.component(.weekOfYear, from: startDate)
        let endWeek = calendar.component(.weekOfYear, from: endDate)

        // Calculate the total number of weeks, considering the year transition
        let startYear = calendar.component(.yearForWeekOfYear, from: startDate)
        let endYear = calendar.component(.yearForWeekOfYear, from: endDate)

        let totalWeeks = (endYear - startYear) * 52 + (endWeek - startWeek) + 1

        return totalWeeks
    }

    // MARK: Formatter

    func formatDateMediumWithShortWeekday() -> String {
        let dateString = self.toFormat("dd/MM/yyyy")
        let weekdayName = self.weekdayName(.short)
        return "\(dateString)" + " (\(weekdayName))"
    }
}
