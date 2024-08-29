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
        Text("Transaction list here")
    }
}

// #Preview {
//     TransactionsListView(viewModel: <#TransactionsListViewModel#>)
// }
