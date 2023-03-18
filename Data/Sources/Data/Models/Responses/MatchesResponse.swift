//
//  MatchesResponse.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/14.
//

import Foundation

struct MatchesResponse: Decodable {
    let matches: MatchesEntity
}

struct MatchesEntity: Decodable {
    let previous: [MatchEntity]
    let upcoming: [MatchEntity]
}

struct MatchEntity: Decodable {
    let date: String?
    let description: String?
    let home: String?
    let away: String?
    let winner: String?
    let highlights: String?
}
