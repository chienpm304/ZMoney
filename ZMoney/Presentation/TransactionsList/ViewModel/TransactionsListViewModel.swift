//
//  TransactionsListViewModel.swift
//  ZMoney
//
//  Created by Chien Pham on 29/08/2024.
//

import Foundation
import DomainModule
import Combine
import SwiftDate

struct TransactionsListViewModelActions {
    let createTransaction: (Date) -> Void
    let editTransaction: (DMTransaction) -> Void
    let searchTransactions: () -> Void
}

final class TransactionsListViewModel: ObservableObject, AlertProvidable {
    struct Dependencies {
        let fetchTransactionByTimeUseCaseFactory: FetchTransactionsByTimeUseCaseFactory
        let actions: TransactionsListViewModelActions
    }

    // MARK: Dependencies
    private let dependencies: Dependencies
    let dateRangeType: DateRangeType

    // MARK: Output
    @Published private(set) var dataModel: TransactionsListModel
    @Published private(set) var dateRange: DateRange
    @Published private(set) var selectedDate: Date
    @Published private(set) var scrollToDate: Date?
    @Published var alertData: AlertData?

    init(
        dateRangeType: DateRangeType = .month,
        dependencies: Dependencies
    ) {
        self.dependencies = dependencies
        self.dateRangeType = dateRangeType
        self.dataModel = TransactionsListModel(transactions: [])
        self.dateRange = dateRangeType.dateRange(of: .now)
        self.selectedDate = .now
    }

    private func setupDataModel(with transactions: [DMTransaction]) {
        dataModel = TransactionsListModel(transactions: transactions)
        scrollToDate = dataModel.topScrollDate
    }

    // MARK: Public

    var topScrollDate: Date? { dataModel.topScrollDate }

    func totalExpense(in date: Date) -> MoneyValue { dataModel.totalExpense(in: date) }

    func totalIncome(in date: Date) -> MoneyValue { dataModel.totalIncome(in: date) }

    var totalExpense: MoneyValue { dataModel.totalExpense }

    var totalIncome: MoneyValue { dataModel.totalIncome }

    var total: MoneyValue { dataModel.total }

    var sortedDates: [Date] { dataModel.sortedDates }

    func items(inSameDateAs date: Date) -> [TransactionsListItemModel]? {
        dataModel.items(inSameDateAs: date)?.1
    }
}

// MARK: Input
extension TransactionsListViewModel {
    func didTapDate(_ date: Date, tapCount: Int) {
        if tapCount == 1 {
            selectedDate = date
            guard let section = dataModel.items(inSameDateAs: date)
            else { return }
            scrollToDate = section.0
            print(section.1.map { $0.memo })
        } else if tapCount == 2 {
            dependencies.actions.createTransaction(date)
        }
    }

    func didTapTransactionItem(_ item: TransactionsListItemModel) {
        guard let selectedTransaction = dataModel.transaction(by: item.id) else {
            assertionFailure()
            return
        }
        dependencies.actions.editTransaction(selectedTransaction)
    }

    func didTapNextDateRange() {
        dateRange = dateRangeType.next(of: dateRange)
        Task { @MainActor in
            await refreshData()
        }
    }

    func didTapPreviousDateRange() {
        dateRange = dateRangeType.previous(of: dateRange)
        Task { @MainActor in
            await refreshData()
        }
    }

    func didSelectDateRange(_ dateRange: DateRange) {
        self.dateRange = dateRange
        Task { @MainActor in
            await refreshData()
        }
    }

    func didTapSearchButton() {
        dependencies.actions.searchTransactions()
    }

    @MainActor func refreshData() async {
        do {
            let input = FetchTransactionsByTimeUseCase.Input(
                startTime: dateRange.startDate.timeValue,
                endTime: dateRange.endDate.timeValue
            )
            let fetchUseCase = dependencies.fetchTransactionByTimeUseCaseFactory()
            let transactions = try await fetchUseCase.execute(input: input)
            self.setupDataModel(with: transactions)
        } catch {
            showErrorAlert(with: error as? DMError ?? .unknown(error))
        }
    }
}

// MARK: Previews

import DataModule

extension TransactionsListViewModel {
    static func makePreviewViewModel() -> TransactionsListViewModel {
        let repository: TransactionRepository = DefaultTransactionRepository(
            storage: TransactionCoreDataStorage(coreData: .testInstance)
        )

        let actions = TransactionsListViewModelActions { date in
            print("[Preview] Create new transaction at: \(date)")
        } editTransaction: { transaction in
            print("[Preview] Edit transaction: \(transaction.amount)")
        } searchTransactions: {
            print("[Preview] Search transactions ...")
        }
        let dependencies = Dependencies(
            fetchTransactionByTimeUseCaseFactory: {
                FetchTransactionsByTimeUseCase(transactionRepository: repository)
            },
            actions: actions
        )
        return TransactionsListViewModel(dependencies: dependencies)
    }
}
