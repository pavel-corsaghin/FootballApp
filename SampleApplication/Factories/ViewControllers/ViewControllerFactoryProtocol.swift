//
//  ViewControllerFactoryProtocol.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import UIKit

protocol ViewControllerFactoryProtocol: AppModuleFactory {}

protocol AppModuleFactory {
    func makeMatchesViewController() -> MatchesViewController
    func makeTeamDetailViewController(teamName: String) -> TeamDetailViewController
}
