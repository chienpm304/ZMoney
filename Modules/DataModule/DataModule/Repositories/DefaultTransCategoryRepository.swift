//
//  DefaultTransCategoryRepository.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

import DomainModule

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

    public func addTransCategories(
        _ categories: [TransCategory],
        completion: @escaping (Result<[TransCategory], Error>) -> Void
    ) {
        storage.addTransCategories(categories, completion: completion)
    }

    public func updateTransCategories(
        _ categories: [TransCategory],
        completion: @escaping (Result<[TransCategory], Error>) -> Void
    ) {
        storage.updateTransCategories(categories, completion: completion)
    }

    public func deleteTransCategories(
        _ categoryIDs: [ID],
        completion: @escaping (Result<[TransCategory], Error>) -> Void
    ) {
        storage.deleteTransCategories(categoryIDs, completion: completion)
    }
}
