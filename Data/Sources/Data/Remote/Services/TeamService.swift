//
//  TeamService.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/15.
//

import Foundation
import Combine
import Domain

public protocol TeamServiceProtocol {
    func getTeams() -> AnyPublisher<[Team], Error>
}

struct TeamService: TeamServiceProtocol {
    func getTeams() -> AnyPublisher<[Team], Error> {
        Network<TeamsResponse>().request(Endpoint.terms, requestModifier: { request in
            request.acceptingJSON()
        })
        .map { $0.teams.map { $0.toDomainEntity() } }
        .eraseToAnyPublisher()
    }
}
