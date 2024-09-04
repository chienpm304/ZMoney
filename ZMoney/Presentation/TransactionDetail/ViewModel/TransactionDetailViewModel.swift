//
//  TransactionDetailViewModel.swift
//  ZMoney
//
//  Created by Chien Pham on 03/09/2024.
//

import DomainModule

struct TransactionDetailViewModelActions {
    let editCategoriesList: () -> Void
    let notifyDidSavedTransactionDetail: (DMTransaction) -> Void
}

class TransactionDetailViewModel: ObservableObject {
    struct Dependencies {
        let actions: TransactionDetailViewModelActions
        let fetchCategoriesUseCaseFactory: FetchCategoriesUseCaseFactory
        let transactionsUseCaseFactory: TransactionsUseCaseFactory
    }

    @Published var transaction: TransactionDetailModel
    @Published var isNewTransaction: Bool
    private let originalTransaction: TransactionDetailModel?
    private let dependencies: Dependencies

    private var categories: [DMCategory] = []
    private var isFetching = false

    init(
        transaction: DMTransaction? = nil,
        inputDate: Date? = nil,
        dependencies: Dependencies
    ) {
        self.dependencies = dependencies
        if let transaction = transaction {
            let detailModel = TransactionDetailModel(transaction: transaction)
            self.transaction = detailModel
            self.isNewTransaction = false
            self.originalTransaction = detailModel
        } else {
            self.transaction = TransactionDetailModel.defaultTransaction(inputDate: inputDate ?? .now)
            self.isNewTransaction = true
            self.originalTransaction = nil
        }
        fetchCategoriesList()
    }

    var isSaveEnabled: Bool {
        transaction.amount > 0 && (isNewTransaction || isModified)
    }

    var allowChangeTransactionType: Bool { isNewTransaction }

    var filteredCategories: [CategoryDetailModel] {
        categories.filter {
            $0.type == transaction.transactionType.domainType
        }
        .map(CategoryDetailModel.init)
    }

    func onViewAppear() {
        fetchCategoriesList()
    }

    func save() {
        // Handle saving logic here, including creating a new DMTransaction from TransactionDetailModel
        // For new transactions, ensure the transactionType is properly applied to the selected category
    }

    func didTapEditCategory() {
        dependencies.actions.editCategoriesList()
    }

    // MARK: Private

    private var isModified: Bool {
        guard let originalTransaction = originalTransaction else { return true }

        return transaction.amount != originalTransaction.amount
        || transaction.inputTime != originalTransaction.inputTime
        || transaction.memo != originalTransaction.memo
        || transaction.category.id != originalTransaction.category.id
    }

    private var fetchCategoriesUseCase: UseCase?

    private func fetchCategoriesList() {
        guard isFetching == false else { return }
        isFetching = true
        let completion: (Result<[DMCategory], Error>) -> Void = { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.isFetching = false
                switch result {
                case .success(let categories):
                    self.categories = categories
                    if self.isNewTransaction, let defaultCategory = self.filteredCategories.first {
                        self.transaction.category = defaultCategory
                    }
                case .failure(let error):
                    print("failed to fetch categories: \(error)")
                }
            }
        }

        let useCase = dependencies.fetchCategoriesUseCaseFactory(completion)
        fetchCategoriesUseCase = useCase // keep reference
        useCase.execute()
    }
}
