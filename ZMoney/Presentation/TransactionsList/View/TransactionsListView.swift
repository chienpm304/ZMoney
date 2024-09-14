//
//  TransactionsListView.swift
//  ZMoney
//
//  Created by Chien Pham on 11/09/2024.
//

import Foundation
import SwiftUI

struct TransactionsListView: View {
    private var dataModel: TransactionsListModel
    private var didTapItem: ((TransactionsListItemModel) -> Void)

    init(dataModel: TransactionsListModel, didTapItem: @escaping (TransactionsListItemModel) -> Void) {
        self.dataModel = dataModel
        self.didTapItem = didTapItem
    }

    var body: some View {
        List {
            Section {
                TransactionsSummaryView(
                    totalIncome: dataModel.totalIncome,
                    totalExpense: dataModel.totalExpense,
                    total: dataModel.total
                )
                .listRowInsets(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                .listRowSeparator(.hidden)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .id(dataModel.topScrollDate)
            }

            ForEach(dataModel.sortedDates, id: \.self) { date in
                Section {
                    let transactions = dataModel.items(inSameDateAs: date)?.1 ?? []
                    ForEach(transactions) { transaction in
                        TransactionsListItemView(transaction: transaction) {
                            didTapItem($0)
                        }
                        .font(.body)
                    }
                } header: {
                    Text(date.formatDateMediumWithShortWeekday())
                        .fontWeight(.semibold)
                        .id(date)
                }
                .listRowInsets(EdgeInsets(top: 4, leading: 20, bottom: 0, trailing: 12))
                .listRowSeparator(.visible)
            }
        }
        .listStyle(PlainListStyle())
        .overlay(alignment: .center) {
            if (dataModel.sortedDates.isEmpty) {
                Text("There's nothing here yet.\nCreate a transaction to get started! 😊")
                    .multilineTextAlignment(.center)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding()
            }
        }
    }
}
