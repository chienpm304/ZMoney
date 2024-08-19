//
//  DefaultCategoryRepository.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

import Common
import Domain

final class DefaultCategoryRepository {
    private let storage: TransCategoryStorage

    init(storage: TransCategoryStorage) {
        self.storage = storage
    }
}

extension DefaultCategoryRepository: TransCategoryRepository {
    func fetchAllTransCategories(completion: @escaping (Result<[TransCategory], Error>) -> Void) {
        storage.fetchAllTransCategories(completion: completion)
    }

    func addTransCategory(
        _ category: TransCategory,
        completion: @escaping (Result<TransCategory, Error>) -> Void
    ) {
        storage.addTransCategory(category, completion: completion)
    }

    func updateTransCategory(
        _ category: TransCategory,
        completion: @escaping (Result<TransCategory, Error>) -> Void
    ) {
        storage.updateTransCategory(category, completion: completion)
    }

    func deleteTransCategory(
        byId id: ID,
        completion: @escaping (Result<TransCategory, Error>) -> Void
    ) {
        storage.deleteTransCategory(byId: id, completion: completion)
    }
}
