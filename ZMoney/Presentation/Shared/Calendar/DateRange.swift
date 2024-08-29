//
//  DateRange.swift
//  ZMoney
//
//  Created by Chien Pham on 29/08/2024.
//

import Foundation

struct DateRange {
    let startDate: Date
    let endDate: Date
}

enum DateRangeType {
    case month
    case year
}

extension DateRangeType {
    func dateRange(of date: Date) -> DateRange {
        switch self {
        case .month:
            return DateRange(
                startDate: .now.dateAtStartOf(.month),
                endDate: .now.dateAtEndOf(.month)
            )
        case .year:
            return DateRange(
                startDate: .now.dateAtStartOf(.year),
                endDate: .now.dateAtEndOf(.year)
            )
        }
    }
}
