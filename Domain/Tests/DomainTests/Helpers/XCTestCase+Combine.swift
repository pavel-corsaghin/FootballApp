//
//  XCTestCase+Extensions.swift
//  SampleApplicationTests
//
//  Created by HungNguyen on 2023/03/15.
//

import Combine
import XCTest

extension XCTestCase {
    
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 0.5,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> Result<T.Output, Error> {
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")
        
        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result = .failure(error)
                case .finished:
                    break
                }
                
                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
            }
        )
        
        waitForExpectations(timeout: timeout)
        
        cancellable.cancel()
        
        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )
        
        return unwrappedResult
    }
    
}
