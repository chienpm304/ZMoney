//
//  TransCategoryDetailModel.swift
//  ZMoney
//
//  Created by Chien Pham on 23/08/2024.
//

import DomainModule

struct TransCategoryDetailModel {
    var id: ID
    var name: String
    var icon: String
    var iconColor: String
    var sortIndex: Index
    var type: TransType
}

extension TransCategoryDetailModel {
    init(category: TransCategory) {
        self.id = category.id
        self.name = category.name
        self.icon = category.icon
        self.iconColor = category.color
        self.sortIndex = category.sortIndex
        self.type = category.type
    }
}
