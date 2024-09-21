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

public typealias DeleteCategoriesUseCaseFactory = () -> DeleteCategoriesUseCase
