//
//  TabViewType.swift
//  ZMoney
//
//  Created by Chien Pham on 01/09/2024.
//

import Foundation

enum TabViewType: CaseIterable {
    case createTransaction
    case transactions
    case report
    case settings

    static var primaryTab: TabViewType { .createTransaction }

    init?(index: Int) {
        switch index {
        case 0:
            self = .createTransaction
        case 1:
            self = .transactions
        case 2:
            self = .report
        case 3:
            self = .settings
        default:
            return nil
        }
    }

    var title: String {
        switch self {
        case .createTransaction:
            return "Input"
        case .transactions:
            return "Calendar"
        case .report:
            return "Report"
        case .settings:
            return "Settings"
        }
    }

    var localizedTitle: String {
        title.localizedCapitalized
    }

    var index: Int {
        switch self {
        case .createTransaction:
            return 0
        case .transactions:
            return 1
        case .report:
            return 2
        case .settings:
            return 3
        }
    }

    var tabIcon: String {
        switch self {
        case .createTransaction:
            return "square.and.pencil"
        case .transactions:
            return "calendar"
        case .report:
            return "chart.pie.fill"
        case .settings:
            return "gear"
        }
    }
}
