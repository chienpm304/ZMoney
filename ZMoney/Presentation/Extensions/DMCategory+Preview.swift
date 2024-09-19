//
//  DMCategory+Preview.swift
//  ZMoney
//
//  Created by Chien Pham on 19/09/2024.
//

import Foundation
import DomainModule

extension DMCategory {
    static func preview(type: DMTransactionType) -> DMCategory {
        switch type {
        case .expense:
            return DMCategory(
                name: "Sample expense",
                icon: "house",
                color: "821131",
                sortIndex: 0,
                type: .expense
            )
        case .income:
            return DMCategory(
                name: "Sample income",
                icon: "dollarsign.circle",
                color: "522258",
                sortIndex: 1,
                type: .income
            )
        }
    }
}
