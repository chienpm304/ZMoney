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
    let showTransCategoreDetail: (TransCategory) -> Void
}

typealias FetchTransCategoriesUseCaseFactory = (
    @escaping (FetchTransCategoriesUseCase.ResultValue) -> Void
) -> UseCase

typealias UpdateTransCategoriesUseCaseFactory = (
    UpdateTransCategoriesUseCase.RequestValue,
    @escaping (UpdateTransCategoriesUseCase.ResultValue) -> Void
) -> UseCase

final class TransCategoriesListViewModel: ObservableObject {
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
    private let fetchTransCategoriesUseCaseFactory: FetchTransCategoriesUseCaseFactory
    private let updateTransCategoriesUseCaseFactory: UpdateTransCategoriesUseCaseFactory
    private let actions: TransCategoriesListViewModelActions?
    private var fetchUseCase: UseCase?
    
    // MARK: Output
    @Published var selectedTab: TransCategoryTab = .expense
    @Published var expenseItems: [TransCategoriesListItemModel] = []
    @Published var incomeItems: [TransCategoriesListItemModel] = []
    
    init(
        fetchTransCategoriesUseCaseFactory: @escaping FetchTransCategoriesUseCaseFactory,
        updateTransCategoriesUseCaseFactory: @escaping UpdateTransCategoriesUseCaseFactory,
        actions: TransCategoriesListViewModelActions?
    ) {
        self.fetchTransCategoriesUseCaseFactory = fetchTransCategoriesUseCaseFactory
        self.updateTransCategoriesUseCaseFactory = updateTransCategoriesUseCaseFactory
        self.actions = actions
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
        
        let useCase = fetchTransCategoriesUseCaseFactory(completion)
        useCase.execute()
        fetchUseCase = useCase // keep reference
    }
    
    func didSelectItem(at index: Int) {
        let categories = selectedTab == .expense ? expenseCategories : incomeCategories
        guard categories.indices.contains(index)
        else {
            assertionFailure()
            return
        }
        actions?.showTransCategoreDetail(categories[index])
    }
    
    func switchTransCategoryTab() {
        if selectedTab == .expense {
            selectedTab = .income
        } else {
            selectedTab = .expense
        }
    }
    
    func addNewCategory() {
        print(#function)
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
        let updateUseCase = updateTransCategoriesUseCaseFactory(requestValue, completion)
        updateUseCase.execute()
    }
}
