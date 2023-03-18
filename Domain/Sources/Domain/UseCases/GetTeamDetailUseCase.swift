//
//  GetTeamDetailUseCase.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/15.
//

import Foundation
import Combine

public protocol GetTeamDetailUseCaseProtocol {
    func execute(teamName: String) -> AnyPublisher<Team?, Error>
}

public struct GetTeamDetailUseCase: GetTeamDetailUseCaseProtocol {
    private let teamRepository: TeamRepositoryProtocol
    
    public init(teamRepository: TeamRepositoryProtocol) {
        self.teamRepository = teamRepository
    }
    
    public func execute(teamName: String) -> AnyPublisher<Team?, Error> {
        Publishers.Concatenate(
            prefix: teamRepository.loadCachedTeams()
                .catch { _ -> AnyPublisher<[Team], Error> in
                    // Ignore error from loading local teams
                    Result.Publisher(.success([])).eraseToAnyPublisher()
                },
            suffix: teamRepository.fetchTeams()
                .handleEvents(receiveOutput: {
                    teamRepository.cacheTeams(teams: $0)
                })
        )
        .map { $0.first { $0.name == teamName }}
        .eraseToAnyPublisher()
    }
}
