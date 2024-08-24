//
//  TransCategoriesUseCaseFactory.swift
//  DomainModule
//
//  Created by Chien Pham on 24/08/2024.
//

import Foundation

public typealias FetchTransCategoriesUseCaseFactory = (
    @escaping (FetchTransCategoriesUseCase.ResultValue) -> Void
) -> UseCase

public typealias AddTransCategoriesUseCaseFactory = (
    AddTransCategoriesUseCase.RequestValue,
    @escaping (UpdateTransCategoriesUseCase.ResultValue) -> Void
) -> UseCase

public typealias UpdateTransCategoriesUseCaseFactory = (
    UpdateTransCategoriesUseCase.RequestValue,
    @escaping (UpdateTransCategoriesUseCase.ResultValue) -> Void
) -> UseCase

public typealias DeleteTransCategoriesUseCaseFactory = (
    DeleteTransCategoriesUseCase.RequestValue,
    @escaping (DeleteTransCategoriesUseCase.ResultValue) -> Void
) -> UseCase

public struct TransCategoriesUseCaseFactory {
    public let fetchUseCase: FetchTransCategoriesUseCaseFactory
    public let addUseCase: AddTransCategoriesUseCaseFactory
    public let updateUseCase: UpdateTransCategoriesUseCaseFactory
    public let deleteUseCase: DeleteTransCategoriesUseCaseFactory

    public init(
        fetchUseCase: @escaping FetchTransCategoriesUseCaseFactory,
        addUseCase: @escaping AddTransCategoriesUseCaseFactory,
        updateUseCase: @escaping UpdateTransCategoriesUseCaseFactory,
        deleteUseCase: @escaping DeleteTransCategoriesUseCaseFactory
    ) {
        self.fetchUseCase = fetchUseCase
        self.addUseCase = addUseCase
        self.updateUseCase = updateUseCase
        self.deleteUseCase = deleteUseCase
    }
}
