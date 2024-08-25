//
//  IDGenerator.swift
//  DomainModule
//
//  Created by Chien Pham on 23/08/2024.
//

import Foundation

public final class IDGenerator {
    private static let idKey = "Common.IDGenerator"

    private static var currentID: ID {
        get {
            return ID(UserDefaults.standard.integer(forKey: idKey))
        }
        set {
            UserDefaults.standard.set(newValue, forKey: idKey)
        }
    }

    static public func generate() -> ID {
        currentID += 1
        return currentID
    }

    static public func updateCurrentID(_ currentID: ID) {
        IDGenerator.currentID = currentID
    }
}
