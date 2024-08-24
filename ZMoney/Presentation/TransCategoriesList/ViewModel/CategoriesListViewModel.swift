//
//  CategoriesListViewModel.swift
//  ZMoney
//
//  Created by Chien Pham on 22/08/2024.
//

import Foundation
import DomainModule
import Combine
import DataModule

struct CategoriesListViewModelActions {
    let editCategoryDetail: (DMCategory) -> Void
    let addCategoryDetail: (DMTransactionType) -> Void
}

final class CategoriesListViewModel: ObservableObject {
    struct Dependencies {
        let useCaseFactory: CategoriesUseCaseFactory
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

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: Input
extension CategoriesListViewModel {
    func onViewAppear() {
        let completion: (Result<[DMCategory], Error>) -> Void = { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self.expenseCategories = categories.filter { $0.type == .expense }
                    self.incomeCategories = categories.filter { $0.type == .income }
                case .failure(let error):
                    print("failed to fetch categories: \(error)")
                }
            }
        }

        let useCase = dependencies.useCaseFactory.fetchUseCase(completion)
        useCase.execute()
        fetchUseCase = useCase // keep reference
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

    func addCategory() {
        dependencies.actions?.addCategoryDetail(selectedTab.domainType)
    }

    func moveItems(from source: IndexSet, to newOffset: Int) {
        var updatedCategories: [DMCategory]
        if selectedTab == .expense {
            updatedCategories = expenseCategories
        } else {
            updatedCategories = incomeCategories
        }
        updatedCategories.move(fromOffsets: source, toOffset: newOffset)

        let requestValue = UpdateCategoriesUseCase.RequestValue(
            categories: updatedCategories,
            needUpdateSortOrder: true
        )
        let completion: (UpdateCategoriesUseCase.ResultValue) -> Void = { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    if self.selectedTab == .expense {
                        self.expenseCategories = categories
                    } else {
                        self.incomeCategories = categories
                    }
                case .failure(let error):
                    print("failed to move categories: \(error)")
                }
            }
        }
        let updateUseCase = dependencies.useCaseFactory.updateUseCase(requestValue, completion)
        updateUseCase.execute()
    }

    func deleteItem(at index: IndexSet) {
        let toUpdateCategories: [DMCategory]
        if selectedTab == .expense {
            toUpdateCategories = expenseCategories
        } else {
            toUpdateCategories = incomeCategories
        }

        let toDeleteIDs = index.map { toUpdateCategories[$0].id }

        let requestValue = DeleteCategoriesUseCase.RequestValue(categoryIDs: toDeleteIDs)
        let completion: (DeleteCategoriesUseCase.ResultValue) -> Void = { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let deletedCategories):
                    let deletedIDs = deletedCategories.map { $0.id }
                    if self.selectedTab == .expense {
                        self.expenseCategories.removeAll { deletedIDs.contains($0.id) }
                    } else {
                        self.incomeCategories.removeAll { deletedIDs.contains($0.id) }
                    }
                case .failure(let error):
                    print("failed to move categories: \(error)")
                }
            }
        }
        let deteleUseCase = dependencies.useCaseFactory.deleteUseCase(requestValue, completion)
        deteleUseCase.execute()
    }
}
