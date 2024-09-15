//
//  ReportTransactionsViewModel.swift
//  ZMoney
//
//  Created by Chien Pham on 14/09/2024.
//

import Foundation
import DomainModule
import Combine

struct ReportTransactionsViewModelActions {
    let didTapReportItem: (DMCategory, DateRange, DateRangeType) -> Void
    let didTapSearch: () -> Void
}

final class ReportTransactionsViewModel: ObservableObject, AlertProvidable {
    struct Dependencies {
        let fetchTransactionsByTimeUseCaseFactory: () -> FetchTransactionsByTimeAsyncUseCase
        let actions: ReportTransactionsViewModelActions
    }

    private let dependencies: Dependencies
    @Published var dateRangeType: DateRangeType {
        didSet {
            self.dateRange = dateRangeType.dateRange(of: .now)
            Task {
                await refreshData()
            }
        }
    }
    @MainActor @Published var reportModel = ReportTransactionsModel(transactions: [], selectedType: .expense)
    @Published private(set) var dateRange: DateRange
    @Published var alertData: AlertData?

    init(
        dateRangeType: DateRangeType = .month,
        dependencies: Dependencies
    ) {
        self.dependencies = dependencies
        self.dateRangeType = dateRangeType
        self.dateRange = dateRangeType.dateRange(of: .now)
    }

    @MainActor func refreshData() async {
        do {
            let input = FetchTransactionsByTimeAsyncUseCase.Input(
                startTime: dateRange.startDate.timeValue,
                endTime: dateRange.endDate.timeValue
            )
            let transactions = try await dependencies.fetchTransactionsByTimeUseCaseFactory()
                .execute(input: input)
            reportModel = ReportTransactionsModel(
                transactions: transactions,
                selectedType: reportModel.selectedType
            )
        } catch {
            showErrorAlert(with: error as? DMError ?? .unknown(error))
        }
    }

    func didTapItem(_ item: ReportTransactionItemModel) {
        dependencies.actions.didTapReportItem(item.category.domain, dateRange, dateRangeType)
    }

    func didTapSearchButton() {
        dependencies.actions.didTapSearch()
    }

    @MainActor func didTapNextDateRange() async {
        dateRange = dateRangeType.next(of: dateRange)
        await refreshData()
    }

    @MainActor func didTapPreviousDateRange() async {
        dateRange = dateRangeType.previous(of: dateRange)
        await refreshData()
    }
}
