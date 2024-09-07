//
//  AlertData.swift
//  ZMoney
//
//  Created by Chien Pham on 07/09/2024.
//

import Foundation

struct AlertData: Identifiable {
    let id = UUID()
    var title: String
    var message: String?
    var isSuccess: Bool
    var isToast: Bool
}
