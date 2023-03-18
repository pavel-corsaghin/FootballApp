//
//  Team+Mapper.swift
//  
//
//  Created by HungNguyen on 2023/03/16.
//

import Foundation
import CoreData
import Domain

extension TeamEntity {
    func toDomainEntity() -> Team {
        return .init(id: id, name: name, logo: logo)
    }
}

extension Team {
    func toCoreDataEntity(context: NSManagedObjectContext) -> CdTeamEntity {
        let cdEntity: CdTeamEntity = .init(context: context)
        cdEntity.id = id
        cdEntity.name = name
        cdEntity.logo = logo
        return cdEntity
    }
}

extension CdTeamEntity {
    func toDomainEntity() -> Team {
        return .init(id: id, name: name, logo: logo)
    }
}
