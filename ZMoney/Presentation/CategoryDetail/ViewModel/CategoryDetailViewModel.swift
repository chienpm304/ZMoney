//
//  CategoryDetailViewModel.swift
//  ZMoney
//
//  Created by Chien Pham on 24/08/2024.
//

import Combine
import DomainModule

struct CategoryDetailViewModelActions {
    let notifyDidSavedCategory: (DMCategory) -> Void
}

class CategoryDetailViewModel: ObservableObject {
    struct Dependencies {
        let useCaseFactory: CategoriesUseCaseFactory
        let actions: CategoryDetailViewModelActions
    }

    @Published var model: CategoryDetailModel
    private let originalModel: CategoryDetailModel
    private let isNewCategory: Bool
    private let dependencies: Dependencies

    var iconList: [String] {
        IconResourceProvider.categoryIcons
    }

    init(
        category: DMCategory,
        isNewCategory: Bool,
        dependencies: Dependencies
    ) {
        let detailModel = CategoryDetailModel(category: category)
        self.originalModel = detailModel
        self.model = detailModel
        self.dependencies = dependencies
        self.isNewCategory = isNewCategory
    }

    var isSaveEnabled: Bool {
        return isValidData && hasDataChanged
    }

    private var isValidData: Bool {
        !model.name.isEmpty &&
        !model.icon.isEmpty &&
        !model.color.isEmpty
    }

    private var hasDataChanged: Bool {
        model.name != originalModel.name ||
        model.icon != originalModel.icon ||
        model.color != originalModel.color
    }

    func save() {
        if isNewCategory {
            addCategory()
        } else {
            updateCategory()
        }
    }

    private func addCategory() {
        let requestValue = AddCategoriesUseCase.RequestValue(categories: [model.domain])
        let completion: (AddCategoriesUseCase.ResultValue) -> Void = { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    guard let category = categories.first else {
                        assertionFailure("Unknown error")
                        return
                    }
                    print("Added category success: \(category)")
                    self.dependencies.actions.notifyDidSavedCategory(category)
                case .failure(let error):
                    print("Added category failed: \(error)")
                }
            }
        }
        let addUseCase = dependencies.useCaseFactory.addUseCase(requestValue, completion)
        addUseCase.execute()
    }

    private func updateCategory() {
        let requestValue = UpdateCategoriesUseCase.RequestValue(
            categories: [model.domain],
            needUpdateSortOrder: false
        )
        let completion: (UpdateCategoriesUseCase.ResultValue) -> Void = { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    guard let category = categories.first else {
                        assertionFailure("Unknown error")
                        return
                    }
                    print("Updated category success: \(category)")
                    self.dependencies.actions.notifyDidSavedCategory(category)

                case .failure(let error):
                    print("Updated category failed: \(error)")
                }
            }
        }
        let updateUseCase = dependencies.useCaseFactory.updateUseCase(requestValue, completion)
        updateUseCase.execute()
    }
}
