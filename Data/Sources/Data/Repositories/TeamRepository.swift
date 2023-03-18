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

    public init(service: TeamServiceProtocol? = nil) {
        self.service = service ?? TeamService()
    }
}

extension TeamRepository: TeamRepositoryProtocol {
    public func getTeam(id: String) -> AnyPublisher<Domain.Team, Error> {
        fatalError("Not implemented yet")
    }
    
    public func getTeams() -> AnyPublisher<[Team], Error> {
        service.getTeams()
    }
}
