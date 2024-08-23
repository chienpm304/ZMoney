//
//  UseCase.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

import Combine

public protocol UseCase {
    @discardableResult
    func execute() -> Cancellable?
}
