//
//  AlertData.swift
//  ZMoney
//
//  Created by Chien Pham on 07/09/2024.
//

import Foundation
import SwiftUI

struct AlertData: Identifiable {
    let id = UUID()
    var title: LocalizedStringKey
    var message: LocalizedStringKey?
    var isSuccess: Bool
    var isToast: Bool
}
