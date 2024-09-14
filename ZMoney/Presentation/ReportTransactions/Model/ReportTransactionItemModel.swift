//
//  ReportTransactionItemModel.swift
//  ZMoney
//
//  Created by Chien Pham on 14/09/2024.
//

import Foundation
import DomainModule

struct ReportTransactionItemModel: Identifiable {
    let category: CategoryDetailModel
    let amount: MoneyValue
    let percent: Double

    var id: UUID { category.id }
}
