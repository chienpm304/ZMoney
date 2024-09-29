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

@dynamicMemberLookup
final class TransactionDetailViewModel: ObservableObject, AlertProvidable {
    struct Dependencies {
        let actions: TransactionDetailViewModelActions
        let fetchCategoriesUseCaseFactory: FetchCategoriesUseCaseFactory
        let addTransactionsUseCaseFactory: AddTransactionsUseCaseFactory
        let updateTransactionsUseCaseFactory: UpdateTransactionsUseCaseFactory
        let deleteTransactionsUseCaseFactory: DeleteTransactionsUseCaseFactory
    }

    @Published private var transaction: TransactionDetailModel
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
    }

    // MARK: @dynamicMemberLookup

    subscript<T>(dynamicMember keyPath: WritableKeyPath<TransactionDetailModel, T>) -> T {
        get { transaction[keyPath: keyPath] }
        set { transaction[keyPath: keyPath] = newValue }
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

    func cancel() {
        dependencies.actions.didCancelTransactionDetail()
    }

    @MainActor func save() async {
        if isNewTransaction {
            await addTransaction()
        } else {
            await updateTransaction()
        }
    }

    @MainActor func delete() async {
        guard !isNewTransaction else { return }
        await deleteTransaction()
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

    private func setupDataModel(categories: [DMCategory]) {
        self.categories = categories
        guard let defaultCategory = filteredCategories.first else {
            return
        }

        if isNewTransaction, transaction.category.isPlaceholder {
            transaction.category = defaultCategory
            transaction.category.isPlaceholder = false
            return
        }

        if let updatedCategory = filteredCategories.first(where: { $0.id == transaction.category.id }) {
            transaction.category = updatedCategory
        } else {
            // category has been deleted
            transaction.category = originalTransaction?.category ?? defaultCategory
        }
    }

    @MainActor func refreshData() async {
        guard !isFetching else {
            return
        }
        isFetching = true

        do {
            let useCase = dependencies.fetchCategoriesUseCaseFactory()
            let categories = try await useCase.execute(input: ())
            isFetching = false
            setupDataModel(categories: categories)
        } catch {
            showErrorAlert(with: error as? DMError ?? .unknown(error))
        }
    }

    @MainActor private func addTransaction() async {
        do {
            let addUseCase = dependencies.addTransactionsUseCaseFactory()
            let input = AddTransactionsUseCase.Input(transactions: [transaction.domain])
            let transactions = try await addUseCase.execute(input: input)
            guard let transaction = transactions.first else {
                assertionFailure("Unknown error")
                return
            }
            prepareForNextTransaction()
            dependencies.actions.didUpdateTransactionDetail(transaction)
            print("Added transaction success: \(transaction)")
            showSuccessAlert(with: "Transaction created")
        } catch {
            print("Added transaction failed: \(error)")
            showErrorAlert(with: error as? DMError ?? .unknown(error))
        }
    }

    @MainActor private func updateTransaction() async {
        do {
            let updateUseCase = dependencies.updateTransactionsUseCaseFactory()
            let input = UpdateTransactionsUseCase.Input(transactions: [transaction.domain])
            let transactions = try await updateUseCase.execute(input: input)
            guard let transaction = transactions.first else {
                self.showErrorAlert(with: DMError.notFound)
                return
            }
            print("Updated transaction success: \(transaction)")
            self.showSuccessAlert(with: "Transaction updated")
            self.dependencies.actions.didUpdateTransactionDetail(transaction)
        } catch {
            print("Updated transaction failed: \(error)")
            showErrorAlert(with: error as? DMError ?? .unknown(error))
        }
    }

    @MainActor private func deleteTransaction() async {
        do {
            let input = DeleteTransactionsByIDsUseCase.Input(
                transactionIDs: [transaction.id]
            )
            let useCase = dependencies.deleteTransactionsUseCaseFactory()
            let transactions = try await useCase.execute(input: input)
            guard let transaction = transactions.first else {
                assertionFailure("Unknown error")
                return
            }
            dependencies.actions.didUpdateTransactionDetail(transaction)
            print("Deleted transaction success: \(transaction)")
            showSuccessAlert(with: "Transaction deleted")
        } catch {
            print("Deleted transaction failed: \(error)")
            showErrorAlert(with: error as? DMError ?? .unknown(error))
        }
    }
}
