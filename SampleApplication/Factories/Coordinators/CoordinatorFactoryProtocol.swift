//
//  CoordinatorFactoryProtocol.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import Foundation

protocol CoordinatorFactoryProtocol {
    func makeAppCoordinator(router: Router, vcFactory: AppModuleFactory) -> AppCoordinator
}
