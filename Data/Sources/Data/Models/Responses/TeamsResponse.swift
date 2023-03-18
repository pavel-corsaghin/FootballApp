//
//  TeamsResponse.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/15.
//

import Foundation

struct TeamsResponse: Decodable {
    let teams: [TeamEntity]
}

struct TeamEntity: Decodable {
    let id: String?
    let name: String?
    let logo: String?
}
