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
    let addCategoryDetail: (DMTransactionType) -> Void
}

final class CategoriesListViewModel: ObservableObject, AlertProvidable {
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
    @Published var alertData: AlertData?

    init(dependencies: Dependencies) {
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

        let useCase = dependencies.useCaseFactory.fetchUseCase(completion)
        useCase.execute()
        fetchUseCase = useCase // keep reference
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
                    self.showErrorAlert(with: error)
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
                    switch error {
                    case .notFound:
                        print("delete category error: NOT FOUND")
                    case .violateRelationshipConstraint:
                        print("delete category denied: \(error.localizedDescription)")
                    default:
                        print("delete category error: \(error)")
                    }
                    self.showErrorAlert(with: error)
                }
            }
        }
        let deteleUseCase = dependencies.useCaseFactory.deleteUseCase(requestValue, completion)
        deteleUseCase.execute()
    }
}

// MARK: Previews

import DataModule

extension CategoriesListViewModel {
    static func makePreviewViewModel() -> CategoriesListViewModel {
        let categoriesStorage: CategoryStorage = CategoryCoreDataStorage(coreData: .testInstance)
        let categoriesRepository: CategoryRepository = DefaultCategoryRepository(storage: categoriesStorage)

        let factory = CategoriesUseCaseFactory { fetchCompletion in
            FetchCategoriesUseCase(categoryRepository: categoriesRepository, completion: fetchCompletion)
        } addUseCase: { addRequest, addCompletion in
            AddCategoriesUseCase(
                requestValue: addRequest,
                categoryRepository: categoriesRepository,
                completion: addCompletion
            )
        } updateUseCase: { updateRequest, updateCompletion in
            UpdateCategoriesUseCase(
                requestValue: updateRequest,
                categoryRepository: categoriesRepository,
                completion: updateCompletion
            )
        } deleteUseCase: { deleteRequest, deleteCompletion in
            DeleteCategoriesUseCase(
                requestValue: deleteRequest,
                categoryRepository: categoriesRepository,
                completion: deleteCompletion
            )
        }

        let actions = CategoriesListViewModelActions { editCategory in
            print("[Preview] Edit category \(editCategory.name)")
        } addCategoryDetail: { addCategoryType in
            print("[Preview] Add \(addCategoryType)")
        }

        let dependencies = Dependencies(useCaseFactory: factory, actions: actions)
        return CategoriesListViewModel(dependencies: dependencies)
    }
}
