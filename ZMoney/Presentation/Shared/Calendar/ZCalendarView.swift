//
//  ZCalendarView.swift
//  ZMoney
//
//  Created by Chien Pham on 27/08/2024.
//

import SwiftUI
import HorizonCalendar
import DomainModule

struct ZCalendarView: View {
    var startDate: Date
    var endDate: Date
    var selectedDate: Date?
    var incomeValue: ((Date) -> MoneyValue)?
    var expenseValue: ((Date) -> MoneyValue)?
    var onTapDate: ((Date, Int/*Tap count*/) -> Void)?

    init(
        startDate: Date = .now.dateAtStartOf(.month),
        endDate: Date = .now.dateAtEndOf(.month),
        selectedDate: Date? = nil,
        incomeValue: ((Date) -> MoneyValue)? = nil,
        expenseValue: ((Date) -> MoneyValue)? = nil,
        onTapDate: ((Date, Int) -> Void)? = nil
    ) {
        self.startDate = startDate
        self.endDate = endDate
        self.selectedDate = selectedDate
        self.incomeValue = incomeValue
        self.expenseValue = expenseValue
        self.onTapDate = onTapDate
    }

    private var visibleDateRange: ClosedRange<Date> {
        startDate...endDate
    }

    private var calendar: Calendar { .current }

    private var dayOfWeekHeaderHeight: CGFloat { 25 }

    var body: some View {
        CalendarViewRepresentable(
            visibleDateRange: visibleDateRange,
            monthsLayout: .horizontal,
            dataDependency: nil
        )
        .dayAspectRatio(0.7)
        .dayOfWeekAspectRatio(0.5)
        .monthHeaders({ _ in EmptyView() })
        .dayOfWeekHeaders { _, weekdayIndex in
            Text(Date().sharedFormatter.shortWeekdaySymbols[weekdayIndex])
                .fontWeight(.medium)
                .foregroundStyle(Color.white)
                .font(.system(size: 12))
                .frame(maxWidth: .infinity, maxHeight: dayOfWeekHeaderHeight)
                .background(.blue)
        }
        .days { [selectedDate] day in
            let date = calendar.date(from: day.components)
            let isSelected = calendar.isDate(
                date ?? .distantFuture,
                inSameDayAs: selectedDate ?? .distantPast
            )

            VStack(alignment: .leading) {
                HStack {
                    Text("\(day.day)")
                        .font(.system(size: 10))
                        .padding(.leading, 2)
                        .padding(.top, 1)
                    Spacer()
                }

                Spacer(minLength: 0)

                VStack(alignment: .trailing) {
                    if let date {
                        if let income = incomeValue?(date), income > 0 {
                            HStack {
                                Spacer(minLength: 2)
                                Text("\(income)")
                                    .moneyColor(type: .income)
                                    .lineLimit(1)
                            }
                        }
                        if let expense = expenseValue?(date), expense > 0 {
                            HStack {
                                Spacer(minLength: 2)
                                Text("\(expense)")
                                    .moneyColor(type: .expense)
                                    .lineLimit(1)
                            }
                        }
                    }
                }
                .font(.system(size: 8))
            }
            .padding(2)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(isSelected ? .blue.opacity(0.2) : .clear)
            .overlay {
                Rectangle()
                    .stroke(.gray, lineWidth: 0.5)
            }
            .onTapGesture(count: 2, perform: {
                if let date = calendar.date(from: day.components) {
                    onTapDate?(date, 2)
                }
            })
        }
        .onDaySelection { day in
            if let date = calendar.date(from: day.components) {
                onTapDate?(date, 1)
            }
        }
    }
}

#Preview {
    ZCalendarView(
        incomeValue: { _ in return 20_00_000 },
        expenseValue: { _ in return 100_000 }
    )
}
