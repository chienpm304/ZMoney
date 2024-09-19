//
//  Category+Mapping.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

import Foundation
import CoreData
import DomainModule

// If compiler say that not found the entity, try add core data model target membership
extension CDCategory {
    var domain: DMCategory {
        let categoryID: ID
        if let id = self.id {
            categoryID = id
        } else {
            assertionFailure("CDCategory.id should not be nil")
            categoryID = .generate()
        }
        return DMCategory(
            id: categoryID,
            name: self.name ?? "",
            icon: self.icon ?? "",
            color: self.color ?? "",
            sortIndex: self.sortIndex,
            type: DMTransactionType(rawValue: self.type) ?? .expense
        )
    }
}

extension CDCategory {
    convenience init(category: DMCategory, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = category.id
        self.name = category.name
        self.icon = category.icon
        self.color = category.color
        self.sortIndex = category.sortIndex
        self.type = category.type.rawValue
    }
}

// MARK: Codable

extension DMTransactionType: Codable { }

struct CategoryCodable: Codable {
    let id: ID
    let name: String
    let icon: String
    let color: String
    let sortIndex: Index
    let type: DMTransactionType

    init(from category: DMCategory) {
        self.id = category.id
        self.name = category.name
        self.icon = category.icon
        self.color = category.color
        self.sortIndex = category.sortIndex
        self.type = category.type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(ID.self, forKey: .id) ?? UUID()
        self.name = try container.decode(String.self, forKey: .name)
        self.icon = try container.decode(String.self, forKey: .icon)
        self.color = try container.decode(String.self, forKey: .color)
        self.sortIndex = try container.decode(Index.self, forKey: .sortIndex)
        self.type = try container.decode(DMTransactionType.self, forKey: .type)
    }

    enum CodingKeys: CodingKey {
        case id
        case name
        case icon
        case color
        case sortIndex
        case type
    }
}

extension CategoryCodable {
    var domain: DMCategory {
        DMCategory(
            id: id,
            name: name,
            icon: icon,
            color: color,
            sortIndex: sortIndex,
            type: type
        )
    }
}
