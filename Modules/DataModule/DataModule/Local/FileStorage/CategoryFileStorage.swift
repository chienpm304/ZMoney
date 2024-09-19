//
//  CategoryFileStorage.swift
//  DataModule
//
//  Created by Chien Pham on 19/09/2024.
//

import Foundation

struct CategoryFileStorage {
    private static var cachedExpenseCategories: [CategoryCodable]?
    private static var cachedIncomeCategories: [CategoryCodable]?

    static func loadDefaultExpenseCategories() -> [CategoryCodable] {
        if let categories = cachedExpenseCategories {
            return categories
        }

        let categories = loadDefaultCategories(for: "expense_categories")
        cachedExpenseCategories = categories
        return categories
    }

    static func loadDefaultIncomeCategories() -> [CategoryCodable] {
        if let categories = cachedIncomeCategories {
            return categories
        }

        let categories = loadDefaultCategories(for: "income_categories")
        cachedIncomeCategories = categories
        return categories
    }

    static func loadDefaultCategories(for key: String) -> [CategoryCodable] {
        guard let url = Bundle.main.url(forResource: "default_categories", withExtension: "json"),
              let data = try? Data(contentsOf: url)
        else {
            print("Cannot load data for \(key)")
            return []
        }

        do {
            let decoder = JSONDecoder()
            let json = try decoder.decode([String: [CategoryCodable]].self, from: data)
            return json[key] ?? []
        } catch {
            print("Failed to decode categories: \(error)")
            return []
        }
    }
}
