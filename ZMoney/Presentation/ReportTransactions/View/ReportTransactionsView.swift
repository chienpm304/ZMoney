//
//  ReportTransactionsView.swift
//  ZMoney
//
//  Created by Chien Pham on 14/09/2024.
//

import SwiftUI
import Charts
import DomainModule

struct ReportTransactionsView: View {
    @ObservedObject var viewModel: ReportTransactionsViewModel
    @State private var selectedCategoryTab: DMTransactionType = .expense

    var body: some View {
        VStack {
            DateRangePicker(dateRange: viewModel.dateRange) {
                Task {
                    await viewModel.didTapPreviousDateRange()
                }
            } didTapNextDateRange: {
                Task {
                    await viewModel.didTapNextDateRange()
                }
            }
            .padding(.horizontal, 24)

            // Total Summary
            TransactionsSummaryView(
                totalIncome: viewModel.reportModel.totalIncome,
                totalExpense: viewModel.reportModel.totalExpense,
                total: viewModel.reportModel.total
            )
            .padding()

            HStack {
                Picker("Tab", selection: $viewModel.reportModel.selectedType) {
                    ForEach(CategoryTab.allCases) {
                        Text($0.localizedStringKey)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal, 20)

            List {
            // Donut Chart
            //            DonutChartView(items: viewModel.reportModel.itemsModel)

                Chart {
                    
                }

                ForEach(viewModel.reportModel.itemsModel, id: \.id) { item in
                    Button {
                        viewModel.didTapItem(item)
                    } label: {
                        HStack {
                            Image(systemName: item.category.icon)
                                .foregroundColor(item.category.color)
                                .frame(width: 20, height: 20)

                            Text(item.category.name)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                                .font(.body)

                            Spacer()

                            MoneyText(value: item.amount, type: item.category.type)

                            Text("\(item.percent, specifier: "%.1f")%")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .withRightArrow()
                    }
                }
                .listStyle(GroupedListStyle())
            }
            .navigationTitle("Transaction Report")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.didTapSearchButton()
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
            .resultAlert(alertData: $viewModel.alertData)
            .task {
                await viewModel.refreshData()
            }
        }
    }
}

    // Placeholder for DonutChartView
    //struct DonutChartView: View {
    //    let items: [ReportTransactionItemModel]
    //
    //    var body: some View {
    //        // Example using Charts framework (SwiftUI Charts)
    //        Chart(items, id: \.category.id) { item in
    //            PieSlice(startAngle: .degrees(0), endAngle: .degrees(Double(item.amount) / 100.0 * 360))
    //                .foregroundStyle(by: .value("Category", item.category.name))
    //        }
    //        .frame(height: 200)
    //    }
    //}
