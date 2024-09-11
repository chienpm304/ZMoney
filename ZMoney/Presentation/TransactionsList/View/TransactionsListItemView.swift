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
            didTapItem(transaction)
        }
    }
}
