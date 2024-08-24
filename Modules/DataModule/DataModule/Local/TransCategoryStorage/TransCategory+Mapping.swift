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
extension TransCategoryEntity {
    var domain: DMCategory {
        .init(
            id: self.id,
            name: self.name ?? "",
            icon: self.icon ?? "",
            color: self.color ?? "",
            sortIndex: self.sortIndex,
            type: TransType(rawValue: self.type) ?? .expense
        )
    }
}

extension TransCategoryEntity {
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
