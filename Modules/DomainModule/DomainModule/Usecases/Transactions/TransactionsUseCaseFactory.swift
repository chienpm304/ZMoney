//
//  TransactionsUseCaseFactory.swift
//  DomainModule
//
//  Created by Chien Pham on 27/08/2024.
//

import Foundation

public typealias FetchTransactionByIDUseCaseFactory = (
    FetchTransactionByIDUseCase.RequestValue,
    @escaping (FetchTransactionByIDUseCase.ResultValue) -> Void
) -> UseCase

public typealias FetchTransactionsByTimeUseCaseFactory = (
    FetchTransactionsByTimeUseCase.RequestValue,
    @escaping (FetchTransactionsByTimeUseCase.ResultValue) -> Void
) -> UseCase

public typealias AddTransactionsUseCaseFactory = (
    AddTransactionsUseCase.RequestValue,
    @escaping (AddTransactionsUseCase.ResultValue) -> Void
) -> UseCase

public typealias UpdateTransactionsUseCaseFactory = (
    UpdateTransactionsUseCase.RequestValue,
    @escaping (UpdateTransactionsUseCase.ResultValue) -> Void
) -> UseCase

public typealias DeleteTransactionsUseCaseFactory = () -> DeleteTransactionsByIDsUseCase

public typealias SearchTransactionsUseCaseFactory = () -> SearchTransactionsUseCase
