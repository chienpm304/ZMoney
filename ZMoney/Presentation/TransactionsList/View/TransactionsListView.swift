//
//  TransactionsListView.swift
//  ZMoney
//
//  Created by Chien Pham on 29/08/2024.
//

import SwiftUI

struct TransactionsListView: View {
    @EnvironmentObject var appSettings: AppSettings
    @ObservedObject private var viewModel: TransactionsListViewModel

    private var startDate: Date { viewModel.dateRange.startDate }
    private var endDate: Date { viewModel.dateRange.endDate }

    init(viewModel: TransactionsListViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            HStack {
                Button {
                    viewModel.didTapPreviousDateRange()
                } label: {
                    Image(systemName: "chevron.left")
                }
                Spacer()
                HeaderDateView(dateRange: viewModel.dateRange)
                Spacer()
                Button {
                    viewModel.didTapNextDateRange()
                } label: {
                    Image(systemName: "chevron.right")
                }
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
                List {
                    Section {
                        HStack {
                            VStack {
                                Text("Income")
                                MoneyText(value: viewModel.totalIncome, type: .income)
                            }
                            Spacer()
                            VStack {
                                Text("Expense")
                                MoneyText(value: viewModel.totalExpense, type: .expense)
                            }
                            Spacer()
                            VStack {
                                Text("Total")
                                MoneyText(
                                    value: viewModel.total,
                                    type: viewModel.total > 0 ? .income : .expense
                                )
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                        .listRowSeparator(.hidden)
                        .font(.caption.weight(.medium))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .id(viewModel.topScrollDate)
                    }

                    ForEach(viewModel.sortedDates, id: \.self) { date in
                        Section {
                            let transactions = viewModel.items(inSameDateAs: date) ?? []
                            ForEach(transactions) { transaction in
                                TransactionsListItemView(viewModel: viewModel, transaction: transaction)
                                    .font(.body)
                            }
                        } header: {
                            Text(sectionHeaderDate(date))
                                .fontWeight(.semibold)
                                .id(date)
                        }
                        .listRowInsets(EdgeInsets(top: 4, leading: 20, bottom: 0, trailing: 12))
                        .listRowSeparator(.visible)
                    }
                }
                .listStyle(PlainListStyle())
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
        .onAppear {
            viewModel.onViewAppear()
        }
        .navigationTitle("Transactions")
    }

    // Workaround to archieve Horizon Calendar auto height
    private var calendarViewYOffset: CGFloat {
        // The caldendar view height's is for 6 weeks
        CGFloat(40 * (numberOfWeeks - 6))
    }

    private var numberOfWeeks: Int {
        Date.numberOfWeeksBetween(startDate: startDate, endDate: endDate)
    }

    private func sectionHeaderDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date) + " (\(date.weekdayName(.short)))"
    }
}
#if targetEnvironment(simulator)
#Preview {
    NavigationView {
        TransactionsListView(viewModel: .makePreviewViewModel())
    }
}
#endif

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
                .fill(Color.fieldBackground)
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

struct TransactionsListItemView: View {
    @ObservedObject private var viewModel: TransactionsListViewModel
    private let transaction: TransactionsListItemModel

    init(viewModel: TransactionsListViewModel, transaction: TransactionsListItemModel) {
        self.viewModel = viewModel
        self.transaction = transaction
    }

    var body: some View {
        HStack {
            Image(systemName: transaction.categoryIcon)
                .foregroundColor(Color(hex: transaction.categoryColor))
                .frame(width: 32, height: 32)

            if let memo = transaction.memo {
                Text(memo)
                    .foregroundColor(.secondary)
            }

            Spacer()

            MoneyText(value: transaction.amount, type: transaction.transactionType)
        }
        .font(.body.weight(.medium))
        .withRightArrow()
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.didTapTransactionItem(transaction)
        }
    }
}
