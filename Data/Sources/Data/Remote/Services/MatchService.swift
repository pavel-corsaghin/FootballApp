//
//  MatchService.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/14.
//

import Foundation
import Combine
import Domain

public protocol MatchServiceProtocol {
    func fetchMatches() -> AnyPublisher<[Match], Error>
}

struct MatchService: MatchServiceProtocol {
    func fetchMatches() -> AnyPublisher<[Match], Error>{
        Network<MatchesResponse>().request(Endpoint.matches, requestModifier: { request in
            request.acceptingJSON()
        })
        .map { $0.matches.previous + $0.matches.upcoming }
        .map { $0.map { $0.toDomainEntity() } }
        .eraseToAnyPublisher()
    }
}

