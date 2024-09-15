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

    @State private var testDate = Date()

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

            ScrollViewReader { scrollViewProxy in
                TransactionsListView(dataModel: viewModel.dataModel) {
                    viewModel.didTapTransactionItem($0)
                }
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
        .onAppear {
            viewModel.onViewAppear()
        }
    }
}

#Preview {
    NavigationView {
        TransactionsListWithCalendarView(viewModel: .makePreviewViewModel())
    }
}
