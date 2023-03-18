//
//  ViewControllerFactory.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import UIKit
import Domain
import Data

struct ViewControllerFactory: ViewControllerFactoryProtocol { }

extension ViewControllerFactory: AppModuleFactory {
    func makeMatchesViewController() -> MatchesViewController {
        let getMatchesUseCase = GetMatchesUseCase(matchRepository: MatchRepository())
        let vm = MatchesViewModel(getMatchesUseCase: getMatchesUseCase)
        let vc = MatchesViewController(viewModel: vm)
        return vc
    }
    
    func makeTeamDetailViewController(teamName: String) -> TeamDetailViewController {
        let getTeamDetailUseCase = GetTeamDetailUseCase(teamRepository: TeamRepository())
        let vm = TeamDetailViewModel(teamName: teamName, getTeamDetailUseCase: getTeamDetailUseCase)
        let vc = TeamDetailViewController(viewModel: vm)
        return vc
    }
}
