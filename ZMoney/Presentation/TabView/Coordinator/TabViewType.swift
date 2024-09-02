//
//  TabViewType.swift
//  ZMoney
//
//  Created by Chien Pham on 01/09/2024.
//

import Foundation

enum TabViewType: CaseIterable {
    case transactions
    case categories
    case settings

    static var primaryTab: TabViewType { .transactions }

    init?(index: Int) {
        switch index {
        case 0:
            self = .transactions
        case 1:
            self = .categories
        case 2:
            self = .settings
        default:
            return nil
        }
    }

    var title: String {
        switch self {
        case .transactions:
            return "Transactions"
        case .categories:
            return "Categories"
        case .settings:
            return "Settings"
        }
    }

    var index: Int {
        switch self {
        case .transactions:
            return 0
        case .categories:
            return 1
        case .settings:
            return 2
        }
    }

    var tabIcon: String {
        switch self {
        case .transactions:
            return "calendar"
        case .categories:
            return "list.bullet"
        case .settings:
            return "gear"
        }
    }
}
