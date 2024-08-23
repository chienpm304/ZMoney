//
//  TransCategoryStorage.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

import DomainModule

public protocol TransCategoryStorage {
    func fetchAllTransCategories(
        completion: @escaping (Result<[TransCategory], Error>) -> Void
    )

    func addTransCategories(
        _ categories: [TransCategory],
        completion: @escaping (Result<[TransCategory], Error>) -> Void
    )

    func updateTransCategories(
        _ categories: [TransCategory],
        completion: @escaping (Result<[TransCategory], Error>) -> Void
    )

    func deleteTransCategory(
        byId id: ID,
        completion: @escaping (Result<TransCategory, Error>) -> Void
    )
}
