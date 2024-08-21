//
//  Transaction.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

struct Transaction {
    let id: ID
    let inputDate: Int64 /// time interval since 00:00:00 UTC on 1 January 1970, in seconds.
    let amount: Int64
    let memo: String?
    let category: TransCategory
}
