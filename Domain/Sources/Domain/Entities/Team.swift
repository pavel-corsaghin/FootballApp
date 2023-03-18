//
//  Team.swift
//  
//
//  Created by HungNguyen on 2023/03/15.
//

import Foundation

public struct Team {
    public let id: String?
    public let name: String?
    public let logo: String?
    
    public init(id: String?, name: String?, logo: String?) {
        self.id = id
        self.name = name
        self.logo = logo
    }
}
