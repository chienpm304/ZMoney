//
//  TransactionsListItemView.swift
//  ZMoney
//
//  Created by Chien Pham on 11/09/2024.
//

import SwiftUI

struct TransactionsListItemView: View {
    private let transaction: TransactionsListItemModel
    private var didTapItem: ((TransactionsListItemModel) -> Void)

    init(
        transaction: TransactionsListItemModel,
        didTapItem: @escaping (TransactionsListItemModel) -> Void
    ) {
        self.transaction = transaction
        self.didTapItem = didTapItem
    }

    var body: some View {
        HStack {
            Image(systemName: transaction.categoryIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color(hex: transaction.categoryColor))
                .frame(width: 28, height: 28)
                .padding(4)

            VStack(alignment: .leading) {
                Text(LocalizedStringKey(transaction.categoryName))
                if let memo = transaction.memo, !memo.isEmpty {
                    Text(memo)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            MoneyText(value: transaction.amount, type: transaction.transactionType)
        }
        .font(.body.weight(.medium))
        .withRightArrow()
        .contentShape(Rectangle())
        .onTapGesture {
            didTapItem(transaction)
        }
    }
}
