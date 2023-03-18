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
    
    private let teamName: String
    private let getTeamDetailUseCase: GetTeamDetailUseCaseProtocol
    @Published private(set) var teamDetail: Team?
    @Published private(set) var teamLogo: UIImage?

    // MARK: - Initializer

    init(teamName: String, getTeamDetailUseCase: GetTeamDetailUseCaseProtocol) {
        self.teamName = teamName
        self.getTeamDetailUseCase = getTeamDetailUseCase
        super.init()
    }
    
    // MARK: - Setup
    
    override func setupBindings() {
        $teamDetail
            .compactMap { $0?.logo }
            .removeDuplicates()
            .delay(for: .seconds(0.1), scheduler: backgroundQueue)
            .sink { [weak self] in self?.getTeamLogo($0) }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    func getTeamDetail() {
        isLoading = true
        getTeamDetailUseCase.execute(teamName: teamName)
            .sink(
                receiveCompletion: {[weak self] completion in
                    guard let self = self else {
                        return
                    }
                    if case .failure(let error) = completion {
                        let errorMessage = (error as? NetworkError)?.description ?? error.localizedDescription
                        self.presentError.send(errorMessage)
                    }
                    self.isLoading = false
                },
                receiveValue: {[weak self] in self?.teamDetail = $0 }
            )
            .store(in: &cancellables)
    }
    
    private func getTeamLogo(_ logoUrl: String) {
        isLoading = true
        ImageLoader.shared.loadImage(from: logoUrl)
            .sink { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.teamLogo = $0
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
}
