//
//  MatchStorage.swift
//  
//
//  Created by HungNguyen on 2023/03/15.
//

import Foundation
import Combine
import CoreData
import Domain

public protocol MatchStorageProtocol {
    /// Load cached matches from storage
    func loadCachedMatches() -> AnyPublisher<[Match], Error>
    
    /// Cache  matches to store
    func cacheMatches(matches: [Match])
}

final class MatchStorage {
    
    private let coreDataStorage: CoreDataStorage
    private var context: NSManagedObjectContext { coreDataStorage.context }

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
}

extension MatchStorage: MatchStorageProtocol {
    
    func loadCachedMatches() -> AnyPublisher<[Match], Error> {
        Deferred { [context] in
            Future { promise in
                context.performAndWait {
                    let fetchRequest = CdMatchEntity.fetchRequest()
                    do {
                        let results = try context.fetch(fetchRequest)
                            .sorted(by: { $0.index < $1.index })
                            .compactMap { $0.toDomainEntity() }
                        promise(.success(results))
                    } catch {
                        promise(.failure(CoreDataStorageError.readError(error)))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func cacheMatches(matches: [Match]) {
        deleteMatches()
        context.performAndWait {
            do {
                matches.enumerated().forEach { index, match in
                    _ = match.toCoreDataEntity(context: context, index: index)
                }
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /// Delete all  matches in Core Data
    private func deleteMatches() {
        context.performAndWait {
            // Specify a batch to delete with a fetch request
            let fetchRequest = CdMatchEntity.fetchRequest()
            do {
                // Perform the batch delete
                let objects = try context.fetch(fetchRequest)
                for object in objects {
                    context.delete(object)
                }
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}


