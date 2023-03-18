//
//  URLRequest+Extensions.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/14.
//

import Foundation

extension URLRequest {
    func addingBearerAuthorization(token: String) -> URLRequest {
        var request = self
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }

    func acceptingJSON() -> URLRequest {
        var request = self
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    func sendingJSON() -> URLRequest {
        var request = self
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
