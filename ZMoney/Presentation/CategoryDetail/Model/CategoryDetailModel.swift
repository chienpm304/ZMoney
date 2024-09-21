//
//  CategoryDetailModel.swift
//  ZMoney
//
//  Created by Chien Pham on 23/08/2024.
//

import DomainModule
import SwiftUI

struct CategoryDetailModel: Identifiable, Hashable {
    var id: ID
    var name: String
    var icon: String
    var color: Color
    var sortIndex: Index
    var type: DMTransactionType
    var isPlaceholder: Bool
}

extension CategoryDetailModel {
    init(category: DMCategory, isPlaceholder: Bool) {
        self.id = category.id
        self.name = NSLocalizedString(category.name, comment: "") 
        self.icon = category.icon
        self.color = Color(hex: category.color)
        self.sortIndex = category.sortIndex
        self.type = category.type
        self.isPlaceholder = isPlaceholder
    }

    init(category: DMCategory) {
        self.init(category: category, isPlaceholder: false)
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
