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
    public func fetchCategories(completion: @escaping (Result<[DMCategory], Error>) -> Void) {
        storage.fetchCategories(completion: completion)
    }

    public func addCategories(
        _ categories: [DMCategory],
        completion: @escaping (Result<[DMCategory], Error>) -> Void
    ) {
        storage.addCategories(categories, completion: completion)
    }

    public func updateCategories(
        _ categories: [DMCategory],
        completion: @escaping (Result<[DMCategory], Error>) -> Void
    ) {
        storage.updateCategories(categories, completion: completion)
    }

    public func deleteCategories(
        _ categoryIDs: [ID],
        completion: @escaping (Result<[DMCategory], Error>) -> Void
    ) {
        storage.deleteCategories(categoryIDs, completion: completion)
    }
}
