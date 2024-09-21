//
//  CategoriesListViewModel.swift
//  ZMoney
//
//  Created by Chien Pham on 22/08/2024.
//

import Foundation
import DomainModule
import Combine

struct CategoriesListViewModelActions {
    let editCategoryDetail: (DMCategory) -> Void
    let addCategoryDetail: (DMTransactionType, Index) -> Void
}

final class CategoriesListViewModel: ObservableObject, AlertProvidable {
    struct Dependencies {
        let fetchUseCaseFactory: FetchCategoriesUseCaseFactory
        let updateUseCaseFactory: UpdateCategoriesUseCaseFactory
        let deleteUseCaseFactory: DeleteCategoriesUseCaseFactory
        let actions: CategoriesListViewModelActions?
    }

    // MARK: Domain
    private var expenseCategories: [DMCategory] = [] {
        didSet {
            Task { @MainActor in
                expenseItems = expenseCategories.map(CategoriesListItemModel.init)
            }
        }
    }
    private var incomeCategories: [DMCategory] = [] {
        didSet {
            Task { @MainActor in
                incomeItems = incomeCategories.map(CategoriesListItemModel.init)
            }
        }
    }

    // MARK: Dependencies
    private let dependencies: Dependencies

    // MARK: Output
    @Published var selectedTab: CategoryTab = .expense
    @MainActor @Published var expenseItems: [CategoriesListItemModel] = []
    @MainActor @Published var incomeItems: [CategoriesListItemModel] = []
    @Published var alertData: AlertData?

    init(selectedType: DMTransactionType, dependencies: Dependencies) {
        self.selectedTab = selectedType.toViewModel
        self.dependencies = dependencies
    }
}

// MARK: Input
extension CategoriesListViewModel {
    func didSelectItem(_ item: CategoriesListItemModel) {
        let categories = selectedTab == .expense ? expenseCategories : incomeCategories
        guard let category = categories.first(where: { $0.id == item.id })
        else {
            assertionFailure()
            return
        }
        dependencies.actions?.editCategoryDetail(category)
    }

    @MainActor func refreshData() async {
        do {
            let useCase = dependencies.fetchUseCaseFactory()
            let categories = try await useCase.execute(input: ())
            expenseCategories = categories.filter { $0.type == .expense }
            incomeCategories = categories.filter { $0.type == .income }
        } catch {
            self.showErrorAlert(with: error as? DMError ?? .unknown(error))
        }
    }

    func addCategory() {
        let index = selectedTab == .expense ? expenseCategories.count : incomeCategories.count
        dependencies.actions?.addCategoryDetail(selectedTab.domainType, Index(index))
    }

    @MainActor func moveItems(from source: IndexSet, to newOffset: Int) async {
        let updatedCategories: [DMCategory]
        if selectedTab == .expense {
            expenseCategories.move(fromOffsets: source, toOffset: newOffset)
            updatedCategories = expenseCategories
        } else {
            incomeCategories.move(fromOffsets: source, toOffset: newOffset)
            updatedCategories = incomeCategories
        }

        do {
            let input = UpdateCategoriesUseCase.Input(
                categories: updatedCategories,
                needUpdateSortOrder: true
            )
            let updateUseCase = dependencies.updateUseCaseFactory()
            _ = try await updateUseCase.execute(input: input)
        } catch {
            self.showErrorAlert(with: error as? DMError ?? .unknown(error))
        }
    }

    @MainActor func deleteItem(at index: IndexSet) async {
        let toUpdateCategories: [DMCategory]
        if selectedTab == .expense {
            toUpdateCategories = expenseCategories
        } else {
            toUpdateCategories = incomeCategories
        }

        let toDeleteIDs = index.map { toUpdateCategories[$0].id }

        do {
            let input = DeleteCategoriesUseCase.Input(categoryIDs: toDeleteIDs)
            let deleteUseCase = dependencies.deleteUseCaseFactory()
            let deletedCategories = try await deleteUseCase.execute(input: input)
            let deletedIDs = deletedCategories.map { $0.id }
            if selectedTab == .expense {
                expenseCategories.removeAll { deletedIDs.contains($0.id) }
            } else {
                incomeCategories.removeAll { deletedIDs.contains($0.id) }
            }
        } catch {
            showErrorAlert(with: error as? DMError ?? .unknown(error))
        }
    }
}

// MARK: Previews

import DataModule

extension CategoriesListViewModel {
    static func makePreviewViewModel() -> CategoriesListViewModel {
        let categoriesStorage: CategoryStorage = CategoryCoreDataStorage(coreData: .testInstance)
        let categoriesRepository: CategoryRepository = DefaultCategoryRepository(storage: categoriesStorage)

        let actions = CategoriesListViewModelActions { editCategory in
            print("[Preview] Edit category \(editCategory.name)")
        } addCategoryDetail: { addCategoryType, index in
            print("[Preview] Add \(addCategoryType) at: \(index)")
        }

        let dependencies = Dependencies(
            fetchUseCaseFactory: {
                FetchCategoriesUseCase(categoryRepository: categoriesRepository)
            },
            updateUseCaseFactory: {
                UpdateCategoriesUseCase(categoryRepository: categoriesRepository)
            },
            deleteUseCaseFactory: {
                DeleteCategoriesUseCase(categoryRepository: categoriesRepository)
            },
            actions: actions
        )
        return CategoriesListViewModel(selectedType: .expense, dependencies: dependencies)
    }
}
