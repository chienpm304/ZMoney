//
//  IconPickerView.swift
//  ZMoney
//
//  Created by Chien Pham on 24/08/2024.
//

import Foundation
import SwiftUI

struct IconPickerView: View {
    @Binding var selectedIcon: String
    @Binding var selectedColor: Color
    let icons: [String]
    let iconSize: CGSize
    let numberOfColums: Int
    let spacing: CGFloat

    private var layout: [GridItem] {
        Array(repeating: GridItem(.fixed(iconSize.width + 12)), count: numberOfColums)
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: layout, spacing: spacing) {
                ForEach(icons, id: \.self) { icon in
                    let isSelected = icon == selectedIcon
                    let color = isSelected ? selectedColor : Color.black.opacity(0.2)
                    IconItemView(icon: icon, color: color)
                        .frame(width: iconSize.width, height: iconSize.height)
                        .padding(4)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(color, lineWidth: 1)
                        )
                        .padding(2)
                        .onTapGesture {
                            selectedIcon = icon
                        }
                }
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

//
//#Preview {
//
//    @State private var selectedIcon: String = "star"
//
//    var body: some View {
//        HorizontalIconPickerView(selectedIcon: $selectedIcon, icons: ["star", "heart", "bolt", "leaf", "cloud", "moon", "sun.max"])
//    }
//}
