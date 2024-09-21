//
//  CategoryStorage.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

import DomainModule

public protocol CategoryStorage {
    func fetchCategories(
        completion: @escaping (Result<[DMCategory], DMError>) -> Void
    )

    func addCategories(
        _ categories: [DMCategory],
        completion: @escaping (Result<[DMCategory], DMError>) -> Void
    )

    func updateCategories(
        _ categories: [DMCategory],
        completion: @escaping (Result<[DMCategory], DMError>) -> Void
    )

    func deleteCategories(_ categoryIDs: [ID]) async throws -> [DMCategory]
}
