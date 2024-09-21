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
    @escaping (AddCategoriesUseCase.ResultValue) -> Void
) -> UseCase

public typealias UpdateCategoriesUseCaseFactory = () -> UpdateCategoriesUseCase

public typealias DeleteCategoriesUseCaseFactory = () -> DeleteCategoriesUseCase
