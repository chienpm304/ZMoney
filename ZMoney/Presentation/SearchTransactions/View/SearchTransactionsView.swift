//
//  SearchTransactionsView.swift
//  ZMoney
//
//  Created by Chien Pham on 12/09/2024.
//

import SwiftUI

struct SearchTransactionsView: View {
    @StateObject var viewModel: SearchTransactionsViewModel

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.secondary)
                TextField("Search ...", text: $viewModel.searchKeyword)
                Spacer()
                if !viewModel.searchKeyword.isEmpty {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.secondary)
                        .onTapGesture {
                            viewModel.clearSearchKeyword()
                        }
                }
            }
            .padding(6)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 0.5)
                    .foregroundColor(Color.secondary)
            )
            .padding(10)
            .onChange(of: viewModel.searchKeyword) { _ in
                Task {
                    await viewModel.searchTransactions()
                }
            }

            Divider()

            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
            } else {
                TransactionsListView(dataModel: viewModel.searchModel) {
                    viewModel.didTapTransactionItem($0)
                }
            }
            Spacer()
        }
        .navigationTitle("Search Transactions")
        .resultAlert(alertData: $viewModel.alertData)
    }
}

#Preview {
    NavigationView {
        SearchTransactionsView(viewModel: .preview)
    }
}
