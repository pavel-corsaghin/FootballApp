//
//  MatchRepository.swift
//  
//
//  Created by HungNguyen on 2023/03/15.
//

import Foundation
import Combine

public protocol MatchRepositoryProtocol {
    /// Fetch matches  from remote
    func fetchMatches() -> AnyPublisher<[Match], Error>
    
    /// Load cached matches from storage
    func loadCachedMatches() -> AnyPublisher<[Match], Error>
    
    /// Cache  matches to store
    func cacheMatches(matches: [Match])
}
