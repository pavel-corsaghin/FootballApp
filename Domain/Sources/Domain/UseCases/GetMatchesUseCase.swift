//
//  GetMatchesUseCase.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/14.
//

import Foundation
import Combine

public protocol GetMatchesUseCaseProtocol {
    func execute() -> AnyPublisher<[Match], Error>
}

public struct GetMatchesUseCase: GetMatchesUseCaseProtocol {
    let matchRepository: MatchRepositoryProtocol
    
    public init(matchRepository: MatchRepositoryProtocol) {
        self.matchRepository = matchRepository
    }
    
    public func execute() -> AnyPublisher<[Match], Error> {
        Publishers.Concatenate(
            prefix: matchRepository.loadCachedMatches()
                .catch { _ -> AnyPublisher<[Match], Error> in
                    // Ignore error from loading local matches
                    Result.Publisher(.success([])).eraseToAnyPublisher()
                },
            suffix: matchRepository.fetchMatches()
                .handleEvents(receiveOutput: {
                    matchRepository.cacheMatches(matches: $0)
                })
        )
        .eraseToAnyPublisher()
    }
}
