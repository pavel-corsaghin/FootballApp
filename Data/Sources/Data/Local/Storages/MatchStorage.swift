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
    
    private let storageCRUD: StorageCRUD<CdMatchEntity>
    
    init(storageCRUD: StorageCRUD<CdMatchEntity> = .init()) {
        self.storageCRUD = storageCRUD
    }
}

extension MatchStorage: MatchStorageProtocol {
    
    func loadCachedMatches() -> AnyPublisher<[Match], Error> {
        storageCRUD.fetchAllEntities()
            .map {
                $0.sorted(by: { $0.index < $1.index })
                    .compactMap { $0.toDomainEntity() }
            }
            .eraseToAnyPublisher()
    }
    
    func cacheMatches(matches: [Match]) {
        storageCRUD.deleteAllEntities()
        
        let entities = matches.enumerated().map { index, match in
            match.toCoreDataEntity(context: storageCRUD.context, index: index)
        }
        storageCRUD.cacheEntities(entities: entities)
    }
}
