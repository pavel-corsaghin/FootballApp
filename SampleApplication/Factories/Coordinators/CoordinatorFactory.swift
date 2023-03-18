//
//  CoordinatorFactory.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import Foundation

struct CoordinatorFactory: CoordinatorFactoryProtocol {
    func makeAppCoordinator(router: Router, vcFactory: AppModuleFactory) -> AppCoordinator {
        return AppCoordinator(router: router, vcFactory: vcFactory)
    }
}
