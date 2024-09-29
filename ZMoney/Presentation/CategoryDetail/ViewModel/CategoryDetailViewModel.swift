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

@dynamicMemberLookup
class CategoryDetailViewModel: ObservableObject, AlertProvidable {
    struct Dependencies {
        let addUseCaseFactory: AddCategoriesUseCaseFactory
        let updateUseCaseFactory: UpdateCategoriesUseCaseFactory
        let actions: CategoryDetailViewModelActions
    }

    @Published var alertData: AlertData?
    @Published private var model: CategoryDetailModel
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

    // MARK: @dynamicMemberLookup

    subscript<T>(dynamicMember keyPath: WritableKeyPath<CategoryDetailModel, T>) -> T {
        get { model[keyPath: keyPath] }
        set { model[keyPath: keyPath] = newValue }
    }

    var isSaveEnabled: Bool {
        return isValidData && hasDataChanged
    }

    private var isValidData: Bool {
        !model.localizedName.isEmpty &&
        !model.icon.isEmpty
    }

    private var hasDataChanged: Bool {
        model.localizedName != originalModel.localizedName ||
        model.icon != originalModel.icon ||
        model.color != originalModel.color
    }

    @MainActor func save() async {
        if isNewCategory {
            await addCategory()
        } else {
            await updateCategory()
        }
    }

    @MainActor private func addCategory() async {
        do {
            let input = AddCategoriesUseCase.Input(categories: [model.domain])
            let addUseCase = dependencies.addUseCaseFactory()
            let categories = try await addUseCase.execute(input: input)
            guard let category = categories.first else {
                assertionFailure("Unknown error")
                return
            }
            print("Added category success: \(category)")
            dependencies.actions.notifyDidSavedCategory(category)
        } catch {
            print("Added category failed: \(error)")
            showErrorAlert(with: error as? DMError ?? .unknown(error))
        }
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
            addUseCaseFactory: {
                AddCategoriesUseCase(categoryRepository: categoriesRepository)
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
