//
//  TransCategoriesListViewModel.swift
//  ZMoney
//
//  Created by Chien Pham on 22/08/2024.
//

import Foundation
import DomainModule
import Combine
import DataModule

struct TransCategoriesListViewModelActions {
    let editTransCategoryDetail: (TransCategory) -> Void
    let addTransCategoryDetail: (TransType) -> Void
}

final class TransCategoriesListViewModel: ObservableObject {
    struct Dependencies {
        let useCaseFactory: TransCategoriesUseCaseFactory
        let actions: TransCategoriesListViewModelActions?
    }

    // MARK: Domain
    private var expenseCategories: [TransCategory] = [] {
        didSet {
            expenseItems = expenseCategories.map(TransCategoriesListItemModel.init)
        }
    }
    private var incomeCategories: [TransCategory] = [] {
        didSet {
            incomeItems = incomeCategories.map(TransCategoriesListItemModel.init)
        }
    }

    // MARK: Dependencies
    private let dependencies: Dependencies
    private var fetchUseCase: UseCase?

    // MARK: Output
    @Published var selectedTab: TransCategoryTab = .expense
    @Published var expenseItems: [TransCategoriesListItemModel] = []
    @Published var incomeItems: [TransCategoriesListItemModel] = []

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

// MARK: Input
extension TransCategoriesListViewModel {
    func onViewAppear() {
        let completion: (Result<[TransCategory], Error>) -> Void = { [weak self] result in
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

    func didSelectItem(_ item: TransCategoriesListItemModel) {
        let categories = selectedTab == .expense ? expenseCategories : incomeCategories
        guard let category = categories.first(where: { $0.id == item.id })
        else {
            assertionFailure()
            return
        }
        dependencies.actions?.editTransCategoryDetail(category)
    }

    func switchTransCategoryTab() {
        if selectedTab == .expense {
            selectedTab = .income
        } else {
            selectedTab = .expense
        }
    }

    func addTransCategory() {
        dependencies.actions?.addTransCategoryDetail(selectedTab.domainType)
    }

    func moveItems(from source: IndexSet, to newOffset: Int) {
        var updatedCategories: [TransCategory]
        if selectedTab == .expense {
            updatedCategories = expenseCategories
        } else {
            updatedCategories = incomeCategories
        }
        updatedCategories.move(fromOffsets: source, toOffset: newOffset)

        let requestValue = UpdateTransCategoriesUseCase.RequestValue(
            categories: updatedCategories,
            needUpdateSortOrder: true
        )
        let completion: (UpdateTransCategoriesUseCase.ResultValue) -> Void = { result in
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
        let toUpdateCategories: [TransCategory]
        if selectedTab == .expense {
            toUpdateCategories = expenseCategories
        } else {
            toUpdateCategories = incomeCategories
        }

        let toDeleteIDs = index.map { toUpdateCategories[$0].id }

        let requestValue = DeleteTransCategoriesUseCase.RequestValue(categoryIDs: toDeleteIDs)
        let completion: (DeleteTransCategoriesUseCase.ResultValue) -> Void = { result in
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
