//
//  UserDefaultCoordinator.swift
//  DomainModule
//
//  Created by Chien Pham on 07/09/2024.
//

import Foundation
import DomainModule

public protocol UserDefaultsProtocol {
    func set(_ value: Any?, forKey defaultName: String)
    func data(forKey defaultName: String) -> Data?
    func removeObject(forKey defaultName: String)
}

final public class UserDefaultCoordinator {
    private var userDefaults: UserDefaultsProtocol

    public init(userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    func get<T: Codable>(forKey key: String, as type: T.Type) -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func set<T: Codable>(_ value: T, forKey key: String) -> Result<T, DMError> {
        do {
            let data = try JSONEncoder().encode(value)
            userDefaults.set(data, forKey: key)
            return .success(value)
        } catch {
            return .failure(.updateError(error))
        }
    }

    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}

extension UserDefaults: UserDefaultsProtocol { }
