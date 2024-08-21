//
//  TransCategoryListView.swift
//  Presentation
//
//  Created by Chien Pham on 20/08/2024.
//

import SwiftUI
import DataModule

struct TransCategoryListView: View {
    private let transCategoryStorage: TransCategoryStorage

    init(transCategoryStorage: TransCategoryStorage) {
        self.transCategoryStorage = transCategoryStorage
    }

    public var body: some View {
        List(1...100, id: \.self) { index in
            Button("Item \(index)") {
                transCategoryStorage.fetchAllTransCategories { result in
                    switch result {
                    case .success(let categories):
                        print(categories)
                    case .failure(let error):
                        print("error: \(error)")
                    }
                }
            }
        }

    }
}

#Preview {
    NavigationView {
        TransCategoryListView(transCategoryStorage: TransCategoryCoreDataStorage())
            .navigationTitle("Hello")
    }
}
