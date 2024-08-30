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
                Text("\(formattedDate(viewModel.startDate)) - \(formattedDate(viewModel.endDate))")
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
            .padding(.horizontal, 12)

            ScrollViewReader { scrollViewProxy in
                List {
                    ForEach(viewModel.itemsMap.keys.sorted(), id: \.self) { date in
                        Section {
                            let transactions = viewModel.itemsMap[date] ?? []
                            ForEach(transactions) { transaction in
                                transactionRow(transaction: transaction)
                            }
                        } header: {
                            Text(formattedDate(date))
                                .id(date)
                        }
                    }
                }
                .listRowInsets(.init(top: 20, leading: 20, bottom: 20, trailing: 20))
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

    private func transactionRow(transaction: TransactionsListItemModel) -> some View {
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
            }
            Spacer()
            Text("\(transaction.amount) VND")
                .moneyColor(type: transaction.transactionType)
        }
        .withRightArrow()
        .onTapGesture {
            viewModel.didTapTransactionItem(transaction)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}

// #Preview {
//     TransactionsListView(viewModel: )
// }
