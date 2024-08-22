//
//  TransCategoriesListView.swift
//  Presentation
//
//  Created by Chien Pham on 20/08/2024.
//

import SwiftUI
import DataModule
import DomainModule

struct TransCategoriesListView<ViewModel: TransCategoriesListViewModel>: View {
    @ObservedObject private var viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    private var items: [TransCategoriesListItemViewModel] {
        viewModel.selectedTab == .expense
        ? viewModel.expenseItems
        : viewModel.incomeItems
    }

    public var body: some View {
        VStack {
            HStack {
                Picker("Tab", selection: $viewModel.selectedTab) {
                    ForEach(TransCategoryTab.allCases) {
                        Text($0.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal, 20)

            List {
                Section {
                    Button {
                        print("add new category")
                    } label: {
                        Text("Add category")
                            .withRightArrow()
                    }
                }
                Section {
                    ForEach(items, id: \.id) { category in
                        HStack {
                            Button {
                                print("select item \(category.name)")
                            } label: {
                                HStack {
                                    Image(systemName: category.icon)
                                        .foregroundColor(Color(hex: category.iconColor))
                                        .frame(width: 20, height: 20)
                                    Text(category.name)
                                        .foregroundColor(.primary)
                                        .withRightArrow()
                                }
                            }
                        }
                    }
                }
            }
            .listStyle(DefaultListStyle())
        }
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if viewModel.isEditting {
                Button {
                    print("tap done")
                    viewModel.editItemsOrder()
                } label: {
                    Text("Done")
                }
            } else {
                Button {
                    print("tap edit")
                    viewModel.editItemsOrder()
                } label: {
                    Text("Edit")
                }
            }
        }
        .onAppear {
            viewModel.onViewAppear()
        }
    }
}

// #Preview {
//     NavigationView {
//         TransCategoriesListView(viewModel: <#TransCategoriesListViewModel#>)
//     }
// }
