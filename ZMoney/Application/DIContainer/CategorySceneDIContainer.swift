//
//  CategorySceneDIContainer.swift
//  ZMoney
//
//  Created by Chien Pham on 19/08/2024.
//

import Foundation
import DataStore
import Domain

final class CategorySceneDIContainer {
    struct Dependencies {

    }

    private let dependencies: Dependencies
//    lazy var categoryStorage: TransCategoryStorage = TransCategoryCoreDataStorage()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

}
