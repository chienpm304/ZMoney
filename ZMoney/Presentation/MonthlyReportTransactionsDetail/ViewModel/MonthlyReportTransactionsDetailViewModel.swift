//
//  MonthlyReportTransactionsDetailViewModel.swift
//  ZMoney
//
//  Created by Chien Pham on 18/09/2024.
//

import Foundation
import SwiftUI
import DomainModule
import Combine

final class MonthlyReportTransactionsDetailViewModel: ObservableObject, AlertProvidable {
    struct Actions {
        let didTapTransaction: (DMTransaction) -> Void
        let didFinishPresentation: () -> Void
    }

    struct Dependencies {
        let actions: Actions
        let getTransactionsByCategoriesUseCaseFactory: () -> FetchTransactionsByCategoriesUseCase
    }

    @Published var reportModel: MonthlyReportTransactionsDetailModel
    @Published var alertData: AlertData?
    private let dependencies: Dependencies

    private let category: DMCategory
    private let fullDateRange: DateRange
    @Published var selectedDateRange: DateRange

    init(
        category: DMCategory,
        fullDateRange: DateRange,
        selectedDateRange: DateRange,
        dependencies: Dependencies
    ) {
        self.dependencies = dependencies
        self.category = category
        self.fullDateRange = fullDateRange
        self.selectedDateRange = selectedDateRange
        self.reportModel = MonthlyReportTransactionsDetailModel(transactions: [])
    }

    var navigationTitle: String {
        let categoryName = category.name.localized
        let monthName = selectedDateRange.startDate.monthName(.short).capitalized
        return "\(categoryName) (\(monthName))"
    }

    var selectedTransactionListModel: TransactionsListModel {
        reportModel.transactionListModel(for: selectedDateRange)
    }

    var selectedTotalAmount: MoneyValue {
        switch category.type {
        case .expense:
            selectedTransactionListModel.totalExpense
        case .income:
            selectedTransactionListModel.totalIncome
        }
    }

    @MainActor func refreshData() async {
        do {
            let input = FetchTransactionsByCategoriesUseCase.Input(
                startTime: fullDateRange.startDate.timeValue,
                endTime: fullDateRange.endDate.timeValue,
                category: category
            )

            let transactions = try await dependencies.getTransactionsByCategoriesUseCaseFactory()
                .execute(input: input)
            self.reportModel = MonthlyReportTransactionsDetailModel(transactions: transactions)
            self.setupChartData()
        } catch {
            showErrorAlert(with: error as? DMError ?? .unknown(error))
        }
    }

    @MainActor func didTapItem(_ item: TransactionsListItemModel) {
        guard let transaction = reportModel.getTransaction(by: item.id) else { return }
        dependencies.actions.didTapTransaction(transaction)
    }

    // MARK: Chart

    var chartData = BarChartData(dataSets: .init(dataPoints: []))
    private var cancellables = Set<AnyCancellable>()

    private func setupChartData() {
        chartData = makeChartData()
        chartData.touchedDataPointPublisher
            .removeDuplicates { $0.date == $1.date }
            .sink { [weak self] dataPoint in
                guard let self else { return }
                if let date = dataPoint.date {
                    self.selectedDateRange = DateRange(
                        startDate: date.dateAtStartOf(.month),
                        endDate: date.dateAtEndOf(.month)
                    )
                    self.chartData.dataSets = self.makeChartDataSet()
                }
            }
            .store(in: &cancellables)
    }

    private func makeChartData() -> BarChartData {
        let gridStyle = GridStyle(numberOfLines: 6, lineWidth: 1, dash: [])
        let dataSets = makeChartDataSet()
        let numberOfColums = dataSets.dataPoints.count

        let chartStyle = BarChartStyle(
            infoBoxPlacement: .floating,
            infoBoxValueFont: .body,
            infoBoxBackgroundColour: .gray,
            markerType: .full(colour: .red, style: .init()),
            xAxisGridStyle: gridStyle,
            xAxisLabelPosition: .bottom,
            xAxisLabelsFrom: .dataPoint(rotation: .degrees(numberOfColums > 5 ? -45 : 0)),
            yAxisGridStyle: gridStyle,
            yAxisLabelPosition: .leading,
            yAxisNumberOfLabels: 6,
            baseline: .zero,
            topLine: .maximumValue
        )

        let barStyle = BarStyle(
            barWidth: 0.5,
            cornerRadius: CornerRadius(top: 0, bottom: 0),
            colourFrom: .dataPoints,
            colour: ColourStyle(colour: .blue)
        )

        let barChartData = BarChartData(
            dataSets: dataSets,
            barStyle: barStyle,
            chartStyle: chartStyle
        )
        return barChartData
    }

    private func makeChartDataSet() -> BarDataSet {
        let dataPoints: [BarChartDataPoint] = reportModel.monthlyReportItems.map {
            let colorStyle: ColourStyle
            if selectedDateRange.contains(date: $0.month.dateByAdding(1, .day).date) {
                colorStyle = ColourStyle(colour: .orange)
            } else {
                colorStyle = ColourStyle(colour: .orange.opacity(0.5))
            }

            return BarChartDataPoint(
                value: Double($0.amount),
                xAxisLabel: $0.month.monthName(.short).capitalized,
                description: nil,
                date: $0.month,
                colour: colorStyle
            )
        }
        return .init(dataPoints: dataPoints)
    }
}

// MARK: Preview

import DataModule
import SwiftUICharts

extension MonthlyReportTransactionsDetailViewModel {
    static let preview: MonthlyReportTransactionsDetailViewModel = {
        .init(
            category: .preview(type: .expense),
            fullDateRange: .init(
                startDate: .now.dateAtStartOf(.year),
                endDate: .now.dateAtEndOf(.year)
            ),
            selectedDateRange: .init(
                startDate: .now.dateAtStartOf(.month),
                endDate: .now.dateAtEndOf(.month)
            ),
            dependencies: .init(
                actions: .init(didTapTransaction: {
                    print("didTapTransaction: \($0)")
                }, didFinishPresentation: {
                    print("didFinishPresentation")
                }),
                getTransactionsByCategoriesUseCaseFactory: {
                    .init(
                        transactionRepository: DefaultTransactionRepository(
                            storage: TransactionCoreDataStorage(coreData: .testInstance)
                        )
                    )
                }
            )
        )
    }()
}
