//
//  TransactionsListViewModel.swift
//  ZMoney
//
//  Created by Chien Pham on 29/08/2024.
//

import Foundation
import DomainModule
import Combine

struct TransactionsListViewModelActions {
    let createTransaction: (Date) -> Void
    let editTransaction: (DMTransaction) -> Void
}

final class TransactionsListViewModel: ObservableObject {
    struct Dependencies {
        let useCaseFactory: TransactionsUseCaseFactory
        let actions: TransactionsListViewModelActions
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}
