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
