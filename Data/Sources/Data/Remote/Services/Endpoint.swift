//
//  Endpoint.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/14.
//

import Foundation

enum Endpoint {
    case terms
    case matches
}

extension Endpoint: EndpointConvertible {
    private var basePath: String { "/teams" }

    var path: String {
        switch self {
        case .terms:
            return basePath
        case .matches:
            return "\(basePath)/matches"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .terms, .matches:
            return .get
        }
    }

    var httpBody: Data? {
        switch self {
        case .terms, .matches:
            return nil
        }
    }

    var headers: HTTPHeaders {
        switch self {
        case .terms, .matches:
            return [:]
        }
    }

    var queryItems: [String : String]? {
        switch self {
        case .terms, .matches:
            return nil
        }
    }
}
