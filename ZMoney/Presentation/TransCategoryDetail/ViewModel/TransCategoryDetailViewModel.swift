//
//  TransCategoryDetailViewModel.swift
//  ZMoney
//
//  Created by Chien Pham on 24/08/2024.
//

import Combine
import DomainModule

struct TransCategoryDetailViewModelActions {
    let notifyDidSavedCategory: (TransCategory) -> Void
}

class TransCategoryDetailViewModel: ObservableObject {
    struct Dependencies {
        let useCaseFactory: TransCategoriesUseCaseFactory
        let actions: TransCategoryDetailViewModelActions
    }

    @Published var model: TransCategoryDetailModel
    private let originalModel: TransCategoryDetailModel
    private let isNewCategory: Bool

    var iconList: [String] {
        IconResourceProvider.categoryIcons
    }

    // MARK: Dependencies
    private let dependencies: Dependencies

    init(category: TransCategory, isNewCategory: Bool, dependencies: Dependencies) {
        let detailModel = TransCategoryDetailModel(category: category)
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
        let requestValue = AddTransCategoriesUseCase.RequestValue(categories: [model.domain])
        let completion: (AddTransCategoriesUseCase.ResultValue) -> Void = { [weak self] result in
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
        let requestValue = UpdateTransCategoriesUseCase.RequestValue(
            categories: [model.domain],
            needUpdateSortOrder: false
        )
        let completion: (UpdateTransCategoriesUseCase.ResultValue) -> Void = { [weak self] result in
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
