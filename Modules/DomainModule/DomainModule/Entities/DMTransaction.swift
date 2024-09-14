//
//  DMTransaction.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

public struct DMTransaction: Hashable {
    public let id: ID
    public let inputTime: TimeValue
    public let amount: MoneyValue
    public let memo: String?
    public let category: DMCategory

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
