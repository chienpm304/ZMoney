//
//  TransCategoryStorage.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

import Domain

public protocol TransCategoryStorage {
    func fetchAllTransCategories(
        completion: @escaping (Result<[TransCategory], Error>) -> Void
    )

    func addTransCategory(
        _ category: TransCategory,
        completion: @escaping (Result<TransCategory, Error>) -> Void
    )

    func updateTransCategory(
        _ category: TransCategory,
        completion: @escaping (Result<TransCategory, Error>) -> Void
    )

    func deleteTransCategory(
        byId id: ID,
        completion: @escaping (Result<TransCategory, Error>) -> Void
    )
}
