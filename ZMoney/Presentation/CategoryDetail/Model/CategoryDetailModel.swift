//
//  CategoryDetailModel.swift
//  ZMoney
//
//  Created by Chien Pham on 23/08/2024.
//

import DomainModule
import SwiftUI

struct CategoryDetailModel {
    var id: ID
    var name: String
    var icon: String
    var color: Color
    var sortIndex: Index
    var type: DMTransactionType
}

extension CategoryDetailModel {
    init(category: DMCategory) {
        self.id = category.id
        self.name = category.name
        self.icon = category.icon
        self.color = Color(hex: category.color)
        self.sortIndex = category.sortIndex
        self.type = category.type
    }

    var domain: DMCategory {
        DMCategory(
            id: id,
            name: name,
            icon: icon,
            color: color.hexString,
            sortIndex: sortIndex,
            type: type
        )
    }
}
