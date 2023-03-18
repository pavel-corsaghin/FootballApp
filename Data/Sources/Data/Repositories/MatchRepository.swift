//
//  MatchRepository.swift
//  
//
//  Created by HungNguyen on 2023/03/15.
//

import Foundation
import Combine
import Domain

public class MatchRepository {

    private let service: MatchServiceProtocol
    private let storage: MatchStorageProtocol

    public init(
        service: MatchServiceProtocol? = nil,
        storage: MatchStorageProtocol? = nil
    ) {
        self.service = service ?? MatchService()
        self.storage = storage ?? MatchStorage()
    }
}

extension MatchRepository: MatchRepositoryProtocol {
    public func fetchMatches() -> AnyPublisher<[Match], Error> {
        service.fetchMatches()
    }
    
    public func loadCachedMatches() -> AnyPublisher<[Match], Error> {
        storage.loadCachedMatches()
    }
    
    public func cacheMatches(matches: [Match]) {
        storage.cacheMatches(matches: matches)
    }
}
