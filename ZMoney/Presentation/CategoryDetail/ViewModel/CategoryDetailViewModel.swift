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

final class CategoryDetailViewModel: ObservableObject, AlertProvidable {
    struct Dependencies {
        let addUseCaseFactory: AddCategoriesUseCaseFactory
        let updateUseCaseFactory: UpdateCategoriesUseCaseFactory
        let actions: CategoryDetailViewModelActions
    }

    @Published var alertData: AlertData?
    @Published var model: CategoryDetailModel
    private let originalModel: CategoryDetailModel
    let isNewCategory: Bool
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
        !model.icon.isEmpty
    }

    private var hasDataChanged: Bool {
        model.name != originalModel.name ||
        model.icon != originalModel.icon ||
        model.color != originalModel.color
    }

    @MainActor func save() async {
        if isNewCategory {
            addCategory()
        } else {
            await updateCategory()
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
        let addUseCase = dependencies.addUseCaseFactory(requestValue, completion)
        addUseCase.execute()
    }

    @MainActor private func updateCategory() async {
        do {
            let input = UpdateCategoriesUseCase.Input(
                categories: [model.domain],
                needUpdateSortOrder: false
            )
            let updateUseCase = dependencies.updateUseCaseFactory()
            let categories = try await updateUseCase.execute(input: input)
            guard let category = categories.first else {
                assertionFailure("Unknown error")
                return
            }
            print("Updated category success: \(category)")
            dependencies.actions.notifyDidSavedCategory(category)
        } catch {
            print("Updated category failed: \(error)")
            showErrorAlert(with: error as? DMError ?? .unknown(error))
        }
    }
}

// MARK: Previews

import DataModule

extension CategoryDetailViewModel {
    static private func makePreviewCategory(isNewCategory: Bool, isExpense: Bool) -> DMCategory {
        if (isNewCategory) {
            return DMCategory(type: isExpense ? .expense : .income)
        } else {
            return .preview(type: isExpense ? .expense : .income)
        }
    }

    static func makePreviewViewModel(isNewCategory: Bool, isExpense: Bool) -> CategoryDetailViewModel {
        let actions = CategoryDetailViewModelActions { category in
            print("[Preview] Finished add/update category: \(category)")
        }
        let categoriesStorage: CategoryStorage = CategoryCoreDataStorage(coreData: .testInstance)
        let categoriesRepository: CategoryRepository = DefaultCategoryRepository(storage: categoriesStorage)
        let category = makePreviewCategory(isNewCategory: isNewCategory, isExpense: isExpense)
        let dependencies = Dependencies(
            addUseCaseFactory: { addRequest, addCompletion in
                AddCategoriesUseCase(
                    requestValue: addRequest,
                    categoryRepository: categoriesRepository,
                    completion: addCompletion
                )
            }, updateUseCaseFactory: {
                UpdateCategoriesUseCase(categoryRepository: categoriesRepository)
            }, actions: actions
        )
        return CategoryDetailViewModel(
            category: category,
            isNewCategory: isNewCategory,
            dependencies: dependencies
        )
    }
}
