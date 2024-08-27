//
//  CategoriesUseCaseFactory.swift
//  DomainModule
//
//  Created by Chien Pham on 24/08/2024.
//

import Foundation

public typealias FetchCategoriesUseCaseFactory = (
    @escaping (FetchCategoriesUseCase.ResultValue) -> Void
) -> UseCase

public typealias AddCategoriesUseCaseFactory = (
    AddCategoriesUseCase.RequestValue,
    @escaping (UpdateCategoriesUseCase.ResultValue) -> Void
) -> UseCase

public typealias UpdateCategoriesUseCaseFactory = (
    UpdateCategoriesUseCase.RequestValue,
    @escaping (UpdateCategoriesUseCase.ResultValue) -> Void
) -> UseCase

public typealias DeleteCategoriesUseCaseFactory = (
    DeleteCategoriesUseCase.RequestValue,
    @escaping (DeleteCategoriesUseCase.ResultValue) -> Void
) -> UseCase

public struct CategoriesUseCaseFactory {
    public let fetchUseCase: FetchCategoriesUseCaseFactory
    public let addUseCase: AddCategoriesUseCaseFactory
    public let updateUseCase: UpdateCategoriesUseCaseFactory
    public let deleteUseCase: DeleteCategoriesUseCaseFactory

    public init(
        fetchUseCase: @escaping FetchCategoriesUseCaseFactory,
        addUseCase: @escaping AddCategoriesUseCaseFactory,
        updateUseCase: @escaping UpdateCategoriesUseCaseFactory,
        deleteUseCase: @escaping DeleteCategoriesUseCaseFactory
    ) {
        self.fetchUseCase = fetchUseCase
        self.addUseCase = addUseCase
        self.updateUseCase = updateUseCase
        self.deleteUseCase = deleteUseCase
    }
}
