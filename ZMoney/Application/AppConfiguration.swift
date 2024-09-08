//
//  AppConfiguration.swift
//  ZMoney
//
//  Created by Chien Pham on 19/08/2024.
//

import Foundation
import DomainModule
import DataModule

final class AppConfiguration {
    let settings: AppSettings

    init(settings: AppSettings) {
        self.settings = settings
    }
}
