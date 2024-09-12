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
    struct Dependencies {
        let fetchSettingUseCaseFactory: FetchSettingsUseCaseFactory
        let updateSettingUseCaseFactory: UpdateSettingsUseCaseFactory
    }

    @MainActor @Published var settings: DMSettings = .defaultValue
    @Published var alertData: AlertData?

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    @MainActor var currency: DMCurrency { settings.currency }
    @MainActor var language: DMLanguage { settings.language }

    @MainActor var currencySymbol: String {
        currency.symbol
    }

    var maxMoneyDigits: Int { 12 }

    @MainActor lazy var currencyFormatter: NumberFormatter = {
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

    @MainActor func fetchSettings() async {
        let fetchSettingsUseCase = dependencies.fetchSettingUseCaseFactory()
        settings = await fetchSettingsUseCase.execute(input: ())
    }

    @MainActor func updateSettings(_ oldValue: DMSettings) async {
        do {
            let updateSettingsUseCase = dependencies.updateSettingUseCaseFactory()
            let input = UpdateSettingsUseCase.Input(settings: settings)
            settings = try await updateSettingsUseCase.execute(input: input)

            if oldValue.language != settings.language {
                self.setAppLanguage(languageCode: settings.language.languageCode)
            } else {
                self.showSuccessAlert(with: "Updated settings!")
            }
        } catch {
            self.showErrorAlert(with: error as? DMError ?? .unknown(error))
        }
    }

    private func setAppLanguage(languageCode: String, needShowAlert: Bool = true) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        if needShowAlert {
            showSuccessAlert(with: "Please restart the app to apply the language change.")
        }
    }
}

extension AppSettings {
    static var preview: AppSettings {
        let repository = DefaultSettingsRepository(
            settingsStorage: SettingsUserDefaultStorage(
                userDefaultCoordinator: UserDefaultCoordinator(
                    userDefaults: InMemoryUserDefaultsCoordinator()
                )
            )
        )
        let dependencies = Dependencies(
            fetchSettingUseCaseFactory: {
                FetchSettingsUseCase(repository: repository)
            }, updateSettingUseCaseFactory: {
                UpdateSettingsUseCase(repository: repository)
            }
        )
        return AppSettings(dependencies: dependencies)
    }
}
