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
            guard oldValue != settings else { return }
            settingRepository.updateSettings(settings) { [weak self] result in
                guard let self else { return }
                DispatchQueue.main.async {
                    if self.settings.language != oldValue.language {
                        self.setAppLanguage(languageCode: self.settings.language.languageCode)
                    } else {
                        self.showAlert(with: result, successMessage: "Updated settings!")
                    }
                }
            }
        }
    }

    private func setAppLanguage(languageCode: String, needShowAlert: Bool = true) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        if needShowAlert {
            showSuccessAlert(with: "Please restart the app to apply the language change.")
        }
    }

    @Published var alertData: AlertData?

    private let settingRepository: SettingsRepository

    init(settingRepository: SettingsRepository) {
        self.settingRepository = settingRepository
        self.settings = settingRepository.fetchSettings()
        setAppLanguage(languageCode: settings.language.languageCode, needShowAlert: false)
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
