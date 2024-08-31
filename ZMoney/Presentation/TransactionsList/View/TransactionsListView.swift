//
//  TransactionsListView.swift
//  ZMoney
//
//  Created by Chien Pham on 29/08/2024.
//

import SwiftUI

struct TransactionsListView: View {
    @ObservedObject private var viewModel: TransactionsListViewModel

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
                HeaderDateView(startDate: viewModel.startDate, endDate: viewModel.endDate)
                Spacer()
                Button {
                    viewModel.didTapNextDateRange()
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal, 24)

            ZCalendarView(
                startDate: viewModel.startDate,
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
                                    .fontWeight(.medium)
                                Text("\(viewModel.totalIncome)")
                                    .fontWeight(.medium)
                                    .moneyColor(type: .income)
                            }
                            Spacer()
                            VStack {
                                Text("Expense")
                                    .fontWeight(.medium)
                                Text("\(viewModel.totalExpense)")
                                    .fontWeight(.medium)
                                    .moneyColor(type: .expense)
                            }
                            Spacer()
                            VStack {
                                Text("Total")
                                    .fontWeight(.medium)
                                Text("\(viewModel.total)")
                                    .fontWeight(.medium)
                                    .moneyColor(type: viewModel.total > 0 ? .income : .expense)
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                        .listRowSeparator(.hidden)
                        .font(.caption)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .id(Date.distantPast)
                    }

                    ForEach(viewModel.itemsMap.keys.sorted(), id: \.self) { date in
                        Section {
                            let transactions = viewModel.itemsMap[date] ?? []
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
        }
        .onAppear {
            viewModel.onViewAppear()
        }
        .navigationTitle("Transactions")
        .toolbar {
            Button {
                viewModel.didTapDate(.now, tapCount: 2)
            } label: {
                Image(systemName: "plus")
            }
        }
    }

    private func sectionHeaderDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date) + " (\(date.weekdayName(.short)))"
    }
}

#Preview {
    NavigationView {
        TransactionsListView(viewModel: .makePreviewViewModel())
    }
}

struct HeaderDateView: View {
    let startDate: Date
    let endDate: Date

    var body: some View {
        HStack(alignment: .center, spacing: 4) {
            Text(monthYearString)
                .font(.body)
                .bold()
            Text(dayRangeString)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 2)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(.black.opacity(0.05))
        )
    }

    private var monthYearString: String {
        startDate.toFormat("MMM yyyy")
    }

    private var dayRangeString: String {
        let startDayString = startDate.toFormat("MMM dd")
        let endDayString = endDate.toFormat("MMM dd")
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
            Circle()
                .fill(Color(hex: transaction.categoryColor))
                .frame(width: 30, height: 30)
                .overlay(
                    Image(systemName: transaction.categoryIcon)
                        .foregroundColor(.white)
                )
            if let memo = transaction.memo {
                Text(memo)
                    .foregroundColor(.secondary)
                    .fontWeight(.medium)
            }
            Spacer()
            Text("\(transaction.amount)")
                .fontWeight(.medium)
                .moneyColor(type: transaction.transactionType)
        }
        .withRightArrow()
        .onTapGesture {
            viewModel.didTapTransactionItem(transaction)
        }
    }
}
