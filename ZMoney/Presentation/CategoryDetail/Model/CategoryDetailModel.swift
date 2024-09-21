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
    private var name: String
    var icon: String
    var color: Color
    var sortIndex: Index
    var type: DMTransactionType
    var isPlaceholder: Bool
    var localizedName: String
}

extension CategoryDetailModel {
    init(category: DMCategory, isPlaceholder: Bool) {
        self.id = category.id
        self.name = category.name
        self.icon = category.icon
        self.color = Color(hex: category.color)
        self.sortIndex = category.sortIndex
        self.type = category.type
        self.isPlaceholder = isPlaceholder
        self.localizedName = category.name.localized
    }

    init(category: DMCategory) {
        self.init(category: category, isPlaceholder: false)
    }

    var domain: DMCategory {
        // Try to keep the original localize key
        let categoryName = (name.localized == localizedName ? name : localizedName)
            .trimmingCharacters(in: .whitespacesAndNewlines)
        return DMCategory(
            id: id,
            name: categoryName,
            icon: icon,
            color: color.hexString,
            sortIndex: sortIndex,
            type: type
        )
    }
}
