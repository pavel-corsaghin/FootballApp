//
//  Environment.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import Foundation

let environment: Environment = .dev

enum Environment {
    case dev
    case prod
}

extension Environment {
    
    var baseURL: String {
        switch self {
        case .dev:
            return "https://jmde6xvjr4.execute-api.us-east-1.amazonaws.com/"
        case .prod:
            fatalError("Not provided yet")
        }
    }
}
