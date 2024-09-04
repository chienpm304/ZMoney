//
//  TransactionDetailViewModel.swift
//  ZMoney
//
//  Created by Chien Pham on 03/09/2024.
//

import DomainModule

struct TransactionDetailViewModelActions {
    let editCategoriesList: () -> Void
    let notifyDidSaveTransactionDetail: (DMTransaction) -> Void
    let notifyDidCancelTransactionDetail: () -> Void
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
        transaction.amount > 0
        && !transaction.category.isPlaceholder
        && (isNewTransaction || isModified)
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

    func cancel() {
        dependencies.actions.notifyDidCancelTransactionDetail()
    }

    func save() {
        if isNewTransaction {
            addTransaction()
        } else {
            updateTransaction()
        }
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

    private func setupDataModel(categories: [DMCategory]) {
        self.categories = categories

        if isNewTransaction, transaction.category.isPlaceholder,
            let defaultCategory = filteredCategories.first {
            transaction.category = defaultCategory
            transaction.category.isPlaceholder = false
        }
    }

    private func fetchCategoriesList() {
        guard !isFetching else {
            return
        }
        isFetching = true

        let completion: (Result<[DMCategory], Error>) -> Void = { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self.setupDataModel(categories: categories)
                case .failure(let error):
                    print("failed to fetch categories: \(error)")
                }
                self.isFetching = false
                self.fetchCategoriesUseCase = nil
            }
        }

        let useCase = dependencies.fetchCategoriesUseCaseFactory(completion)
        fetchCategoriesUseCase = useCase // keep reference
        useCase.execute()
    }

    private func addTransaction() {
        let requestValue = AddTransactionsUseCase.RequestValue(
            transactions: [transaction.domain]
        )
        let completion: (AddTransactionsUseCase.ResultValue) -> Void = { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let transactions):
                    guard let transaction = transactions.first else {
                        assertionFailure("Unknown error")
                        return
                    }
                    print("Added transaction success: \(transaction)")
                    self.dependencies.actions.notifyDidSaveTransactionDetail(transaction)
                case .failure(let error):
                    print("Added transaction failed: \(error)")
                }
            }
        }
        let addUseCase = dependencies.transactionsUseCaseFactory.addUseCase(requestValue, completion)
        addUseCase.execute()
    }

    private func updateTransaction() {
        let requestValue = UpdateTransactionsUseCase.RequestValue(
            transactions: [transaction.domain]
        )
        let completion: (UpdateTransactionsUseCase.ResultValue) -> Void = { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let transactions):
                    guard let transaction = transactions.first else {
                        assertionFailure("Unknown error")
                        return
                    }
                    print("Updated transaction success: \(transaction)")
                    self.dependencies.actions.notifyDidSaveTransactionDetail(transaction)

                case .failure(let error):
                    print("Updated transaction failed: \(error)")
                }
            }
        }
        let updateUseCase = dependencies.transactionsUseCaseFactory.updateUseCase(requestValue, completion)
        updateUseCase.execute()
    }
}
