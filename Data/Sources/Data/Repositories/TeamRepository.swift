//
//  TeamRepository.swift
//  
//
//  Created by HungNguyen on 2023/03/16.
//

import Foundation
import Combine
import Domain

public class TeamRepository {

    private let service: TeamServiceProtocol
    private let storage: TeamStorageProtocol

    public init(
        service: TeamServiceProtocol? = nil,
        storage: TeamStorageProtocol? = nil
    ) {
        self.service = service ?? TeamService()
        self.storage = storage ?? TeamStorage()
    }
}

extension TeamRepository: TeamRepositoryProtocol {
    public func fetchTeams() -> AnyPublisher<[Team], Error> {
        service.getTeams()
    }
    
    public func loadCachedTeams() -> AnyPublisher<[Team], Error> {
        storage.loadCachedTeams()
    }
    
    public func cacheTeams(teams: [Team]) {
        storage.cacheMatches(teams: teams)
    }
}
