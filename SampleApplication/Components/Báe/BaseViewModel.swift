//
//  BaseViewModel.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import Foundation
import Combine

class BaseViewModel {
    
    // MARK: - cancellables
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - General Outputs
    
    @Published var isLoading = false
    let presentError = PassthroughSubject<String, Never>()
    
    // MARK: - Initializers

    init() {
        setupBindings()
    }

    // MARK: - Setup

    func setupBindings() {}
}
