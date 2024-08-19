//
//  UseCase.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

import Combine

protocol UseCase {
    @discardableResult
    func start() -> Cancellable?
}
