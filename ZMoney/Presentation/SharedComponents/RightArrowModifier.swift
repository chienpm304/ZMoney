//
//  RightArrowModifier.swift
//  ZMoney
//
//  Created by Chien Pham on 22/08/2024.
//

import SwiftUI

struct RightArrowModifier: ViewModifier {
    func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

extension View {
    func withRightArrow() -> some View {
        self.modifier(RightArrowModifier())
    }
}
