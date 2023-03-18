//
//  Match+Mapper.swift
//  
//
//  Created by HungNguyen on 2023/03/16.
//

import Foundation
import CoreData
import Domain

extension MatchEntity {
    func toDomainEntity() -> Match {
        return .init(
            date: date,
            description: description,
            home: home,
            away: away,
            winner: winner,
            highlights: highlights
        )
    }
}

extension Match {
    func toCoreDataEntity(context: NSManagedObjectContext, index: Int) -> CdMatchEntity {
        let cdEntity: CdMatchEntity = .init(context: context)
        cdEntity.index = Int32(index)
        cdEntity.date = date
        cdEntity.matchDescription = description
        cdEntity.home = home
        cdEntity.away = away
        cdEntity.winner = winner
        cdEntity.highlights = highlights
        return cdEntity
    }
}

extension CdMatchEntity {
    func toDomainEntity() -> Match {
        return .init(
            date: date,
            description: matchDescription,
            home: home,
            away: away,
            winner: winner,
            highlights: highlights
        )
    }
}


