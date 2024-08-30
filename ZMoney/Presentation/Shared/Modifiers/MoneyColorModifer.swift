//
//  MoneyColorModifer.swift
//  ZMoney
//
//  Created by Chien Pham on 31/08/2024.
//

import SwiftUI
import DomainModule

struct MoneyColorModifier: ViewModifier {
    private let type: DMTransactionType

    init(type: DMTransactionType) {
        self.type = type
    }

    func body(content: Content) -> some View {
        content
            .foregroundColor(type == .expense ? .red : .blue)
    }
}

extension View {
    func moneyColor(type: DMTransactionType) -> some View {
        self.modifier(MoneyColorModifier(type: type))
    }
}
