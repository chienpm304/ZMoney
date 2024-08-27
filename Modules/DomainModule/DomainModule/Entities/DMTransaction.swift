//
//  DMTransaction.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

struct DMTransaction {
    let id: ID
    let inputDate: TimeValue
    let amount: MoneyValue
    let memo: String?
    let category: DMCategory
}
