//
//  DMCategory.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

public struct DMCategory: Hashable {
    public let id: ID
    public let name: String
    public let icon: String
    public let color: String
    public let sortIndex: Index
    public let type: DMTransactionType

    public init(
        id: ID = .generate(),
        name: String,
        icon: String,
        color: String,
        sortIndex: Index,
        type: DMTransactionType
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.sortIndex = sortIndex
        self.type = type
    }

    public init(type: DMTransactionType, sortIndex: Index = .max - 1) {
        self.id = .generate()
        self.name = ""
        self.icon = type == .expense ? "fork.knife.circle" : "dollarsign.circle"
        self.color = type == .expense ? "FABC3F" : "522258"
        self.sortIndex = sortIndex
        self.type = type
    }
}

extension DMCategory {
    public static var defaultExpenseCategories: [DMCategory] {
        [
            .init(name: "Food", icon: "fork.knife.circle", color: "FABC3F", sortIndex: 1, type: .expense),
            .init(name: "Sport", icon: "figure.walk", color: "E85C0D", sortIndex: 2, type: .expense),
            .init(name: "Education", icon: "book", color: "C7253E", sortIndex: 3, type: .expense),
            .init(name: "Rent", icon: "house", color: "821131", sortIndex: 4, type: .expense),
            .init(name: "Give", icon: "fork.knife.circle", color: "800000", sortIndex: 5, type: .expense)
        ]
    }

    public static var defaultIncomeCategories: [DMCategory] {
        [
            .init(name: "Salary", icon: "dollarsign.circle", color: "522258", sortIndex: 50, type: .income),
            .init(name: "Pocket money", icon: "externaldrive", color: "8C3061", sortIndex: 51, type: .income),
            .init(name: "Bonus", icon: "gift", color: "C63C51", sortIndex: 52, type: .income),
            .init(name: "Side job", icon: "coloncurrencysign.circle", color: "D95F59", sortIndex: 53, type: .income),
            .init(name: "Investment", icon: "building.columns", color: "FF8A8A", sortIndex: 54, type: .income),
            .init(name: "Extra", icon: "directcurrent", color: "F4DEB3", sortIndex: 55, type: .income)
        ]
    }
}
