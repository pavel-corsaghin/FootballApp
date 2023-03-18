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
    @Published private(set) var searchedMatches: [Match] = []
    @Published var searchKeyword: String?
    
    // MARK: - Initializer
    
    init(getMatchesUseCase: GetMatchesUseCaseProtocol) {
        self.getMatchesUseCase = getMatchesUseCase
        super.init()
        
        getMatches()
    }
    
    override func setupBindings() {
        Publishers.CombineLatest(
            $originalMatches,
            $searchKeyword
                .replaceNil(with: "")
                .map { $0.lowercased() }
                .removeDuplicates()
        )
        .receive(on: backgroundQueue)
        .map { matches, keyword in
            if keyword.isEmpty {
                return matches
            }
            
            return matches.filter { match in
                guard let home = match.home?.lowercased(),
                      let away = match.away?.lowercased()
                else {
                    return false
                }
                
                return home.contains(keyword) || away.contains(keyword)
            }
        }
        .assign(to: \.searchedMatches, on: self, ownership: .weak)
        .store(in: &cancellables)
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
                receiveValue: { [weak self] matches in
                    guard let self = self else {
                        return
                    }
                    
                    self.isLoading = false
                    self.originalMatches = matches.sorted(by: { lhs, rhs in
                        guard let lhsDate = lhs.date?.toDate(),
                              let rhsDate = rhs.date?.toDate()
                        else {
                            return true
                        }
                        
                        return lhsDate > rhsDate
                    })
                }
            )
            .store(in: &cancellables)
    }
}
