//
//  HeaderDateView.swift
//  ZMoney
//
//  Created by Chien Pham on 07/09/2024.
//

import SwiftUI

struct HeaderDateView: View {
    let dateRange: DateRange

    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Text(monthYearString)
                .font(.body)
                .bold()
            Text(dayRangeString)
                .font(.callout)
                .foregroundColor(.secondary)
        }
        .padding(4)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.secondarySystemBackground)
        )
    }

    private var monthYearString: String {
        dateRange.startDate.toFormat("MMM yyyy")
    }

    private var dayRangeString: String {
        let startDayString = dateRange.startDate.toFormat("MMM dd")
        let endDayString = dateRange.endDate.toFormat("MMM dd")
        return "(\(startDayString) - \(endDayString))"
    }
}
