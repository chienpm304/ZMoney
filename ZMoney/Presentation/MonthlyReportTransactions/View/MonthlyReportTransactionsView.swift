//
//  MonthlyReportTransactionsView.swift
//  ZMoney
//
//  Created by Chien Pham on 16/09/2024.
//

import SwiftUI
import SwiftUICharts

struct MonthlyReportTransactionsView: View {
    @EnvironmentObject private var appSettings: AppSettings
    @ObservedObject var viewModel: MonthlyReportTransactionsViewModel
    var chartData: BarChartData {
        let dataPoints: [BarChartDataPoint] = viewModel.model.itemModels.map {
            let colorStyle = ColourStyle(colour: .orange)
            return BarChartDataPoint(
                value: Double($0.amount),
                xAxisLabel: $0.month.monthName(.short),
                description: nil,
                date: $0.month,
                colour: colorStyle
            )
        }

        let gridStyle = GridStyle(
            numberOfLines: 6,
            lineWidth: 0.5,
            dash: []
        )

        let chartStyle = BarChartStyle(
            infoBoxPlacement: .floating,
            infoBoxValueFont: .body,
            infoBoxBackgroundColour: .gray,
            markerType: .full(colour: .red, style: .init()),
            xAxisGridStyle: gridStyle,
            xAxisLabelPosition: .bottom,
            xAxisLabelsFrom: .dataPoint(rotation: .degrees(-90)),
            yAxisGridStyle: gridStyle,
            yAxisLabelPosition: .leading,
            yAxisNumberOfLabels: 6,
            baseline: .zero,
            topLine: .maximumValue
        )

        let dataSets = BarDataSet(dataPoints: dataPoints)

        let barStyle = BarStyle(
            barWidth: 0.5,
            cornerRadius: CornerRadius(top: 50, bottom: 0),
            colourFrom: .dataPoints,
            colour: ColourStyle(colour: .blue)
        )

        return BarChartData(
            dataSets: dataSets,
            barStyle: barStyle,
            chartStyle: chartStyle
        )
    }

    var body: some View {
        VStack {
            let data = chartData
            BarChart(chartData: data)
                .touchOverlay(
                    chartData: data,
                    formatter: appSettings.currencyFormatter
                )
                .averageLine(
                    chartData: data,
                    labelPosition: .none,
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
                .frame(height: 200, alignment: .center)
                .padding(.horizontal, 12)
                .padding(.top, 20)
                .id(data.id)
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
                            }
                        }
//                        .withRightArrow()
                        
                        .onTapGesture {
                            Task {
                                viewModel.didTapItem(item)
                            }
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
