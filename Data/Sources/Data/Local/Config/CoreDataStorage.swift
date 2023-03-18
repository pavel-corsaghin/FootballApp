//
//  File.swift
//  
//
//  Created by HungNguyen on 2023/03/15.
//

import Foundation
import CoreData

enum CoreDataStorageError: Error {
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
}

final class CoreDataStorage {

    static let shared = CoreDataStorage()
    var context: NSManagedObjectContext { persistentContainer.viewContext }
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer = {
        guard let modelURL = Bundle.module.url(forResource:"CoreDataStorage", withExtension: "momd"),
                let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Can not load CoreData model")
        }
        
        let container = NSPersistentContainer(name: "CoreDataStorage", managedObjectModel: model)
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
}
