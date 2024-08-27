//
//  DMTransaction.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

public struct DMTransaction {
    let id: ID
    let inputTime: TimeValue
    let amount: MoneyValue
    let memo: String?
    let category: DMCategory

    public init(
        id: ID = .generate(),
        inputTime: TimeValue,
        amount: MoneyValue,
        memo: String?,
        category: DMCategory
    ) {
        self.id = id
        self.inputTime = inputTime
        self.amount = amount
        self.memo = memo
        self.category = category
    }
}
