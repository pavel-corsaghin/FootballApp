//
//  MatchesViewModelTest.swift
//  SampleApplicationTests
//
//  Created by HungNguyen on 2023/03/16.
//

import XCTest
import Domain
import Combine
@testable import SampleApplication

final class MatchesViewModelTest: XCTestCase {
    
    // MARK: - Mocks
    
    let mockPreviousMatch = Match(date: "1", description: "", home: "TeamA", away: "TeamB", winner: "TeamA", highlights: "")
    let mockUpcomingMatch = Match(date: "2", description: "", home: "TeamA", away: "TeamB", winner: nil, highlights: nil)

    class GetMatchesUseCaseMock: GetMatchesUseCaseProtocol {
        var shouldFail: Bool = false
        var matches: [Match] = []
        
        func execute() -> AnyPublisher<[Match], Error> {
            Deferred {
                Future<[Match], Error> { future in
                    DispatchQueue.global().asyncAfter(deadline: .now() + 0.1) {
                        if self.shouldFail {
                            future(.failure(MockError.forcedError))
                        } else {
                            future(.success(self.matches))
                        }
                    }
                }
            }.eraseToAnyPublisher()
        }
        
    }
    
    // MARK: - Setup

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_toogle_isLoading_when_get_matches() {
        // Given
        let useCase = GetMatchesUseCaseMock()
        let vm = MatchesViewModel(getMatchesUseCase: useCase)
        
        // When
        vm.getMatches()
        
        // Then
        XCTAssertEqual(vm.isLoading, true)
        
        // When
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 1 seconds")], timeout: 1)
        
        // Then
        XCTAssertEqual(vm.isLoading, false)
    }
    
    func test_when_execute_fail_then_snapshot_items_is_empty() {
        // Given
        let useCase = GetMatchesUseCaseMock()
        useCase.shouldFail = true
        let vm = MatchesViewModel(getMatchesUseCase: useCase)
        
        // When
        vm.getMatches()

        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 1 seconds")], timeout: 1)
        
        // Then
        XCTAssertTrue(vm.snapshot!.numberOfItems == 0)
    }
    
    func test_when_execute_success_with_empty_matches_then_snapshot_items_is_empty() {
        // Given
        let useCase = GetMatchesUseCaseMock()
        useCase.shouldFail = false
        useCase.matches = []
        let vm = MatchesViewModel(getMatchesUseCase: useCase)
        
        // When
        vm.getMatches()
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 1 seconds")], timeout: 1)
        
        // Then
        XCTAssertTrue(vm.snapshot!.numberOfItems == 0)
    }
    
    func test_when_execute_success_and_has_matches_then_snapshot_items_is_empty() {
        // Given
        let useCase = GetMatchesUseCaseMock()
        useCase.shouldFail = false
        useCase.matches = [mockPreviousMatch]
        let vm = MatchesViewModel(getMatchesUseCase: useCase)
        
        // When
        vm.getMatches()
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for 1 seconds")], timeout: 1)
        
        // Then
        XCTAssertTrue(vm.snapshot!.numberOfItems > 0)
    }

}
