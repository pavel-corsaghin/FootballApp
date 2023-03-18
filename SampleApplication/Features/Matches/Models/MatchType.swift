//
//  MatchType.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/18.
//

import Foundation

enum MatchType: Int, CaseIterable {
    case previous
    case upcoming
}

extension MatchType {
    var title: String {
        switch self {
        case .previous:
            return "Previous"
        case .upcoming:
            return "Upcoming"
        }
    }
}

