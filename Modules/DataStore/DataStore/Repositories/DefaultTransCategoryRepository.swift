//
//  DefaultTransCategoryRepository.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

import Domain

public final class DefaultTransCategoryRepository {
    private let storage: TransCategoryStorage

    public init(storage: TransCategoryStorage) {
        self.storage = storage
    }
}

extension DefaultTransCategoryRepository: TransCategoryRepository {
    public func fetchAllTransCategories(completion: @escaping (Result<[TransCategory], Error>) -> Void) {
        storage.fetchAllTransCategories(completion: completion)
    }

    public func addTransCategory(
        _ category: TransCategory,
        completion: @escaping (Result<TransCategory, Error>) -> Void
    ) {
        storage.addTransCategory(category, completion: completion)
    }

    public func updateTransCategory(
        _ category: TransCategory,
        completion: @escaping (Result<TransCategory, Error>) -> Void
    ) {
        storage.updateTransCategory(category, completion: completion)
    }

    public func deleteTransCategory(
        byId id: ID,
        completion: @escaping (Result<TransCategory, Error>) -> Void
    ) {
        storage.deleteTransCategory(byId: id, completion: completion)
    }
}
