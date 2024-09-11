//
//  DMError.swift
//  DomainModule
//
//  Created by Chien Pham on 04/09/2024.
//

import Foundation

public enum DMError: Error {
    case fetchError(Error)
    case addError(Error)
    case updateError(Error)
    case deleteError(Error)
    case notFound
    case duplicated
    case violateRelationshipConstraint
    case unknown(Error)
}
