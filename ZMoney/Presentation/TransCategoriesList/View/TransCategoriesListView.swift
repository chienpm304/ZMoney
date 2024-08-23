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

    private var items: [TransCategoriesListItemModel] {
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
                        viewModel.addNewCategory()
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
                                    Text(category.name)
                                        .foregroundColor(.primary)
                                        .withRightArrow()
                                }
                            }
                        }
                    }
                    .onMove { sourceIndexSet, newOffset in
                        print("move indice: \(sourceIndexSet), newOffset: \(newOffset)")
                        viewModel.moveItems(from: sourceIndexSet, to: newOffset)
                    }
                    .onDelete { indexSet in
                        viewModel.deleteItem(at: indexSet)
                    }
                }
            }
            .listStyle(DefaultListStyle())
        }
        .navigationTitle("Categories")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: EditButton())
        #if DEBUG
        .navigationBarItems(leading: Button("Refresh", action: viewModel.refresh))
        #endif
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
