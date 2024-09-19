//
//  MonthlyReportTransactionsViewModel.swift
//  ZMoney
//
//  Created by Chien Pham on 16/09/2024.
//

import Foundation
import DomainModule

struct MonthlyReportTransactionsViewModelActions {
    let didTapMonthlyReportItem: (DMCategory, TimeValue /* start of month*/) -> Void
}

final class MonthlyReportTransactionsViewModel: ObservableObject, AlertProvidable {
    struct Dependencies {
        let getMonthlyTransactionsReportUseCaseFactory: () -> GetMonthlyTransactionsReportByCategoryUseCase
        let actions: MonthlyReportTransactionsViewModelActions
    }

    @Published var alertData: AlertData?
    @MainActor @Published var model = MonthlyReportTransactionsModel(
        timeRange: DateRange(
            startDate: Date.now.dateAtStartOf(.year),
            endDate: Date.now.dateAtEndOf(.year)
        ),
        reportData: []
    )

    private let category: DMCategory
    private let dateRange: DateRange
    private let dependencies: Dependencies

    init(
        category: DMCategory,
        dateRange: DateRange,
        dependencies: Dependencies
    ) {
        self.category = category
        self.dateRange = dateRange
        self.dependencies = dependencies
    }

    var navigationTitle: String {
        "\(category.name) (\(dateRange.startDate.toFormat("yyyy")))"
    }

    @MainActor func refreshData() async {
        do {
            let input = GetMonthlyTransactionsReportByCategoryUseCase.Input(
                category: category,
                timeRange: dateRange.domain
            )
            let reportData = try await dependencies.getMonthlyTransactionsReportUseCaseFactory()
                .execute(input: input)
            model = MonthlyReportTransactionsModel(
                timeRange: dateRange,
                reportData: reportData
            )
        } catch {
            showErrorAlert(with: error as? DMError ?? .unknown(error))
        }
    }

    @MainActor func didTapItem(_ item: MonthlyReportTransactionsItemModel) {
        guard item.amount > 0 else { return }
        dependencies.actions.didTapMonthlyReportItem(category, item.month.timeValue)
    }
}

// MARK: Preview

import DataModule

extension MonthlyReportTransactionsViewModel {
    static var preview: MonthlyReportTransactionsViewModel = {
        .init(
            category: .preview(type: .income),
            dateRange: .init(startDate: .now.dateAtStartOf(.year), endDate: .now.dateAtEndOf(.year)),
            dependencies: .init(
                getMonthlyTransactionsReportUseCaseFactory: {
                    GetMonthlyTransactionsReportByCategoryUseCase(
                        fetchTransactionsByCategoryUseCase: .init(
                            transactionRepository: DefaultTransactionRepository(
                                storage: TransactionCoreDataStorage(coreData: .testInstance)
                            )
                        )
                    )
                },
                actions: .init(didTapMonthlyReportItem: { category, timeValue in
                    print("didTapMonthlyReportItem: \(category), timeValue: \(timeValue)")
                })
            )
        )
    }()
}
