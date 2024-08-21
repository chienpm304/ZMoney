//
//  TransCategory.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

public struct TransCategory {
    public let id: ID
    public let name: String
    public let icon: String
    public let color: String
    public let sortIndex: Index
    public let type: TransType

    public init(
        id: ID,
        name: String,
        icon: String,
        color: String,
        sortIndex: Index,
        type: TransType
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.sortIndex = sortIndex
        self.type = type
    }
}
