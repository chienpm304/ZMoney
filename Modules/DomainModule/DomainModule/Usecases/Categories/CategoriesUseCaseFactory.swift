//
//  CategoriesUseCaseFactory.swift
//  DomainModule
//
//  Created by Chien Pham on 24/08/2024.
//

import Foundation

public typealias FetchCategoriesUseCaseFactory = () -> FetchCategoriesUseCase

public typealias AddCategoriesUseCaseFactory = () -> AddCategoriesUseCase

public typealias UpdateCategoriesUseCaseFactory = () -> UpdateCategoriesUseCase

public typealias DeleteCategoriesUseCaseFactory = () -> DeleteCategoriesUseCase
