//
//  FieldBackground.swift
//  ZMoney
//
//  Created by Chien Pham on 03/09/2024.
//

import SwiftUI

struct FieldBackground: ViewModifier {

    func body(content: Content) -> some View {
        content
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.systemGroupedBackground)
            )
    }
}

extension View {
    func withFieldBackground() -> some View {
        self.modifier(FieldBackground())
    }
}
