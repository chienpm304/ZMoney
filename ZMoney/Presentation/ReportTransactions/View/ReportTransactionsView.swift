//
//  ReportTransactionsView.swift
//  ZMoney
//
//  Created by Chien Pham on 14/09/2024.
//

import SwiftUI
import SwiftUICharts
import DomainModule

struct ReportTransactionsView: View {
    @EnvironmentObject private var appSettings: AppSettings
    @ObservedObject var viewModel: ReportTransactionsViewModel
    @State private var selectedCategoryTab: DMTransactionType = .expense

    var body: some View {
        VStack {
            HStack {
                Picker("", selection: $viewModel.dateRangeType) {
                    ForEach(DateRangeType.allCases) {
                        Text($0.localizedStringKey)
                    }
                }
                .pickerStyle(.menu)
                .padding(.trailing, 12)

                DateRangePicker(dateRange: viewModel.dateRange, type: viewModel.dateRangeType) {
                    Task {
                        await viewModel.didTapPreviousDateRange()
                    }
                } didTapNextDateRange: {
                    Task {
                        await viewModel.didTapNextDateRange()
                    }
                }
            }
            .padding(.horizontal, 12)

            Picker("", selection: $viewModel.selectedType) {
                ForEach(CategoryTab.allCases) {
                    Text($0.localizedStringKey)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)

            TransactionsSummaryView(
                totalIncome: viewModel.totalIncome,
                totalExpense: viewModel.totalExpense,
                total: viewModel.total
            )
            .padding(.horizontal)

            List {
                Section {
                    let data = chartData
                    DoughnutChart(chartData: data)
                        .touchOverlay(
                            chartData: data,
                            formatter: appSettings.currencyFormatter,
                            minDistance: 5
                        )
                        .headerBox(chartData: data)
                        .frame(height: 164, alignment: .center)
                        .id(data.id)
                        .padding(.top, 20)
                        .padding(.bottom, 40)
                }
                .listRowInsets(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                .listRowSeparator(.hidden)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                ForEach(viewModel.itemsModel, id: \.id) { item in
                    Button {
                        viewModel.didTapItem(item)
                    } label: {
                        HStack {
                            Image(systemName: item.category.icon)
                                .foregroundColor(item.category.color)
                                .frame(width: 20, height: 20)

                            Text(item.category.localizedName)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                                .font(.body)
                                .lineLimit(1)

                            Spacer()

                            MoneyText(value: item.amount, type: item.category.type)

                            Text("\(item.percent, specifier: "%.1f")%")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .withRightArrow()
                    }
                }
            }
            .listStyle(PlainListStyle())
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

    private var chartData: DoughnutChartData {
        let dataPoints: [PieChartDataPoint] = viewModel.itemsModel.map {
            let name = $0.category.localizedName
            let displayName = name.count > 14 ? "\(name.prefix(14))..." : name
            let description = displayName + " - " + String(format: "%.1f%%", $0.percent)

            let overlapType = OverlayType.icon(
                systemName: $0.category.icon,
                colour: $0.category.color,
                size: 24,
                rFactor: 1.5
            )

            return PieChartDataPoint(
                value: Double($0.amount),
                description: description,
                date: nil,
                colour: $0.category.color,
                label: overlapType
            )
        }

        let metadata = ChartMetadata(
            titleFont: .body,
            titleColour: .primary,
            subtitleFont: .caption,
            subtitleColour: .secondary
        )

        let chartStyle = DoughnutChartStyle(
            infoBoxPlacement: .header,
            infoBoxContentAlignment: .vertical,
            infoBoxValueFont: .callout,
            infoBoxValueColour: .primary,
            infoBoxDescriptionFont: .caption,
            infoBoxDescriptionColour: .primary,
            infoBoxBackgroundColour: .systemBackground,
            infoBoxBorderColour: .clear,
            globalAnimation: Animation.linear(duration: 0.75),
            strokeWidth: 40
        )

        return DoughnutChartData(
            dataSets: .init(dataPoints: dataPoints, legendTitle: ""),
            metadata: metadata,
            chartStyle: chartStyle,
            noDataText: Text("N/A")
        )
    }
}
