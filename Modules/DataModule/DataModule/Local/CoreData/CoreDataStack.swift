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

public final class CoreDataStack {

    public static let shared = CoreDataStack()
    public static let testInstance = CoreDataStack()

    private let inMemory: Bool
    private let modelName = "ZMoneyModel"

    private var coreDataBundle: Bundle {
        Bundle(for: CoreDataStack.self)
    }

    private init(inMemory: Bool = false) {
        self.inMemory = inMemory
    }

    private lazy var persistentContainer: NSPersistentContainer = {
        guard let modelURL = coreDataBundle.url(forResource: self.modelName, withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        else {
            fatalError("[CoreData] cannot found data model \(modelName)")
        }

        let container = NSPersistentContainer(name: modelName, managedObjectModel: managedObjectModel)
        
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                assertionFailure("[CoreData] loadPersistentStores error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                assertionFailure("[CoreData] saveContext error: \(error), \((error as NSError).userInfo)")
            }
        }
    }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
