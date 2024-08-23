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

final class TransCategoriesListViewModel: ObservableObject {
    private var expenseCategories: [TransCategory] = [] {
        didSet {
            expenseItems = expenseCategories.map(TransCategoriesListItemViewModel.init)
        }
    }
    private var incomeCategories: [TransCategory] = [] {
        didSet {
            incomeItems = incomeCategories.map(TransCategoriesListItemViewModel.init)
        }
    }

    private let fetchTransCategoriesUseCaseFactory: FetchTransCategoriesUseCaseFactory
    private let actions: TransCategoriesListViewModelActions?
    private var useCase: UseCase?

    // MARK: Output
    @Published var selectedTab: TransCategoryTab = .expense
    @Published var expenseItems: [TransCategoriesListItemViewModel] = []
    @Published var incomeItems: [TransCategoriesListItemViewModel] = []
    @Published var isEditting: Bool = false

    init(
        fetchTransCategoriesUseCaseFactory: @escaping FetchTransCategoriesUseCaseFactory,
        actions: TransCategoriesListViewModelActions?
    ) {
        self.fetchTransCategoriesUseCaseFactory = fetchTransCategoriesUseCaseFactory
        self.actions = actions
    }
}

// MARK: Input

extension TransCategoriesListViewModel {
    func onViewAppear() {
        let completion: (Result<[TransCategory], Error>) -> Void = { result in
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
        useCase = fetchTransCategoriesUseCaseFactory(completion)
        useCase?.execute()
    }

    func didSelectItem(at index: Int) {
        let categories = selectedTab == .expense ? expenseCategories : incomeCategories
        guard categories.indices.contains(index)
        else {
            assertionFailure()
            return
        }

        print(#function)
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

    func editItemsOrder() {
        isEditting.toggle()
    }
}
