//
//  TeamRepository.swift
//  
//
//  Created by HungNguyen on 2023/03/15.
//

import Foundation
import Combine

public protocol TeamRepositoryProtocol {
    /// Fetch teams  from remote
    func fetchTeams() -> AnyPublisher<[Team], Error>
    
    /// Load cached matches from storage
    func loadCachedTeams() -> AnyPublisher<[Team], Error>
    
    /// Cache  matches to store
    func cacheTeams(teams: [Team])
}
