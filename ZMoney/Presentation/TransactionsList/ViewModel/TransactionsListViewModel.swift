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

    // MARK: Domain
    private var transactions: [DMTransaction] = [] {
        didSet {
            let items = transactions.map(TransactionsListItemModel.init)
            itemsMap = Dictionary(grouping: items, by: { $0.inputDate.dateAtStartOf(.day).date })
            scrollToDate = topScrollDate
        }
    }

    var topScrollDate: Date? {
        itemsMap.keys.sorted().first?.dateByAdding(-1, .day).date
    }

    // MARK: Dependencies
    private let dependencies: Dependencies
    private var fetchUseCase: UseCase?
    private let dateRangeType: DateRangeType

    // MARK: Output
    @Published var itemsMap: [Date: [TransactionsListItemModel]] = [:]
    @Published var dateRange: DateRange
    @Published var selectedDate: Date
    @Published var scrollToDate: Date?
    var startDate: Date { dateRange.startDate }
    var endDate: Date { dateRange.endDate }

    init(
        dateRangeType: DateRangeType = .month,
        dependencies: Dependencies
    ) {
        self.dependencies = dependencies
        self.dateRangeType = dateRangeType
        self.dateRange = dateRangeType.dateRange(of: .now)
        self.selectedDate = .now
    }

    // TODO: move to usecase
    func totalExpense(in date: Date) -> MoneyValue {
        totalAmount(of: .expense, in: date)
    }

    func totalIncome(in date: Date) -> MoneyValue {
        totalAmount(of: .income, in: date)
    }

    var totalExpense: MoneyValue {
        totalAmount(of: .expense)
    }

    var totalIncome: MoneyValue {
        totalAmount(of: .income)
    }

    var total: MoneyValue {
        totalIncome - totalExpense
    }

    private func totalAmount(of type: DMTransactionType, in date: Date) -> MoneyValue {
        transactions
            .filter {
                Calendar.current.isDate($0.inputTime.dateValue, inSameDayAs: date)
            }
            .filter { $0.category.type == type }
            .map { $0.amount }
            .reduce(0, +)
    }

    private func totalAmount(of type: DMTransactionType) -> MoneyValue {
        transactions
            .filter { $0.category.type == type }
            .map { $0.amount }
            .reduce(0, +)
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
            print("should scroll to section: \(date)")
            guard let section = itemsMap.keys.first(where: { Calendar.current.isDate($0, inSameDayAs: date) })
            else { return }
            scrollToDate = section
            print(itemsMap[section, default: []].map {$0.memo})
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
                    self.transactions = transactions
                    // TODO: remove test
                    self.transactions = (0...50).map({
                        let date = DateInRegion.randomDate(
                            between: self.startDate.inDefaultRegion(),
                            and: self.endDate.inDefaultRegion()
                        ).date
                        let categories = DMCategory.defaultIncomeCategories
                        + DMCategory.defaultExpenseCategories
                        return .init(
                            inputTime: date.timeValue,
                            amount: MoneyValue.random(in: 1...100) * 10_000_00,
                            memo: "Note \($0)",
                            category: categories[Int.random(in: 0...10)]
                        )
                    })
                    // end test
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
