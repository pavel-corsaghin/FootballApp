//
//  Match.swift
//  
//
//  Created by HungNguyen on 2023/03/15.
//

import Foundation

public struct Match {
    public let date: String?
    public let description: String?
    public let home: String?
    public let away: String?
    public let winner: String?
    public let highlights: String?
    
    public init(date: String?, description: String?, home: String?, away: String?, winner: String?, highlights: String?) {
        self.date = date
        self.description = description
        self.home = home
        self.away = away
        self.winner = winner
        self.highlights = highlights
    }
}
