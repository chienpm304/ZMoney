//
//  TransactionDetailViewModel.swift
//  ZMoney
//
//  Created by Chien Pham on 03/09/2024.
//

import DomainModule

struct TransactionDetailViewModelActions {
    let editCategoriesList: (DMTransactionType) -> Void
    let didUpdateTransactionDetail: (DMTransaction) -> Void
    let didCancelTransactionDetail: () -> Void
}

class TransactionDetailViewModel: ObservableObject, AlertProvidable {
    struct Dependencies {
        let actions: TransactionDetailViewModelActions
        let fetchCategoriesUseCaseFactory: FetchCategoriesUseCaseFactory
        let addTransactionsUseCaseFactory: AddTransactionsUseCaseFactory
        let updateTransactionsUseCaseFactory: UpdateTransactionsUseCaseFactory
        let deleteTransactionsUseCaseFactory: DeleteTransactionsUseCaseFactory
    }

    @Published var transaction: TransactionDetailModel
    @Published var isNewTransaction: Bool
    @Published var alertData: AlertData?
    private var originalTransaction: TransactionDetailModel?
    private let dependencies: Dependencies

    @Published private var categories: [DMCategory] = []
    private var isFetching = false

    init(
        forNewTransactionAt inputDate: Date? = nil,
        forEditTransaction transaction: DMTransaction? = nil,
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

    private func prepareForNextTransaction() {
        guard isNewTransaction else {
            assertionFailure("This method is meant to use for creatation only!")
            return
        }
        transaction.id = .generate()
        transaction.amount = 0
        transaction.memo = ""

        isNewTransaction = true
        originalTransaction = nil
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
        dependencies.actions.didCancelTransactionDetail()
    }

    func save() {
        if isNewTransaction {
            addTransaction()
        } else {
            updateTransaction()
        }
    }

    func delete() {
        guard !isNewTransaction else { return }
        deleteTransaction()
    }

    func didTapEditCategory() {
        let selectedType = transaction.transactionType.domainType
        dependencies.actions.editCategoriesList(selectedType)
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

        let completion: (Result<[DMCategory], DMError>) -> Void = { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let categories):
                    self.setupDataModel(categories: categories)
                case .failure(let error):
                    self.showErrorAlert(with: error)
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
                    self.prepareForNextTransaction()
                    self.dependencies.actions.didUpdateTransactionDetail(transaction)
                case .failure(let error):
                    print("Added transaction failed: \(error)")
                }
                self.showAlert(with: result, successMessage: "Transaction created")
            }
        }
        let addUseCase = dependencies.addTransactionsUseCaseFactory(requestValue, completion)
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
                        self.showErrorAlert(with: DMError.notFound)
                        return
                    }
                    print("Updated transaction success: \(transaction)")
                    self.dependencies.actions.didUpdateTransactionDetail(transaction)

                case .failure(let error):
                    print("Updated transaction failed: \(error)")
                }
                self.showAlert(with: result, successMessage: "Transaction updated")
            }
        }
        let updateUseCase = dependencies.updateTransactionsUseCaseFactory(requestValue, completion)
        updateUseCase.execute()
    }

    private func deleteTransaction() {
        let requestValue = DeleteTransactionsByIDsUseCase.RequestValue(
            transactionIDs: [transaction.id]
        )
        let completion: (DeleteTransactionsByIDsUseCase.ResultValue) -> Void = { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let transactions):
                    guard let transaction = transactions.first else {
                        assertionFailure("Unknown error")
                        return
                    }
                    print("Deleted transaction success: \(transaction)")
                    self.dependencies.actions.didUpdateTransactionDetail(transaction)

                case .failure(let error):
                    print("Deleted transaction failed: \(error)")
                }
                self.showAlert(with: result, successMessage: "Transaction deleted")
            }
        }
        let updateUseCase = dependencies.deleteTransactionsUseCaseFactory(requestValue, completion)
        updateUseCase.execute()
    }
}
