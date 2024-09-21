//
//  CategoryStorage.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

import DomainModule

public protocol CategoryStorage {
    func fetchCategories() async throws -> [DMCategory]

    func addCategories(_ categories: [DMCategory]) async throws -> [DMCategory]

    func updateCategories(_ categories: [DMCategory]) async throws -> [DMCategory]

    func deleteCategories(_ categoryIDs: [ID]) async throws -> [DMCategory]
}
