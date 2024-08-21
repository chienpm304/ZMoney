//
//  TransCategoriesListView.swift
//  Presentation
//
//  Created by Chien Pham on 20/08/2024.
//

import SwiftUI
import DataModule
import DomainModule

struct TransCategoriesListView: View {
    private let transCategoryStorage: TransCategoryStorage
    @State private var useCase: FetchTransCategoriesUseCase?
    @State private var expenseCategories: [TransCategory] = []
    @State private var incomeCategories: [TransCategory] = []
    @State private var selectedTab: TransCategoryTab = .expense
    @State private var isEditing = false

    private var items: [TransCategory] {
        selectedTab == .expense ? expenseCategories : incomeCategories
    }

    init(transCategoryStorage: TransCategoryStorage) {
        self.transCategoryStorage = transCategoryStorage
    }

    public var body: some View {
        VStack {
            HStack {
                Picker("Tab", selection: $selectedTab) {
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
                                        .foregroundColor(Color(hex: category.color))
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
            if isEditing {
                Button {
                    print("tap done")
                    isEditing.toggle()
                } label: {
                    Text("Done")
                }
            } else {
                Button {
                    print("tap edit")
                    isEditing.toggle()
                } label: {
                    Text("Edit")
                }
            }
        }
        .onAppear {
            let completion: (Result<[TransCategory], Error>) -> Void = { result in
                if case .success(let categories) = result {
                    self.expenseCategories = categories.filter { $0.type == .expense }
                    self.incomeCategories = categories.filter { $0.type == .income }
                }
            }
            let repository = DefaultTransCategoryRepository(storage: transCategoryStorage)
            useCase = FetchTransCategoriesUseCase(
                completion: completion,
                categoryRepository: repository
            )
            _ = useCase?.start()
        }
    }
}

#Preview {
    NavigationView {
        TransCategoriesListView(transCategoryStorage: TransCategoryCoreDataStorage())
            .navigationTitle("Hello")
    }
}
