//
//  AppSettingsView.swift
//  ZMoney
//
//  Created by Chien Pham on 02/09/2024.
//

import SwiftUI
import DomainModule

struct AppSettingsView: View {
    @ObservedObject var appSettings: AppSettings

    var body: some View {
        Form {
            Section("General settings") {
                Picker("Language", selection: $appSettings.language) {
                    ForEach(DMLanguage.allCases) { language in
                        Text(language.displayName)
                            .tag(language)
                    }
                }

                Picker("Currency", selection: $appSettings.currency) {
                    ForEach(DMCurrency.allCases) { currency in
                        Text(currency.displayName)
                            .tag(currency)
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    AppSettingsView(appSettings: AppConfiguration().settings)
}
