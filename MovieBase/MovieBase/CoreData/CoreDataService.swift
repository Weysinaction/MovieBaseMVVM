// CoreDataService.swift
// Copyright © RoadMap. All rights reserved.

import CoreData
import Foundation

final class CoreDataService {
    // MARK: public properties

    static let shared = CoreDataService()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    // MARK: private properties

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error),\(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: init

    private init() {}

    // MARK: public properties

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
}
