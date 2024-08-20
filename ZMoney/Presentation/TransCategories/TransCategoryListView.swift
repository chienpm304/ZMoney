//
//  TransCategoryListView.swift
//  Presentation
//
//  Created by Chien Pham on 20/08/2024.
//

import SwiftUI

struct TransCategoryListView: View {

    public var body: some View {
        List(1...100, id: \.self) { index in
            Text("Hello \(index)")
                .background(.green)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)

    }
}

#Preview {
    NavigationView {
        TransCategoryListView()
            .navigationTitle("Hello")
    }
}
