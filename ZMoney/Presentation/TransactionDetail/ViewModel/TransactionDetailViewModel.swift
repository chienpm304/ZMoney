//
//  TransactionDetailViewModel.swift
//  ZMoney
//
//  Created by Chien Pham on 03/09/2024.
//

import DomainModule

class TransactionDetailViewModel: ObservableObject {
    @Published var transaction: TransactionDetailModel
    @Published var isNewTransaction: Bool
    private let originalTransaction: TransactionDetailModel?

    private var categories: [DMCategory] = []

    private static var defaultTransactionType: DMTransactionType { .expense }

    init(transaction: DMTransaction? = nil, inputDate: Date? = nil) {
        if let transaction = transaction {
            let detailModel = TransactionDetailModel(transaction: transaction)
            self.transaction = detailModel
            self.isNewTransaction = false
            self.originalTransaction = detailModel
        } else {
            // temporary create new category, update later after fech categories from local
            let categoryPlaceHolder = DMCategory(type: Self.defaultTransactionType)
            self.transaction = TransactionDetailModel(
                id: .generate(),
                inputTime: inputDate ?? .now,
                amount: 0,
                memo: "",
                category: CategoryDetailModel(category: categoryPlaceHolder)
            )
            self.isNewTransaction = true
            self.originalTransaction = nil
        }

        // TODO: load from DB
        categories = DMCategory.defaultExpenseCategories + DMCategory.defaultIncomeCategories
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

    func save() {
        // Handle saving logic here, including creating a new DMTransaction from TransactionDetailModel
        // For new transactions, ensure the transactionType is properly applied to the selected category
    }

    func didTapEditCategory() {
        print("Did tap edit category")
    }

    // MARK: Private

    private var isModified: Bool {
        guard let originalTransaction = originalTransaction else { return true }

        return transaction.amount != originalTransaction.amount
        || transaction.inputTime != originalTransaction.inputTime
        || transaction.memo != originalTransaction.memo
        || transaction.category.id != originalTransaction.category.id
    }
}
