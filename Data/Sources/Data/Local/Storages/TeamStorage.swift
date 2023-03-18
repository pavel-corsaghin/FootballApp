//
//  TeamStorage.swift
//  
//
//  Created by HungNguyen on 2023/03/18.
//

import Foundation
import Combine
import CoreData
import Domain

public protocol TeamStorageProtocol {
    /// Load cached matches from storage
    func loadCachedTeams() -> AnyPublisher<[Team], Error>
    
    /// Cache  matches to store
    func cacheMatches(teams: [Team])
}

final class TeamStorage {
    
    private let coreDataStorage: CoreDataStorage
    private var context: NSManagedObjectContext { coreDataStorage.context }

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
}

extension TeamStorage: TeamStorageProtocol {
    func loadCachedTeams() -> AnyPublisher<[Team], Error> {
        Deferred { [context] in
            Future { promise in
                context.performAndWait {
                    let fetchRequest = CdTeamEntity.fetchRequest()
                    do {
                        let results = try context.fetch(fetchRequest)
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
    
    func cacheMatches(teams: [Team]) {
        deleteMatches()
        context.performAndWait {
            do {
                teams.forEach { team in
                    _ = team.toCoreDataEntity(context: context)
                }
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /// Delete all  teams in Core Data
    private func deleteMatches() {
        context.performAndWait {
            // Specify a batch to delete with a fetch request
            let fetchRequest = CdTeamEntity.fetchRequest()
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
