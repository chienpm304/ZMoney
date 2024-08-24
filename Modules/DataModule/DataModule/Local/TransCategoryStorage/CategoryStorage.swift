//
//  CategoryStorage.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

import DomainModule

public protocol CategoryStorage {
    func fetchCategories(
        completion: @escaping (Result<[DMCategory], Error>) -> Void
    )

    func addCategories(
        _ categories: [DMCategory],
        completion: @escaping (Result<[DMCategory], Error>) -> Void
    )

    func updateCategories(
        _ categories: [DMCategory],
        completion: @escaping (Result<[DMCategory], Error>) -> Void
    )

    func deleteCategories(
        _ categoryIDs: [ID],
        completion: @escaping (Result<[DMCategory], Error>) -> Void
    )
}
