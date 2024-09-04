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
}

final class TransactionsListViewModel: ObservableObject {
    struct Dependencies {
        let useCaseFactory: TransactionsUseCaseFactory
        let actions: TransactionsListViewModelActions
    }

    // MARK: Dependencies
    private let dependencies: Dependencies
    private var fetchUseCase: UseCase?
    private let dateRangeType: DateRangeType

    // MARK: Output
    @Published private var dataModel: TransactionsListDataModel
    @Published var dateRange: DateRange
    @Published var selectedDate: Date
    @Published var scrollToDate: Date?

    init(
        dateRangeType: DateRangeType = .month,
        dependencies: Dependencies
    ) {
        self.dependencies = dependencies
        self.dateRangeType = dateRangeType
        self.dataModel = TransactionsListDataModel(transactions: [])
        self.dateRange = dateRangeType.dateRange(of: .now)
        self.selectedDate = .now
    }

    private func setupDataModel(with transactions: [DMTransaction]) {
        dataModel = TransactionsListDataModel(transactions: transactions)
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
    func onViewAppear() {
        refreshTransactions()
    }

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
        refreshTransactions()
    }

    func didTapPreviousDateRange() {
        dateRange = dateRangeType.previous(of: dateRange)
        refreshTransactions()
    }

    func didSelectDateRange(_ dateRange: DateRange) {
        self.dateRange = dateRange
        refreshTransactions()
    }

    private func refreshTransactions() {
        let request = FetchTransactionsByTimeUseCase.RequestValue(
            startTime: dateRange.startDate.timeValue,
            endTime: dateRange.endDate.timeValue
        )
        let completion: (FetchTransactionsByTimeUseCase.ResultValue) -> Void = { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let transactions):
                    self.setupDataModel(with: transactions)
                case .failure(let error):
                    print("failed to fetch transactions: \(error)")
                }
            }
        }
        let fetchUseCase = dependencies.useCaseFactory.fetchByTimeUseCase(request, completion)
        fetchUseCase.execute()
        self.fetchUseCase = fetchUseCase
    }
}

// MARK: Previews

#if targetEnvironment(simulator)

import DataModule

extension TransactionsListViewModel {
    static func makePreviewViewModel() -> TransactionsListViewModel {
        let repository: TransactionRepository = DefaultTransactionRepository(
            storage: TransactionCoreDataStorage(coreData: .testInstance)
        )

        let factory = TransactionsUseCaseFactory { fetchRequest, fetchCompletion in
            FetchTransactionByIDUseCase(
                requestValue: fetchRequest,
                transactionRepository: repository,
                completion: fetchCompletion
            )
        } fetchByTimeUseCase: { fetchRequest, fetchCompletion in
            FetchTransactionsByTimeUseCase(
                requestValue: fetchRequest,
                transactionRepository: repository,
                completion: fetchCompletion
            )
        } addUseCase: { addRequest, addCompletion in
            AddTransactionsUseCase(
                requestValue: addRequest,
                transactionRepository: repository,
                completion: addCompletion
            )
        } updateUseCase: { updateRequest, updateCompletion in
            UpdateTransactionsUseCase(
                requestValue: updateRequest,
                transactionRepository: repository,
                completion: updateCompletion
            )
        } deleteUseCase: { deleteRequest, deleteCompletion in
            DeleteTransactionsByIDsUseCase(
                requestValue: deleteRequest,
                transactionRepository: repository,
                completion: deleteCompletion
            )
        }

        let actions = TransactionsListViewModelActions { date in
            print("[Preview] Create new transaction at: \(date)")
        } editTransaction: { transaction in
            print("[Preview] Edit transaction: \(transaction.amount)")
        }
        let dependencies = Dependencies(useCaseFactory: factory, actions: actions)
        return TransactionsListViewModel(dependencies: dependencies)
    }
}

#endif
