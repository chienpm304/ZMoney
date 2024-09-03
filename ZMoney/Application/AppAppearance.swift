//
//  AppAppearance.swift
//  ZMoney
//
//  Created by Chien Pham on 30/08/2024.
//

import UIKit
import SwiftDate
import SwiftUI

final class AppAppearance {

    static func setupAppearance() {
        SwiftDate.defaultRegion = .current

        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(Color.accentColor)
        UISegmentedControl.appearance().backgroundColor = UIColor.systemBackground
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor(Color.white)],
            for: .selected
        )
        UISegmentedControl.appearance().setTitleTextAttributes(
            [.foregroundColor: UIColor(Color.accentColor)],
            for: .normal
        )
    }
}
