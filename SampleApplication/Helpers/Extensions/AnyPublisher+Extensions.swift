//
//  AnyPublisher+Extensions.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import Combine
import Foundation

extension AnyPublisher {
    static func just(_ output: Output) -> Self {
        Just(output)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }
    
    static func fail(with error: Failure) -> Self {
        Fail(error: error).eraseToAnyPublisher()
    }
}
