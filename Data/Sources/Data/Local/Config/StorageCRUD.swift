//
//  StorageCRUD.swift
//  
//
//  Created by HungNguyen on 2023/03/24.
//

import Foundation
import CoreData
import Combine

final class StorageCRUD<CDEntity: NSManagedObject> {
    
    private let coreDataStorage: CoreDataStorage
    var context: NSManagedObjectContext { coreDataStorage.context }

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    func fetchAllEntities() -> AnyPublisher<[CDEntity], Error>  {
        Deferred { [context] in
            Future { promise in
                context.performAndWait {
                    let fetchRequest = CDEntity.fetchRequest()
                    do {
                        let results = try context.fetch(fetchRequest) as? [CDEntity] ?? []
                        promise(.success(results))
                    } catch {
                        promise(.failure(CoreDataStorageError.readError(error)))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func cacheEntities(entities: [CDEntity]) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteAllEntities() {
        context.performAndWait {
            let fetchRequest = CDEntity.fetchRequest()
            do {
                let objects = try context.fetch(fetchRequest) as? [CDEntity] ?? []
                objects.forEach { context.delete($0) }
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
