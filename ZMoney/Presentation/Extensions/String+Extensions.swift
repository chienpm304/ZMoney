//
//  String+Extensions.swift
//  ZMoney
//
//  Created by Chien Pham on 21/09/2024.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
