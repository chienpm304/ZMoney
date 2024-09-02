//
//  MoneyText.swift
//  ZMoney
//
//  Created by Chien Pham on 02/09/2024.
//

import SwiftUI
import DomainModule

struct MoneyText: View {
    private let value: MoneyValue
    private let type: DMTransactionType

    init(value: MoneyValue, type: DMTransactionType) {
        self.value = value
        self.type = type
    }

    var body: some View {
        textView
    }

    private var textView: Text {
        Text("\(value)")
            .foregroundColor(type == .expense ? .red : .blue)
    }
}

extension MoneyText {
    func font(_ font: Font?) -> some View {
        textView.font(font)
    }

    func fontWeight(_ weight: Font.Weight?) -> some View {
        textView.fontWeight(weight)
    }
}

#Preview {
    VStack {
        MoneyText(value: 123456, type: .expense)
            .fontWeight(.medium)
            .font(.title)
        MoneyText(value: 123456, type: .income)
    }
}
