//
//  Endpoint.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import Foundation

typealias HTTPHeaders = [String: String]

enum HTTPMethod: String, Codable, CaseIterable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

protocol EndpointConvertible {
    
    /// The path of the endpoint
    var path: String { get }

    /// The HTTP method of the endpoint
    var httpMethod: HTTPMethod { get }

    /// The HTTP Body of the endpoint
    var httpBody: Data? { get }

    // The headers of the endpoint
    var headers: HTTPHeaders { get }

    // The query params of the endpoint
    var queryItems: [String: String]? { get }
}

extension EndpointConvertible {
    
    var request: URLRequest? {
        guard let url = URL(string: NetworkConfig.baseUrl),
              var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        else {
            return nil
        }
        
        // queryItems
        components.path = path
        if let queryItems = queryItems?.compactMap({ URLQueryItem(name: $0.key, value: $0.value) }) {
            components.queryItems = queryItems
        }
        guard let compUrl = components.url else {
            return nil
        }
        var request = URLRequest(url: compUrl)
        
        // headers
        headers.forEach { (key: String, value: String) in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // method
        request.httpMethod = httpMethod.rawValue
        
        // body
        request.httpBody = httpBody
        
        return request
    }
}
