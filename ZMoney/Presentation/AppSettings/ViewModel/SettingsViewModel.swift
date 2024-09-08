//
//  SettingsViewModel.swift
//  ZMoney
//
//  Created by Chien Pham on 07/09/2024.
//

import SwiftUI
import Combine
import DomainModule
import DataModule

typealias SettingsViewModel = AppSettings

final class AppSettings: ObservableObject, AlertProvidable {
    @Published var settings: DMSettings {
        didSet {
            settingRepository.updateSettings(settings) { [weak self] result in
                DispatchQueue.main.async {
                    self?.showAlert(with: result, successMessage: "Updated settings!")
                }
            }
        }
    }

    @Published var alertData: AlertData?

    private let settingRepository: SettingsRepository

    init(settingRepository: SettingsRepository) {
        self.settingRepository = settingRepository
        self.settings = settingRepository.fetchSettings()
    }

    var currency: DMCurrency { settings.currency }
    var language: DMLanguage { settings.language }

    var currencySymbol: String {
        currency.symbol
    }

    var maxMoneyDigits: Int { 12 }

    lazy var currencyFormatter: NumberFormatter = {
        let formatter = baseCurrencyFormatter
        formatter.positiveSuffix = " \(currencySymbol)"
        return formatter
    }()

    lazy var currencyFormatterWithoutSymbol: NumberFormatter = {
        let formatter = baseCurrencyFormatter
        formatter.positiveSuffix = ""
        return formatter
    }()

    private var baseCurrencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = ","
        formatter.positivePrefix = ""
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }
}

extension AppSettings {
    static var preview: AppSettings {
        AppSettings(
            settingRepository: DefaultSettingsRepository(
                settingsStorage: SettingsUserDefaultStorage(
                    userDefaultCoordinator: UserDefaultCoordinator(
                        userDefaults: InMemoryUserDefaultsCoordinator()
                    )
                )
            )
        )
    }
}
