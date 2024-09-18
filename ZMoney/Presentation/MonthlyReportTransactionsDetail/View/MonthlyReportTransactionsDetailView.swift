//
//  MonthlyReportTransactionsDetailView.swift
//  ZMoney
//
//  Created by Chien Pham on 18/09/2024.
//

import SwiftUI
import SwiftUICharts
import Combine

struct MonthlyReportTransactionsDetailView: View {
    @EnvironmentObject private var appSettings: AppSettings
    @ObservedObject var viewModel: MonthlyReportTransactionsDetailViewModel

    var body: some View {
        VStack {
            let data = viewModel.chartData
            BarChart(chartData: data)
                .touchOverlay(
                    chartData: data,
                    formatter: appSettings.currencyFormatter
                )
                .averageLine(
                    chartData: data,
                    labelPosition: .none,
                    lineColour: .accentColor,
                    strokeStyle: StrokeStyle(lineWidth: 2, dash: [5, 10]),
                    addToLegends: true
                )
                .yAxisGrid(chartData: data)
                .xAxisLabels(chartData: data)
                .yAxisLabels(
                    chartData: data,
                    formatter: appSettings.currencyFormatterWithoutSymbol,
                    colourIndicator: .custom(colour: ColourStyle(colour: .orange), size: 12)
                )
                .floatingInfoBox(chartData: data)
                .disableAnimation(chartData: data)
                .frame(height: 200, alignment: .center)
                .padding(.horizontal, 12)
                .padding(.top, 20)
                .id(data.id)

            HStack {
                Text("Total")
                    .fontWeight(.medium)
                Spacer()
                MoneyText(value: viewModel.selectedTotalAmount, style: .report)
                    .font(.body.weight(.medium))
            }
            .padding(.horizontal)

            TransactionsListView(
                dataModel: viewModel.selectedTransactionListModel,
                showSummary: false
            ) { item in
                viewModel.didTapItem(item)
            }
        }
        .navigationTitle(viewModel.navigationTitle)
        .resultAlert(alertData: $viewModel.alertData)
        .task {
            await viewModel.refreshData()
        }
    }
}

#Preview {
    MonthlyReportTransactionsDetailView(viewModel: .preview)
}
