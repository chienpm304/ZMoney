//
//  TransactionsListWithCalendarView.swift
//  ZMoney
//
//  Created by Chien Pham on 29/08/2024.
//

import SwiftUI

struct TransactionsListWithCalendarView: View {
    @EnvironmentObject var appSettings: AppSettings
    @ObservedObject private var viewModel: TransactionsListViewModel

    private var startDate: Date { viewModel.dateRange.startDate }
    private var endDate: Date { viewModel.dateRange.endDate }

    init(viewModel: TransactionsListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            DateRangePicker(dateRange: viewModel.dateRange, type: viewModel.dateRangeType) {
                viewModel.didTapPreviousDateRange()
            } didTapNextDateRange: {
                viewModel.didTapNextDateRange()
            }
            .padding(.horizontal, 24)

            ZCalendarView(
                startDate: viewModel.dateRange.startDate,
                endDate: viewModel.dateRange.endDate,
                selectedDate: viewModel.selectedDate,
                incomeValue: viewModel.totalIncome(in:),
                expenseValue: viewModel.totalExpense(in:),
                onTapDate: { date, tapCount in
                    viewModel.didTapDate(date, tapCount: tapCount)
                }
            )
            .padding(.top, 8)
            .padding(.horizontal, 12)
            .padding(.bottom, -calendarViewBottomSpace)

            ScrollViewReader { scrollViewProxy in
                TransactionsListView(dataModel: viewModel.dataModel) {
                    viewModel.didTapTransactionItem($0)
                }
                .background(Color.systemBackground)
                .onChange(of: viewModel.scrollToDate) { newDate in
                    if let date = newDate {
                        withAnimation {
                            scrollViewProxy.scrollTo(date, anchor: .top)
                        }
                    }
                }
            }
            .padding(.top, 8)
        }
        .resultAlert(alertData: $viewModel.alertData)
        .navigationTitle("Transactions")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.didTapSearchButton()
                } label: {
                    Image(systemName: "magnifyingglass")
                }
            }
        }
        .task {
            await viewModel.refreshData()
        }
    }

    // Workaround to archieve Horizon Calendar auto height
    private var calendarViewBottomSpace: CGFloat {
        // The caldendar view height's is for 6 weeks
        abs(CGFloat(40 * (numberOfWeeks - 6)))
    }

    private var numberOfWeeks: Int {
        Date.numberOfWeeksBetween(
            startDate: viewModel.dateRange.startDate,
            endDate: viewModel.dateRange.endDate
        )
    }
}

#Preview {
    NavigationView {
        TransactionsListWithCalendarView(viewModel: .makePreviewViewModel())
    }
}
