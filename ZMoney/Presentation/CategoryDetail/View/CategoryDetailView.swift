//
//  CategoryDetailView.swift
//  ZMoney
//
//  Created by Chien Pham on 23/08/2024.
//

import SwiftUI

struct CategoryDetailView: View {
    @ObservedObject var viewModel: CategoryDetailViewModel

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Category Details")) {
                    HStack {
                        Text("Name")
                            .fontWeight(.medium)
                        TextField("Category name", text: $viewModel.model.name)
                            .withFieldBackground()
                    }

                    ColorPicker(selection: $viewModel.model.color, supportsOpacity: false) {
                        Text("Icon")
                            .fontWeight(.medium)
                    }

                    IconPickerView(
                        axis: .horizontal,
                        axisCount: 4,
                        spacing: 8,
                        icons: viewModel.iconList,
                        iconSize: .init(width: 40, height: 30),
                        selectedIcon: $viewModel.model.icon,
                        selectedColor: $viewModel.model.color
                    )
                }

                Button {
                    viewModel.save()
                } label: {
                    Text("Save")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                }
                .disabled(!viewModel.isSaveEnabled)
                .listRowBackground(
                    viewModel.isSaveEnabled
                    ? Color.accentColor
                    : Color.accentColor.opacity(0.5)
                )
            }
            .navigationBarTitle(viewModel.navigationTitle, displayMode: .inline)
        }
    }
}

#if targetEnvironment(simulator)
#Preview {
    NavigationView {
        TabView {
            CategoryDetailView(viewModel: .makePreviewViewModel(isNewCategory: true, isExpense: true))
                .tabItem {
                    Label("Add expense", systemImage: "doc.fill.badge.plus")
                }

            CategoryDetailView(viewModel: .makePreviewViewModel(isNewCategory: true, isExpense: false))
                .tabItem {
                    Label("Add income", systemImage: "doc.fill.badge.plus")
                }

            CategoryDetailView(viewModel: .makePreviewViewModel(isNewCategory: false, isExpense: true))
                .tabItem {
                    Label("Edit expense", systemImage: "pencil")
                }
            CategoryDetailView(viewModel: .makePreviewViewModel(isNewCategory: false, isExpense: false))
                .tabItem {
                    Label("Edit income", systemImage: "pencil")
                }
        }
    }
}
#endif
