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
    @State var startDate = Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 01))!
    @State var endDate = Calendar.current.date(from: DateComponents(year: 2026, month: 8, day: 31))!

    // TODO: rounding with K, M, B .... (k, tr, ty)
    @State var incomeValue: MoneyValue = 123_457_123
    @State var expenseValue: MoneyValue = 1_234_234_232

    private var visibleDateRange: ClosedRange<Date> {
        startDate...endDate
    }

    private var calendar: Calendar { .current }

    var body: some View {
        VStack { // test
            CalendarViewRepresentable(
                visibleDateRange: visibleDateRange,
                monthsLayout: .horizontal,
                dataDependency: nil
            )
            .days { day in
                VStack {
                    HStack {
                        Text("\(day.day)")
                            .font(.system(size: 12))
                        Spacer()
                    }
                    Spacer()

                    if day.day > 10 && day.day < 25 {
                        VStack {
                            Text("\(incomeValue)").foregroundColor(.blue)
                            Text("\(expenseValue)").foregroundColor(.red)
                        }
                        .font(.system(size: 10))
                    }

                }
                .frame(maxWidth: .infinity, maxHeight: 50)
                .padding(1)
                .overlay {
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color(UIColor.gray), lineWidth: 1)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue)
            .border(.green)
        }
        .padding()
        .border(.red)
    }
}

#Preview {
    ZCalendarView()
}
