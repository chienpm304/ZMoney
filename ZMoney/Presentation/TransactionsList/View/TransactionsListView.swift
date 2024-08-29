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
        List {
            // Break down the complex ForEach into smaller components
            ForEach(viewModel.itemsMap.keys.sorted(), id: \.self) { date in
                Section(header: Text(formattedDate(date))) {
                    let transactions = viewModel.itemsMap[date] ?? []
                    ForEach(transactions) { transaction in
                        transactionRow(transaction: transaction)
                    }
                }
            }
        }
        .onAppear {
            viewModel.onViewAppear()
        }
        .navigationTitle("<\(formattedDate(viewModel.startDate))) - \(formattedDate(viewModel.endDate))>")
        .toolbar {
            Button(action: {
                viewModel.didTapDate(.now, tapCount: 2)
            }) {
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
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text("\(transaction.amount) VND")
                .font(.body)
        }
        .contentShape(Rectangle())
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
