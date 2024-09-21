//
//  AsyncUseCase.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

public protocol AsyncUseCase {
    associatedtype Input
    associatedtype Output

    func execute(input: Input) async throws -> Output
}
