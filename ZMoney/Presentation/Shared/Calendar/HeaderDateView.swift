//
//  HeaderDateView.swift
//  ZMoney
//
//  Created by Chien Pham on 07/09/2024.
//

import SwiftUI

struct HeaderDateView: View {
    let dateRange: DateRange
    let type: DateRangeType

    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Text(primaryString)
                .font(.body)
                .bold()
            Text(secondaryString)
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

    private var primaryString: String {
        switch type {
        case .month:
            dateRange.startDate.toFormat("MMM yyyy")
        case .year:
            dateRange.startDate.toFormat("yyyy")
        }
    }

    private var secondaryString: String {
        let startDayString = dateRange.startDate.toFormat("MMM dd")
        let endDayString = dateRange.endDate.toFormat("MMM dd")
        return "(\(startDayString) - \(endDayString))"
    }
}

struct DateRangePicker: View {
    let dateRange: DateRange
    let type: DateRangeType
    let didTapPreviousDateRange: () -> Void
    let didTapNextDateRange: () -> Void

    var body: some View {
        HStack {
            Button {
                didTapPreviousDateRange()
            } label: {
                Image(systemName: "chevron.left")
            }

            Spacer()

            HeaderDateView(dateRange: dateRange, type: type)

            Spacer()

            Button {
                didTapNextDateRange()
            } label: {
                Image(systemName: "chevron.right")
            }
        }
    }
}
