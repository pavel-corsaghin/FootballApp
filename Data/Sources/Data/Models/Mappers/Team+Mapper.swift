//
//  Team+Mapper.swift
//  
//
//  Created by HungNguyen on 2023/03/16.
//

import Foundation
import Domain

extension TeamEntity {
    func toDomainEntity() -> Team {
        return .init(id: id, name: name, logo: logo)
    }
}
