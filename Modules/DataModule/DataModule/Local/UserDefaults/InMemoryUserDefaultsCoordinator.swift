//
//  InMemoryUserDefaultsCoordinator.swift
//  DomainModule
//
//  Created by Chien Pham on 07/09/2024.
//

import Foundation

public final class InMemoryUserDefaultsCoordinator: UserDefaultsProtocol {
    private var storage = [String: Data]()

    public init() {
        self.storage = [:]
    }

    public func set(_ value: Any?, forKey defaultName: String) {
        if let value = value as? Data {
            storage[defaultName] = value
        } else {
            storage.removeValue(forKey: defaultName)
        }
    }

    public func data(forKey defaultName: String) -> Data? {
        return storage[defaultName]
    }

    public func removeObject(forKey defaultName: String) {
        storage.removeValue(forKey: defaultName)
    }
}
