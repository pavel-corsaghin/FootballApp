//
//  GetMatchesUseCaseTests.swift
//  SampleApplicationTests
//
//  Created by HungNguyen on 2023/03/15.
//

import XCTest
import Combine
@testable import Domain

final class GetMatchesUseCaseTests: XCTestCase {
    
    // MARK: - Mockings
    
    private let mockMatches: [Match] = [
        Match(
            date: "2022-06-12T18:00:00.000Z",
            description: "Team Hungry Sharks vs. Team Win Kings",
            home: "Team Hungry Sharks",
            away: "Team Win Kings",
            winner: nil,
            highlights: nil
        ),
        Match(
            date: "2022-06-13T18:00:00.000Z",
            description: "Team Growling Tigers vs. Team Chill Elephants",
            home: "Team Growling Tigers",
            away: "Team Chill Elephants",
            winner: nil,
            highlights: nil
        )
    ]

    class MatchRepositoryMock: MatchRepositoryProtocol {
        var cachedMatches: [Match] = []
        var remoteMatches: [Match] = []
        var shouldFetchMatchesFail = false
        var shouldLoadCachedMatchesFail = false
        var shouldCacheMatchesFail = false

        func fetchMatches() -> AnyPublisher<[Match], Error> {
            Deferred {
                Future<[Match], Error> { future in
                    if self.shouldFetchMatchesFail {
                        future(.failure(MockError.forcedError))
                    } else {
                        future(.success(self.remoteMatches))
                    }
                }
            }.eraseToAnyPublisher()
        }

        func loadCachedMatches() -> AnyPublisher<[Match], Error> {
            Deferred {
                Future<[Match], Error> { future in
                    if self.shouldLoadCachedMatchesFail {
                        future(.failure(MockError.forcedError))
                    } else {
                        future(.success(self.cachedMatches))
                    }
                }
            }.eraseToAnyPublisher()
        }
        
        func cacheMatches(matches: [Match]) {
            if !shouldCacheMatchesFail {
                cachedMatches = matches
            }
        }
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_when_both_local_and_remote_success_then_the_last_result_is_from_remote() throws {
        // given
        let repository = MatchRepositoryMock()
        repository.cachedMatches = [mockMatches[0]]
        repository.remoteMatches = [mockMatches[1]]
        let useCase = GetMatchesUseCase(matchRepository: repository)
        
        // when
        let result = try awaitPublisher(useCase.execute())
        let lastResultMatches = try result.get()
        
        // then
        XCTAssertEqual(lastResultMatches, [mockMatches[1]])
    }
    
    func test_when_local_fail_then_the_result_is_from_remote() throws {
        // given
        let repository = MatchRepositoryMock()
        repository.shouldLoadCachedMatchesFail = true
        repository.remoteMatches = [mockMatches[1]]
        let useCase = GetMatchesUseCase(matchRepository: repository)
        
        // when
        let result = try awaitPublisher(useCase.execute())
        let lastResultMatches = try result.get()
        
        // then
        XCTAssertEqual(lastResultMatches, [mockMatches[1]])
    }

    func test_matches_are_cached_after_fetch_matches_success() throws {
        // given
        let repository = MatchRepositoryMock()
        repository.remoteMatches = [mockMatches[0]]
        let useCase = GetMatchesUseCase(matchRepository: repository)
        
        // when
        let _ = try awaitPublisher(useCase.execute())
        
        // then
        XCTAssertEqual(repository.cachedMatches.count, 1)
        XCTAssertEqual(repository.cachedMatches.first, mockMatches.first)
    }
}

extension Match: Equatable {
    public static func == (lhs: Match, rhs: Match) -> Bool {
        return lhs.date == rhs.date
    }
}
