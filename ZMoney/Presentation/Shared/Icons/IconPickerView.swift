//
//  IconPickerView.swift
//  ZMoney
//
//  Created by Chien Pham on 24/08/2024.
//

import Foundation
import SwiftUI

struct IconPickerView: View {
    let axis: Axis.Set
    let axisCount: Int
    let spacing: CGFloat
    let icons: [String]
    let iconSize: CGSize
    @Binding var selectedIcon: String
    @Binding var selectedColor: Color

    private let innerPadding = 4.0
    private let outterPadding = 2.0
    private let borderWidth = 1.0

    private var totalPadding: Double {
        innerPadding + outterPadding + borderWidth
    }

    private var layout: [GridItem] {
        let axisSize = axis == .horizontal ? iconSize.height : iconSize.width
        return Array(repeating: GridItem(.fixed(axisSize), spacing: spacing), count: axisCount)
    }

    var body: some View {
        ScrollView(axis, showsIndicators: false) {
            if axis == .horizontal {
                LazyHGrid(rows: layout, spacing: spacing) {
                    itemList()
                }
                .padding(.vertical, 1)
            } else {
                LazyVGrid(columns: layout, spacing: spacing) {
                    itemList()
                }
                .padding(.horizontal, 1)
            }
        }
    }

    private func itemList() -> ForEach<[String], String, some View> {
        return ForEach(icons, id: \.self) { icon in
            let isSelected = icon == selectedIcon
            let color = isSelected ? selectedColor : Color.black.opacity(0.2)
            IconItemView(icon: icon, color: color)
                .frame(width: iconSize.width - totalPadding, height: iconSize.height - totalPadding)
                .padding(innerPadding)
                .cornerRadius(innerPadding + outterPadding)
                .overlay(
                    RoundedRectangle(cornerRadius: innerPadding)
                        .stroke(color, lineWidth: borderWidth)
                )
                .padding(outterPadding)
                .onTapGesture {
                    selectedIcon = icon
                }
        }
    }
}

struct IconItemView: View {
    let icon: String
    let color: Color

    var body: some View {
        Image(systemName: icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(color)
    }
}
