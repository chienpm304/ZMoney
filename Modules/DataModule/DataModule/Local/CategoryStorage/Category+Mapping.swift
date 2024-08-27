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
