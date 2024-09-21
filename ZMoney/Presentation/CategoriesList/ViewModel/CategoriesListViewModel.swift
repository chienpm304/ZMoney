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
            expenseItems = expenseCategories.map(CategoriesListItemModel.init)
        }
    }
    private var incomeCategories: [DMCategory] = [] {
        didSet {
            incomeItems = incomeCategories.map(CategoriesListItemModel.init)
        }
    }

    // MARK: Dependencies
    private let dependencies: Dependencies
    private var fetchUseCase: UseCase?

    // MARK: Output
    @Published var selectedTab: CategoryTab = .expense
    @Published var expenseItems: [CategoriesListItemModel] = []
    @Published var incomeItems: [CategoriesListItemModel] = []
    @Published var alertData: AlertData?

    init(selectedType: DMTransactionType, dependencies: Dependencies) {
        self.selectedTab = selectedType.toViewModel
        self.dependencies = dependencies
    }
}

// MARK: Input
extension CategoriesListViewModel {
    func onViewAppear() {
        refreshCategories()
    }

    func didSelectItem(_ item: CategoriesListItemModel) {
        let categories = selectedTab == .expense ? expenseCategories : incomeCategories
        guard let category = categories.first(where: { $0.id == item.id })
        else {
            assertionFailure()
            return
        }
        dependencies.actions?.editCategoryDetail(category)
    }

    func refreshCategories() {
        let completion: (Result<[DMCategory], DMError>) -> Void = { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self.expenseCategories = categories.filter { $0.type == .expense }
                    self.incomeCategories = categories.filter { $0.type == .income }
                case .failure(let error):
                    self.showErrorAlert(with: error)
                }
                self.fetchUseCase = nil
            }
        }

        let useCase = dependencies.fetchUseCaseFactory(completion)
        useCase.execute()
        fetchUseCase = useCase // keep reference
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
            let _ = try await updateUseCase.execute(input: input)
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
            fetchUseCaseFactory: { fetchCompletion in
                FetchCategoriesUseCase(categoryRepository: categoriesRepository, completion: fetchCompletion)
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
