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
                Picker("Language", selection: $viewModel.language) {
                    ForEach(DMLanguage.allCases) { language in
                        Text(language.displayName)
                            .tag(language)
                    }
                }

                Picker("Currency", selection: $viewModel.currency) {
                    ForEach(DMCurrency.allCases) { currency in
                        Text(currency.displayName)
                            .tag(currency)
                    }
                }
            }

            Section {
                Button {
                    Task {
                        await viewModel.didTapCategories()
                    }
                } label: {
                    Text("Categories")
                }
                .withRightArrow()
                .foregroundStyle(Color.primary)
            }
        }
        .onChange(of: viewModel.settings) { _ in
            Task {
                await viewModel.updateSettings()
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
        .resultAlert(alertData: $viewModel.alertData)
        .task {
            await viewModel.fetchSettings()
        }
    }
}

#Preview {
    SettingsView(viewModel: .preview)
}
