//
//  SettingsView.swift
//  ZMoney
//
//  Created by Chien Pham on 02/09/2024.
//

import SwiftUI
import DomainModule

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        Form {
            Section("General settings") {
                Picker("Language", selection: $viewModel.settings.language) {
                    ForEach(DMLanguage.allCases) { language in
                        Text(language.displayName)
                            .tag(language)
                    }
                }

                Picker("Currency", selection: $viewModel.settings.currency) {
                    ForEach(DMCurrency.allCases) { currency in
                        Text(currency.displayName)
                            .tag(currency)
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .resultAlert(alertData: $viewModel.alertData)
    }
}

#Preview {
    SettingsView(viewModel: .preview)
}
