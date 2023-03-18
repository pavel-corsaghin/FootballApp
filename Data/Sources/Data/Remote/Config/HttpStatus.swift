//
//  HttpStatus.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import Foundation

enum HttpStatus: Int {
    case success = 200
    case created = 201
    case accepted = 202
    case noContent = 204
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case notAllowed = 405
    case conflict = 409
    case upgradeRequired = 426
    case requestTooSoon = 429
    case internalServerError = 500
    case badGetway = 502
    case quotaExceeded = 503
    case getwayTimeout = 504
}

extension HttpStatus {
    /// Provide default description for error in case the messae is missing from BE
    var description: String {
        switch self {
        case .badRequest:
            return "Bad request"
        case .unauthorized:
            return "Unauthorized"
        case .forbidden:
            return "Forbidden"
        case .notFound:
            return "Not found"
        case .notAllowed:
            return "Not allowed"
        case .conflict:
            return "Conflict"
        case .upgradeRequired:
            return "Upgrade Required"
        case .requestTooSoon:
            return "Request too soon"
        case .internalServerError:
            return "Internal server error"
        case .badGetway:
            return "Bad getway"
        case .quotaExceeded:
            return "Quota exceeded"
        case .getwayTimeout:
            return "Getway timeout"
        default:
            return ""
        }
    }
}
