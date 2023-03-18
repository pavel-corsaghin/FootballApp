//
//  NetworkError.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import Foundation

public struct ServerErrorData: Equatable {
    let status: HttpStatus
    let message: String?
}

public enum NetworkError: Error, Equatable {
    case custom(_ message: String)
    case server(_ data: ServerErrorData)
    case invalidRequest
    case invalidResponse
}

public extension NetworkError {
    var description: String {
        switch self {
        case .custom(let message):
            return message
        case .server(let data):
            return data.message ?? data.status.description
        case .invalidRequest:
            return "Invalid request"
        case .invalidResponse:
            return "Invalid response"
        }
    }
}
