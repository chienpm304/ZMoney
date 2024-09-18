//
//  DateRange.swift
//  ZMoney
//
//  Created by Chien Pham on 29/08/2024.
//

import SwiftDate
import SwiftUI
import DomainModule

struct DateRange {
    let startDate: Date
    let endDate: Date
}

extension DateRange {
    var domain: DMTimeRange {
        .init(startTime: startDate.timeValue, endTime: endDate.timeValue)
    }

    func contains(date: Date) -> Bool {
        date.isInRange(date: startDate, and: endDate)
    }
}

enum DateRangeType: String, CaseIterable, Identifiable {
    case month
    case year

    var id: Self { self }

    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .month:
            "Month"
        case .year:
            "Year"
        }
    }
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

    func next(of dateRange: DateRange) -> DateRange {
        switch self {
        case .month:
            let nextMonth = dateRange.startDate.dateByAdding(1, .month)
            return DateRange(
                startDate: nextMonth.dateAtStartOf(.month).date,
                endDate: nextMonth.dateAtEndOf(.month).date
            )
        case .year:
            let nextYear = dateRange.startDate.dateByAdding(1, .year)
            return DateRange(
                startDate: nextYear.dateAtStartOf(.year).date,
                endDate: nextYear.dateAtEndOf(.year).date
            )
        }
    }

    func previous(of dateRange: DateRange) -> DateRange {
        switch self {
        case .month:
            let previousMonth = dateRange.startDate.dateByAdding(-1, .month)
            return DateRange(
                startDate: previousMonth.dateAtStartOf(.month).date,
                endDate: previousMonth.dateAtEndOf(.month).date
            )
        case .year:
            let previousYear = dateRange.startDate.dateByAdding(-1, .year)
            return DateRange(
                startDate: previousYear.dateAtStartOf(.year).date,
                endDate: previousYear.dateAtEndOf(.year).date
            )
        }
    }
}
