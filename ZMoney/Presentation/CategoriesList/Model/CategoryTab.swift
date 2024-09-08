//
//  CategoryTab.swift
//  ZMoney
//
//  Created by Chien Pham on 22/08/2024.
//

import DomainModule
import SwiftUI

enum CategoryTab: String, CaseIterable, Identifiable {
    case expense
    case income
    var id: Self { self }

    var localizedStringKey: LocalizedStringKey {
        switch self {
        case .expense:
            "Expense"
        case .income:
            "Income"
        }
    }
}

extension CategoryTab {
    var domainType: DMTransactionType {
        switch self {
        case .expense:
            return .expense
        case .income:
            return .income
        }
    }
}

extension DMTransactionType {
    var toViewModel: CategoryTab {
        switch self {
        case .expense:
            return .expense
        case .income:
            return .income
        }
    }
}
