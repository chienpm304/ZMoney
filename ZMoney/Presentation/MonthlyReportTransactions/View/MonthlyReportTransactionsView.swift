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
                .frame(height: 200, alignment: .center)
                .padding(.horizontal, 12)
                .padding(.top, 20)
                .id(data.id)

            List {
                Section {
                    HStack {
                        Text("Total")
                            .fontWeight(.medium)
                        Spacer()
                        MoneyText(value: viewModel.model.totalAmount, style: .income)
                            .font(.body.weight(.medium))
                    }

                    HStack {
                        Text("Average")
                            .fontWeight(.medium)
                        Spacer()
                        MoneyText(value: viewModel.model.averageAmount, style: .income)
                            .font(.body.weight(.medium))
                    }
                }

                Section {
                    ForEach(viewModel.model.itemModels) { item in
                        Button {
                            Task {
                                viewModel.didTapItem(item)
                            }
                        } label: {
                            HStack {
                                Text(item.month.monthName(.default).capitalized)
                                    .fontWeight(.medium)
                                Spacer()
                                MoneyText(value: item.amount, style: .report)
                                    .font(.body.weight(.medium))
                            }
                            .if(item.amount > 0) { view in
                                view.withRightArrow()
                            }
                        }
                        .foregroundStyle(Color.primary)
                    }
                }
            }
        }
        .navigationTitle(viewModel.navigationTitle)
        .task {
            await viewModel.refreshData()
        }
    }

    var chartData: BarChartData {
        let dataPoints: [BarChartDataPoint] = viewModel.model.itemModels.map {
            let colorStyle = ColourStyle(colour: .orange)
            return BarChartDataPoint(
                value: Double($0.amount),
                xAxisLabel: $0.month.monthName(.short).capitalized,
                description: nil,
                date: $0.month,
                colour: colorStyle
            )
        }

        let gridStyle = GridStyle(numberOfLines: 6, lineWidth: 1, dash: [])

        let chartStyle = BarChartStyle(
            infoBoxPlacement: .floating,
            infoBoxValueFont: .body,
            infoBoxBackgroundColour: .gray,
            markerType: .full(colour: .red, style: .init()),
            xAxisGridStyle: gridStyle,
            xAxisLabelPosition: .bottom,
            xAxisLabelsFrom: .dataPoint(rotation: .degrees(-45)),
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
}

#Preview {
    MonthlyReportTransactionsView(viewModel: .preview)
}
