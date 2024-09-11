//
//  DMError+Localized.swift
//  ZMoney
//
//  Created by Chien Pham on 07/09/2024.
//

import DomainModule

extension DMError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .fetchError(let error):
            return "Cannot fetch data. \(error.localizedDescription)"
        case .addError(let error):
            return "Cannot create data. \(error.localizedDescription)"
        case .updateError(let error):
            return "Cannot update data. \(error.localizedDescription)"
        case .deleteError(let error):
            return "Cannot delete data. \(error.localizedDescription)"
        case .notFound:
            return "Cannot found data."
        case .duplicated:
            return "Cannot process duplicated data."
        case .violateRelationshipConstraint:
            return "This data is required by other records."
        case .unknown(let error):
            return "Unknown error. \(error.localizedDescription)"
        }
    }
}
