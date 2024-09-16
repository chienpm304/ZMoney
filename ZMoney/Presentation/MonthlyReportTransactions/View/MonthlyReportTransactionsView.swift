//
//  MonthlyReportTransactionsView.swift
//  ZMoney
//
//  Created by Chien Pham on 16/09/2024.
//

import SwiftUI

struct MonthlyReportTransactionsView: View {
    @EnvironmentObject private var appSettings: AppSettings
    @ObservedObject var viewModel: MonthlyReportTransactionsViewModel

    var body: some View {
        List {
            Section {
                HStack {
                    Text("Total")
                    Spacer()
                    MoneyText(value: viewModel.model.totalAmount, style: .report)
                }

                HStack {
                    Text("Average")
                    Spacer()
                    MoneyText(value: viewModel.model.averageAmount, style: .report)
                }
            }

            Section {
                ForEach(viewModel.model.itemModels) { item in
                    HStack {
                        Text(item.month.monthName(.default))
                        Spacer()
                        if item.amount > 0 {
                            MoneyText(value: item.amount, style: .report)
                        } else {
                            MoneyText(value: item.amount, style: .report)
                                .withRightArrow()
                        }
                    }
                    .onTapGesture {
                        Task {
                            viewModel.didTapItem(item)
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.navigationTitle)
        .task {
            await viewModel.refreshData()
        }
    }
}

//#Preview {
//    MonthlyReportTransactionsView()
//}
