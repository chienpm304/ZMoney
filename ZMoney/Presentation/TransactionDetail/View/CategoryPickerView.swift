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
    var didTapEdit: (() -> Void)?

    private let innerPadding = 4.0
    private let outterPadding = 2.0
    private let borderWidth = 1.0

    private var cornerRadius: Double {
        innerPadding + outterPadding
    }

    private var layout: [GridItem] {
        [GridItem(.adaptive(minimum: 80))]
    }

    private var maxWidth: CGFloat { 120 }
    private var maxHeight: CGFloat { 50 }

    var body: some View {
        LazyVGrid(columns: layout, spacing: spacing) {
            ForEach(items, id: \.self) { item in
                let isSelected = item == selectedItem
                let color = isSelected ? Color.accentColor : Color.border
                CategoryItemView(item: item)
                    .frame(maxWidth: maxWidth)
                    .frame(height: maxHeight)
                    .padding(innerPadding)
                    .cornerRadius(cornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: innerPadding)
                            .stroke(color, lineWidth: borderWidth)
                    )
                    .padding(outterPadding)
                    .onTapGesture {
                        selectedItem = item
                    }
            }

            Button {
                didTapEdit?()
            } label: {
                HStack {
                    Text("Edit")
                        .font(.system(size: 14))
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: maxWidth)
                .frame(height: maxHeight)
                .padding(innerPadding)
                .cornerRadius(cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: innerPadding)
                        .stroke(Color.border, lineWidth: borderWidth)
                )
                .padding(outterPadding)
            }
        }
        .padding(.vertical, 8)
    }
}

struct CategoryItemView: View {
    let item: CategoryDetailModel

    var body: some View {
        VStack(spacing: 4) {
            IconItemView(icon: item.icon, color: item.color)
                .frame(width: 24, height: 24)
            Text(LocalizedStringKey(item.name))
                .font(.system(size: 12))
        }
    }
}
