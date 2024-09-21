//
//  TransactionsUseCaseFactory.swift
//  DomainModule
//
//  Created by Chien Pham on 27/08/2024.
//

import Foundation

public typealias FetchTransactionByIDUseCaseFactory = () -> FetchTransactionByIDUseCase

public typealias FetchTransactionsByTimeUseCaseFactory = () -> FetchTransactionsByTimeUseCase

public typealias AddTransactionsUseCaseFactory = () -> AddTransactionsUseCase

public typealias UpdateTransactionsUseCaseFactory = () -> UpdateTransactionsUseCase

public typealias DeleteTransactionsUseCaseFactory = () -> DeleteTransactionsByIDsUseCase

public typealias SearchTransactionsUseCaseFactory = () -> SearchTransactionsUseCase
