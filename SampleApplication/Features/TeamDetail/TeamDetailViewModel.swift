//
//  TeamDetailViewModel.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/15.
//

import UIKit
import Combine
import Domain
import Data

final class TeamDetailViewModel: BaseViewModel {

    // MARK: - Properties
    
    let teamName: String
    private let getTeamDetailUseCase: GetTeamDetailUseCaseProtocol
    private let getMatchesUseCase: GetMatchesUseCaseProtocol
    @Published private(set) var teamDetail: Team?
    @Published private(set) var teamLogo: UIImage?
    @Published private(set) var snapshot: MatchSnapshot?
    @Published private(set) var isLoadingLogo = false

    // MARK: - Initializer

    init(teamName: String,
         getTeamDetailUseCase: GetTeamDetailUseCaseProtocol,
         getMatchesUseCase: GetMatchesUseCaseProtocol)
    {
        self.teamName = teamName
        self.getTeamDetailUseCase = getTeamDetailUseCase
        self.getMatchesUseCase = getMatchesUseCase
        
        super.init()
    }
    
    // MARK: - Setup
    
    override func setupBindings() {
        $teamDetail
            .compactMap { $0?.logo }
            .removeDuplicates()
            .sink { [weak self] in self?.loadTeamLogo($0) }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    func getTeamDetail() {
        isLoading = true
        getTeamDetailUseCase.execute(teamName: teamName)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else {
                        return
                    }
                    if case .failure(let error) = completion {
                        let errorMessage = (error as? NetworkError)?.description ?? error.localizedDescription
                        self.presentError.send(errorMessage)
                    }
                    self.isLoading = false
                },
                receiveValue: { [weak self] in self?.teamDetail = $0 }
            )
            .store(in: &cancellables)
    }
    
    func getTeamUpcomingMatches() {
        getMatchesUseCase.execute()
            .filterMany { [weak self] match in
                guard let teamName = self?.teamName else {
                    return false
                }
                
                return match.home == teamName || match.away == teamName
            }
            .replaceError(with: [])
            .map { [weak self] in self?.generateSnapshot($0) }
            .assign(to: \.snapshot, on: self, ownership: .weak)
            .store(in: &cancellables)
    }
    
    private func generateSnapshot(_ matches: [Match]) -> MatchSnapshot {
        var snapshot = MatchSnapshot()
        let cellModels = matches.map(MatchCell.CellModel.init)
        snapshot.appendSections([.main])
        snapshot.appendItems(cellModels.map { .match($0) })
        return snapshot
    }
    
    private func loadTeamLogo(_ logoUrl: String) {
        isLoadingLogo = true
        ImageLoader.shared.loadImage(from: logoUrl)
            .sink { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.teamLogo = $0
                self.isLoadingLogo = false
            }
            .store(in: &cancellables)
    }
}
