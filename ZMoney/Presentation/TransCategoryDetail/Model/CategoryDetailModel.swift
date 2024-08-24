//
//  CategoryDetailModel.swift
//  ZMoney
//
//  Created by Chien Pham on 23/08/2024.
//

import DomainModule

struct CategoryDetailModel {
    var id: ID
    var name: String
    var icon: String
    var color: String
    var sortIndex: Index
    var type: DMTransactionType
}

extension CategoryDetailModel {
    init(category: DMCategory) {
        self.id = category.id
        self.name = category.name
        self.icon = category.icon
        self.color = category.color
        self.sortIndex = category.sortIndex
        self.type = category.type
    }

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
