//
//  CategoriesListView.swift
//  Presentation
//
//  Created by Chien Pham on 20/08/2024.
//

import SwiftUI
import DataModule

struct CategoriesListView<ViewModel: CategoriesListViewModel>: View {
    @ObservedObject private var viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    private var items: [CategoriesListItemModel] {
        viewModel.selectedTab == .expense
        ? viewModel.expenseItems
        : viewModel.incomeItems
    }

    public var body: some View {
        VStack {
            HStack {
                Picker("Tab", selection: $viewModel.selectedTab) {
                    ForEach(CategoryTab.allCases) {
                        Text($0.localizedStringKey)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal, 20)

            List {
                Section {
                    Button {
                        viewModel.addCategory()
                    } label: {
                        Text("Add category")
                            .withRightArrow()
                    }
                }
                Section {
                    ForEach(items, id: \.id) { category in
                        HStack {
                            Button {
                                viewModel.didSelectItem(category)
                            } label: {
                                HStack {
                                    Image(systemName: category.icon)
                                        .foregroundColor(Color(hex: category.iconColor))
                                        .frame(width: 20, height: 20)
                                    Text(LocalizedStringKey(category.name))
                                        .foregroundColor(.primary)
                                        .withRightArrow()
                                }
                            }
                        }
                    }
                    .onMove { sourceIndexSet, newOffset in
                        Task {
                            print("move indice: \(sourceIndexSet), newOffset: \(newOffset)")
                            await viewModel.moveItems(from: sourceIndexSet, to: newOffset)
                        }
                    }
                    .onDelete { indexSet in
                        Task {
                            await viewModel.deleteItem(at: indexSet)
                        }
                    }
                }
            }
            .listStyle(DefaultListStyle())
        }
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: EditButton())
        .resultAlert(alertData: $viewModel.alertData)
        .task {
            await viewModel.refreshData()
        }
    }
}

#Preview {
    CategoriesListView(viewModel: .makePreviewViewModel())
}
