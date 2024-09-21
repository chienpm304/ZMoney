//
//  CategoryRepository.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

public protocol CategoryRepository {
    func fetchCategories() async throws -> [DMCategory]

    func addCategories(_ categories: [DMCategory]) async throws -> [DMCategory]

    func updateCategories(_ categories: [DMCategory]) async throws -> [DMCategory]

    func deleteCategories(_ categoryIDs: [ID]) async throws -> [DMCategory]

    func fetchDefaultCategories() async -> [DMCategory]
}
