//
//  TransCategoryDetailView.swift
//  ZMoney
//
//  Created by Chien Pham on 23/08/2024.
//

import SwiftUI

struct TransCategoryDetailView: View {
    private let viewModel: TransCategoryDetailModel
    init(category: TransCategoryDetailModel) {
        self.viewModel = category
    }

    var body: some View {
        VStack {
            Text(viewModel.type == .expense ? "Expense" : "Income")
            Text(viewModel.name)
            Image(systemName: viewModel.icon)
                .foregroundColor(Color(hex: viewModel.iconColor))
            Text("sort index: \(viewModel.sortIndex)")
        }
    }
}

#Preview {
    VStack {
        TransCategoryDetailView(
            category: .init(
                category: .init(
                    id: 1,
                    name: "Education",
                    icon: "ball",
                    color: "ffffff",
                    sortIndex: 1,
                    type: .expense
                )
            )
        )
        Text("-------")
        TransCategoryDetailView(
            category: .init(
                category: .init(
                    type: .expense, sortIndex: 0
                )
            )
        )
    }
}
