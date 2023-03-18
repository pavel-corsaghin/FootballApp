//
//  TeamRepository.swift
//  
//
//  Created by HungNguyen on 2023/03/15.
//

import Foundation
import Combine

public protocol TeamRepositoryProtocol {
    func getTeams() -> AnyPublisher<[Team], Error>
    func getTeam(id: String) -> AnyPublisher<Team, Error>
}
