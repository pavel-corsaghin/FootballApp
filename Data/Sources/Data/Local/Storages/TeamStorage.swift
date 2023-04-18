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
    /// Load cached team from storage
    func loadCachedTeams() -> AnyPublisher<[Team], Error>
    
    /// Cache  teams to store
    func cacheTeams(teams: [Team])
}

final class TeamStorage {
    
    private let storageCRUD: StorageCRUD<CdTeamEntity>
    
    init(storageCRUD: StorageCRUD<CdTeamEntity> = .init()) {
        self.storageCRUD = storageCRUD
    }
    
}

extension TeamStorage: TeamStorageProtocol {
    func loadCachedTeams() -> AnyPublisher<[Team], Error> {
        storageCRUD.fetchAllEntities()
            .map { $0.compactMap { $0.toDomainEntity() } }
            .eraseToAnyPublisher()
    }
    
    func cacheTeams(teams: [Team]) {
        storageCRUD.deleteAllEntities()
        
        let entities = teams.map { $0.toCoreDataEntity(context: storageCRUD.context) }
        storageCRUD.cacheEntities(entities: entities)
    }
    
}
