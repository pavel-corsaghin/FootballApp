//
//  AppCoordinator.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import Foundation

final class AppCoordinator: BaseCoordinator {

    // MARK: - Properties

    private let router: Router
    private let vcFactory: AppModuleFactory

    // MARK: - Initializers

    init(router: Router, vcFactory: AppModuleFactory) {
        self.router = router
        self.vcFactory = vcFactory
    }

    // MARK: - Coordination

    override func start() {
        showMatchesVC()
    }
    
    // MARK: - Flows

    private func showMatchesVC() {
        let vc = vcFactory.makeMatchesViewController().also {
            $0.delegate = self
        }        
        router.setRootModule(vc, hideBar: true)
    }
    
    private func showTeamDetailVC(teamName: String) {
        let vc = vcFactory.makeTeamDetailViewController(teamName: teamName).also {
            $0.delegate = self
        }
        router.push(vc)
    }
}

// MARK: - MatchesViewControllerDelegate

extension AppCoordinator: MatchesViewControllerDelegate {
    func matchesViewControllerDidViewTeamDetail(teamName: String) {
        showTeamDetailVC(teamName: teamName)
    }
}

// MARK: - TeamDetailViewControllerDelegate

extension AppCoordinator: TeamDetailViewControllerDelegate {
    func teamDetailViewControllerDidViewTeamDetail(teamName: String) {
        showTeamDetailVC(teamName: teamName)
    }
    
    func teamDetailViewControllerDidDismiss() {
        router.popModule()
    }
}
