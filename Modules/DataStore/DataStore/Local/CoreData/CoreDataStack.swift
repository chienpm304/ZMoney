//
//  CoreDataStack.swift
//  Domain
//
//  Created by Chien Pham on 19/08/2024.
//

import CoreData

enum CoreDataError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
    case notFound
}

final class CoreDataStack {

    static let shared = CoreDataStack()

    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        //TODO: fix me
        let container = NSPersistentContainer(name: "ZMoneyModel")

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
