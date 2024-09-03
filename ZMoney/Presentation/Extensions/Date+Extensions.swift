//
//  Date+Extensions.swift
//  ZMoney
//
//  Created by Chien Pham on 01/09/2024.
//

import Foundation

extension Date {
    static func numberOfWeeksBetween(startDate: Date, endDate: Date) -> Int {
        var calendar = Calendar.current
        calendar.firstWeekday = 1 // Sunday as the first day of the week

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
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self) + " (\(self.weekdayName(.short)))"
    }
}
