//
//  TransCategoryDetailView.swift
//  ZMoney
//
//  Created by Chien Pham on 23/08/2024.
//

import SwiftUI

struct TransCategoryDetailView: View {
    @ObservedObject var viewModel: TransCategoryDetailViewModel

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Category Details")) {
                    HStack {
                        Text("Name")
                            .fontWeight(.semibold)
                        TextField("Category name", text: $viewModel.model.name)
                    }

                    ColorPicker(selection: Binding(
                        get: { Color(hex: viewModel.model.color) },
                        set: { newColor in viewModel.model.color = newColor.hexString }
                    ), label: {
                        Text("Icon")
                            .fontWeight(.semibold)
                    })

                    IconPickerView(
                        selectedIcon: $viewModel.model.icon,
                        selectedColor: Binding(
                            get: { Color(hex: viewModel.model.color) },
                            set: { newColor in viewModel.model.color = newColor.hexString }
                        ),
                        icons: viewModel.iconList,
                        iconSize: .init(width: 36, height: 20),
                        numberOfColums: 5,
                        spacing: 8
                    )
                    .padding(.vertical, 8)
                    .frame(maxHeight: 200)
                }

                Button {
                    viewModel.save()
                } label: {
                    Text("Save")
                        .foregroundColor(.white)
                        .padding(.vertical, 2)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(8)
                }
                .disabled(!viewModel.isSaveEnabled)
                .listRowBackground(viewModel.isSaveEnabled ? Color.blue : Color.gray)
            }
        }
        .navigationBarTitle(viewModel.model.name.isEmpty ? "New" : "Edit", displayMode: .inline)
    }
}
