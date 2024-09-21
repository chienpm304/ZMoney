//
//  DefaultCategoryRepository.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

import DomainModule

public final class DefaultCategoryRepository {
    private let storage: CategoryStorage

    public init(storage: CategoryStorage) {
        self.storage = storage
    }
}

extension DefaultCategoryRepository: CategoryRepository {
    public func fetchCategories() async throws -> [DMCategory] {
        try await storage.fetchCategories()
    }
    
    public func addCategories(_ categories: [DMCategory]) async throws -> [DMCategory] {
        try await storage.addCategories(categories)
    }

    public func updateCategories(_ categories: [DMCategory]) async throws -> [DMCategory] {
        try await storage.updateCategories(categories)
    }

    public func deleteCategories(_ categoryIDs: [ID]) async throws -> [DMCategory] {
        try await storage.deleteCategories(categoryIDs)
    }

    public func fetchDefaultCategories() async -> [DMCategory] {
        let defaultExpenseCategories = CategoryFileStorage.loadDefaultExpenseCategories()
        let defaultIncomeCategories = CategoryFileStorage.loadDefaultIncomeCategories()
        return (defaultExpenseCategories + defaultIncomeCategories)
            .map { $0.domain }
    }
}
