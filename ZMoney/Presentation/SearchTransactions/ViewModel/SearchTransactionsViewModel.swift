//
//  SearchTransactionsViewModel.swift
//  ZMoney
//
//  Created by Chien Pham on 12/09/2024.
//

import Foundation
import SwiftUI
import DomainModule

struct SearchTransactionsViewModelActions {
    let editTransaction: (DMTransaction) -> Void
}

final class SearchTransactionsViewModel: ObservableObject, AlertProvidable {
    private var transactions: [DMTransaction] = []

    @MainActor @Published var searchModel: TransactionsListModel = .init(transactions: [])
    @Published var searchKeyword: String = ""
    @Published private(set) var isLoading: Bool = false
    @Published var alertData: AlertData?

    struct Dependencies {
        let searchTransactionsUseCaseFactory: SearchTransactionsUseCaseFactory
        let actions: SearchTransactionsViewModelActions
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    @MainActor func searchTransactions() async {
        isLoading = true
        do {
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds debounce
            let input = SearchTransactionsUseCase.Input(keyword: searchKeyword)
            let results = try await dependencies.searchTransactionsUseCaseFactory().execute(input: input)
            transactions = results
            searchModel = .init(transactions: results)
        } catch {
            showErrorAlert(with: error as? DMError ?? .unknown(error))
        }
        isLoading = false
    }

    @MainActor func clearSearchKeyword() {
        searchKeyword = ""
        isLoading = false
        transactions = []
        searchModel = .init(transactions: [])
    }

    func didTapTransactionItem(_ item: TransactionsListItemModel) {
        guard let selectedTransaction = transactions.first(where: { $0.id == item.id })
        else {
            assertionFailure()
            return
        }
        dependencies.actions.editTransaction(selectedTransaction)
    }

    func refreshData() {
        Task {
            await searchTransactions()
        }
    }
}

// MARK: Preview

import DataModule

extension SearchTransactionsViewModel {
    static var preview: SearchTransactionsViewModel {
        let repository: TransactionRepository = DefaultTransactionRepository(
            storage: TransactionCoreDataStorage(coreData: .testInstance)
        )
        return .init(dependencies: .init(searchTransactionsUseCaseFactory: {
            SearchTransactionsUseCase(repository: repository)
        }, actions: SearchTransactionsViewModelActions(editTransaction: {
            print("Did tap transaciton: \($0)")
        })))
    }
}
