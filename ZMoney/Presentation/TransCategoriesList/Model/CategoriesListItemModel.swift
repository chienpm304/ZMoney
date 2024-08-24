//
//  CategoriesListItemModel.swift
//  ZMoney
//
//  Created by Chien Pham on 22/08/2024.
//

import DomainModule

struct CategoriesListItemModel {
    let id: ID
    let name: String
    let icon: String
    let iconColor: String
}

extension CategoriesListItemModel {
    init(category: DMCategory) {
        self.id = category.id
        self.name = category.name
        self.icon = category.icon
        self.iconColor = category.color
    }
}
