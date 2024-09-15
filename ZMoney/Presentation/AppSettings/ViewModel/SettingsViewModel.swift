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

typealias AppSettings = SettingsViewModel

struct SettingsViewModelActions {
    let didTapCategoies: () -> Void
}

final class SettingsViewModel: ObservableObject, AlertProvidable {
    struct Dependencies {
        let fetchSettingUseCaseFactory: FetchSettingsUseCaseFactory
        let updateSettingUseCaseFactory: UpdateSettingsUseCaseFactory
        var actions: SettingsViewModelActions
    }

    private let previousSettings: DMSettings = .defaultValue
    private var domainModel: DMSettings = .defaultValue
    @MainActor @Published var settings = SettingsModel(domain: .defaultValue)

    @Published var alertData: AlertData?

    private var dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
        Task {
            await fetchSettings()
        }
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
        domainModel = await fetchSettingsUseCase.execute(input: ())
        settings = SettingsModel(domain: domainModel)
    }

    @MainActor func updateSettings() async {
        guard settings.domain != domainModel else { return }
        do {
            let updateSettingsUseCase = dependencies.updateSettingUseCaseFactory()
            let input = UpdateSettingsUseCase.Input(settings: settings.domain)

            settings = SettingsModel(domain: try await updateSettingsUseCase.execute(input: input))

            if domainModel.language != settings.language {
                setAppLanguage(languageCode: settings.language.languageCode)
            } else {
                showSuccessAlert(with: "Updated settings!")
            }

            domainModel = settings.domain
        } catch {
            showErrorAlert(with: error as? DMError ?? .unknown(error))
        }
    }

    @MainActor func didTapCategories() async {
        dependencies.actions.didTapCategoies()
    }

    private func setAppLanguage(languageCode: String, needShowAlert: Bool = true) {
        UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        if needShowAlert {
            showSuccessAlert(with: "Please restart the app to apply the language change.")
        }
    }

    func updateActions(_ actions: SettingsViewModelActions) {
        dependencies.actions = actions
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
            }, actions: SettingsViewModelActions(didTapCategoies: {
                print("did tap categories")
            })
        )
        return AppSettings(dependencies: dependencies)
    }
}
