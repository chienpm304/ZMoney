//
//  TransCategoriesListItemViewModel.swift
//  ZMoney
//
//  Created by Chien Pham on 22/08/2024.
//

import DomainModule

struct TransCategoriesListItemViewModel {
    let id: ID
    let name: String
    let icon: String
    let iconColor: String
}

extension TransCategoriesListItemViewModel {
    init(category: TransCategory) {
        self.id = category.id
        self.name = category.name
        self.icon = category.icon
        self.iconColor = category.color
    }
}
