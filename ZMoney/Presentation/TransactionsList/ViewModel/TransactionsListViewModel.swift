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
import Collections

struct TransactionsListViewModelActions {
    let createTransaction: (Date) -> Void
    let editTransaction: (DMTransaction) -> Void
}

final class TransactionsListViewModel: ObservableObject {
    struct Dependencies {
        let useCaseFactory: TransactionsUseCaseFactory
        let actions: TransactionsListViewModelActions
    }

    // MARK: Domain
    private var transactions: [DMTransaction] = [] {
        didSet {
            let items = transactions.map(TransactionsListItemModel.init)
            itemsMap = OrderedDictionary(grouping: items, by: { $0.inputDate })
        }
    }

    // MARK: Dependencies
    private let dependencies: Dependencies
    private var fetchUseCase: UseCase?
    private let dateRangeType: DateRangeType

    // MARK: Output
    @Published var itemsMap: OrderedDictionary<Date, [TransactionsListItemModel]> = [:]
    @Published var dateRange: DateRange
    var startDate: Date { dateRange.startDate }
    var endDate: Date { dateRange.endDate }

    init(
        dateRangeType: DateRangeType = .month,
        dependencies: Dependencies
    ) {
        self.dependencies = dependencies
        self.dateRangeType = dateRangeType
        self.dateRange = dateRangeType.dateRange(of: .now)
    }
}

// MARK: Input
extension TransactionsListViewModel {
    func onViewAppear() {
        fetchTransactions()
    }

    func didTapDate(_ date: Date, tapCount: Int) {
        if tapCount == 1 {
            // TODO: set scroll offset to selected date
            print("should scroll to section: \(date)")
        } else if tapCount == 2 {
            dependencies.actions.createTransaction(date)
        }
    }

    func didTapTransactionItem(_ item: TransactionsListItemModel) {
        guard let selectedTransaction = transactions.first(where: { $0.id == item.id }) else {
            assertionFailure()
            return
        }
        dependencies.actions.editTransaction(selectedTransaction)
    }

    func didTapNextDateRange() {

    }

    func didTapPreviousDateRange() {

    }

    func didSelectDateRange(_ dateRange: DateRange) {
        self.dateRange = dateRange
    }

    private func fetchTransactions() {
        let request = FetchTransactionsByTimeUseCase.RequestValue(
            startTime: dateRange.startDate.timeValue,
            endTime: dateRange.endDate.timeValue
        )
        let completion: (FetchTransactionsByTimeUseCase.ResultValue) -> Void = { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let transactions):
//                    self.transactions = transactions
                    // TODO: remove test
                    self.transactions = (0...50).map({
                        .init(
                            inputTime: (Date().dateAt(.startOfMonth) + Int.random(in: 1...29).days).timeValue,
                            amount: MoneyValue.random(in: 1...10) * 10000,
                            memo: "Note \($0)",
                            category: .defaultExpenseCategories[Int.random(in: 0...4)]
                        )
                    })
                    // end test
                case .failure(let error):
                    print("failed to fetch transactions: \(error)")
                }
            }
        }
        let fetchUseCase = dependencies.useCaseFactory.fetchByTimeUseCase(
            request,
            completion
        )
        fetchUseCase.execute()
        self.fetchUseCase = fetchUseCase
    }
}
