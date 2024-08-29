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

public typealias DeleteTransactionsUseCaseFactory = (
    DeleteTransactionsUseCase.RequestValue,
    @escaping (DeleteTransactionsUseCase.ResultValue) -> Void
) -> UseCase

public struct TransactionsUseCaseFactory {
    public let fetchByIDUseCase: FetchTransactionByIDUseCaseFactory
    public let fetchByTimeUseCase: FetchTransactionsByTimeUseCaseFactory
    public let addUseCase: AddTransactionsUseCaseFactory
    public let updateUseCase: UpdateTransactionsUseCaseFactory
    public let deleteUseCase: DeleteTransactionsUseCaseFactory

    public init(
        fetchByIDUseCase: @escaping FetchTransactionByIDUseCaseFactory,
        fetchByTimeUseCase: @escaping FetchTransactionsByTimeUseCaseFactory,
        addUseCase: @escaping AddTransactionsUseCaseFactory,
        updateUseCase: @escaping UpdateTransactionsUseCaseFactory,
        deleteUseCase: @escaping DeleteTransactionsUseCaseFactory
    ) {
        self.fetchByIDUseCase = fetchByIDUseCase
        self.fetchByTimeUseCase = fetchByTimeUseCase
        self.addUseCase = addUseCase
        self.updateUseCase = updateUseCase
        self.deleteUseCase = deleteUseCase
    }
}
