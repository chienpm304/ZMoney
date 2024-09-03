//
//  CategoryPickerView.swift
//  ZMoney
//
//  Created by Chien Pham on 03/09/2024.
//

import Foundation
import SwiftUI

struct CategoryPickerView: View {
    let spacing: CGFloat
    let items: [CategoryDetailModel]
    @Binding var selectedItem: CategoryDetailModel

    private let innerPadding = 2.0
    private let outterPadding = 2.0
    private let borderWidth = 1.0

    private var totalPadding: Double {
        innerPadding + outterPadding + borderWidth
    }

    private var layout: [GridItem] {
        [GridItem(.adaptive(minimum: 60))]
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: layout, spacing: spacing) {
                ForEach(items, id: \.self) { item in
                    let isSelected = item == selectedItem
                    let color = isSelected ? Color.accentColor : Color.secondary.opacity(0.5)
                    CategoryItemView(item: item)
                        .frame(maxWidth: 80)
                        .frame(height: 50)
                        .padding(innerPadding)
                        .cornerRadius(innerPadding + outterPadding)
                        .overlay(
                            RoundedRectangle(cornerRadius: innerPadding)
                                .stroke(color, lineWidth: borderWidth)
                        )
                        .padding(outterPadding)
                        .onTapGesture {
                            selectedItem = item
                        }
                }
            }
            .padding(.vertical, 1)
        }
    }
}

struct CategoryItemView: View {
    let item: CategoryDetailModel

    var body: some View {
        VStack(spacing: 4) {
            IconItemView(icon: item.icon, color: item.color)
                .frame(width: 24, height: 24)
            Text(item.name)
                .font(.system(size: 12))
        }
    }
}
