//
//  Color+Extensions.swift
//  ZMoney
//
//  Created by Chien Pham on 22/08/2024.
//

import SwiftUI

// swiftlint:disable identifier_name

extension Color {
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") {
            hexSanitized.removeFirst()
        }

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0

        self.init(red: r, green: g, blue: b)
    }

    var hexString: String {
        guard let components = self.cgColor?.components, components.count >= 3 else {
            return "#000000"
        }

        let r = components[0]
        let g = components[1]
        let b = components[2]

        let rgb = (Int(r * 255) << 16) | (Int(g * 255) << 8) | Int(b * 255)

        return String(format: "#%06X", rgb)
    }
}

// swiftlint:enable identifier_name
