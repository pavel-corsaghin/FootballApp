//
//  MatchesViewModel.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import Foundation
import Combine
import Domain
import Data

final class MatchesViewModel: BaseViewModel {
    
    // MARK: - Properties
    
    private let getMatchesUseCase: GetMatchesUseCaseProtocol
    @Published private var originalMatches: [Match] = []
    @Published private(set) var snapshot: MatchSnapshot?
    @Published var selectedTab: MatchType = .previous
    @Published var searchKeyword: String?

    // MARK: - Initializer
    
    init(getMatchesUseCase: GetMatchesUseCaseProtocol) {
        self.getMatchesUseCase = getMatchesUseCase
        super.init()
        
        getMatches()
    }
    
    override func setupBindings() {
        Publishers.CombineLatest3(
            $originalMatches,
            $selectedTab,
            $searchKeyword
                .replaceNil(with: "")
                .map { $0.lowercased() }
                .removeDuplicates()
        )
        .receive(on: backgroundQueue)
        .compactMap { [weak self] in self?.generateFilteredMatches($0, $1, $2) }
        .map { [weak self] in self?.generateSnapshot($0)}
        .assign(to: \.snapshot, on: self, ownership: .weak)
        .store(in: &cancellables)
    }
    
    private func generateFilteredMatches(_ matches: [Match],
                                         _ selectedTab: MatchType,
                                         _ keyword: String) -> [Match] {
        // Filter by type
        let matchesByType = matches.filter { $0.type == selectedTab }
        
        // Filter by searching keyword
        guard !keyword.isEmpty else {
            return matchesByType
        }
        
        return matchesByType.filter { match in
            guard let home = match.home?.lowercased(),
                  let away = match.away?.lowercased()
            else {
                return false
            }
            
            return home.contains(keyword) || away.contains(keyword)
        }
    }
    
    private func generateSnapshot(_ matches: [Match]) -> MatchSnapshot {
        var snapshot = MatchSnapshot()
        let cellModels = matches.map(MatchCell.CellModel.init)
        snapshot.appendSections([.main])
        snapshot.appendItems(cellModels.map { .match($0) })
        return snapshot
    }
    
    // MARK: - Actions
    
    func getMatches() {
        isLoading = true
        getMatchesUseCase.execute()
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else {
                        return
                    }
                    
                    if case .failure(let error) = completion {
                        if let networkError = error as? NetworkError {
                            self.presentError.send(networkError.description)
                        }
                    }
                    self.isLoading = false
                },
                receiveValue: { [weak self] in self?.originalMatches = $0 }
            )
            .store(in: &cancellables)
    }
}

extension Match {
    var type: MatchType {
       return winner != nil ? .previous : .upcoming
    }
}
