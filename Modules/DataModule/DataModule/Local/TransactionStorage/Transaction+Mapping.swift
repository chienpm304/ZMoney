//
//  Transaction+Mapping.swift
//  DataModule
//
//  Created by Chien Pham on 28/08/2024.
//

import CoreData
import DomainModule

// If compiler say that not found the entity, try add core data model target membership
extension CDTransaction {
    var domain: DMTransaction {
        let transactionID: ID
        if let id = self.id {
            transactionID = id
        } else {
            assertionFailure("CDTransaction.id should not be nil")
            transactionID = .generate()
        }

        let category: DMCategory
        if let cdCategory = self.category {
            category = cdCategory.domain
        } else {
            assertionFailure("CDTransaction.categogy should not be nil")
            category = .init(type: .expense)
        }
        return DMTransaction(
            id: transactionID,
            inputTime: self.inputTime?.timeValue ?? 0,
            amount: self.amount,
            memo: self.memo,
            category: category
        )
    }
}

extension CDTransaction {
    convenience init(transaction: DMTransaction, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = transaction.id
        self.update(with: transaction, context: context)
    }

    func update(
        with transaction: DMTransaction,
        context: NSManagedObjectContext
    ) {
        self.inputTime = transaction.inputTime.dateValue
        self.amount = transaction.amount
        self.memo = transaction.memo

        // Fetch or create the CDCategory for the DMCategory
        do {
            let dmCategory = transaction.category
            let categoryFetchRequest: NSFetchRequest<CDCategory> = CDCategory.fetchRequest()
            categoryFetchRequest.predicate = NSPredicate(
                format: "id == %@",
                dmCategory.id as CVarArg
            )
            let categoryResults = try context.fetch(categoryFetchRequest)
            let cdCategory: CDCategory

            if let existingCategory = categoryResults.first {
                cdCategory = existingCategory
            } else {
                cdCategory = CDCategory(category: dmCategory, insertInto: context)
            }
            self.category = cdCategory
        } catch {
            assertionFailure("failed to update transaction: \(error)")
        }

    }
}
