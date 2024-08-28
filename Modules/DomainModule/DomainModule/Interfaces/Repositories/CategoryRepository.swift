//
//  CategoryRepository.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

public enum CategoryDeleteError: Error {
    case categoryNotFound
    case violateRelationshipConstraintError
    case error(Error)
}

public protocol CategoryRepository {
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
        completion: @escaping (Result<[DMCategory], CategoryDeleteError>) -> Void
    )
}
