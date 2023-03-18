//
//  TeamDetailViewController.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/15.
//

import UIKit

protocol TeamDetailViewControllerDelegate: AnyObject {
    func teamDetailViewControllerDidDismiss()
}

final class TeamDetailViewController: BaseViewController, ViewControllable {

    // MARK: - Definitions

    typealias RootView = TeamDetailRootView
    typealias ViewModel = TeamDetailViewModel
    
    // MARK: - Properties
    
    weak var delegate: TeamDetailViewControllerDelegate?

    // MARK: - Initializers

    init(viewModel: ViewModel) {
        super.init(viewModel)
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = RootView(frame: .zero)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.getTeamDetail()
    }

    // MARK: - Setups

    override func setupViewModelInputs() {
        super.setupViewModelInputs()
    }

    override func setupViewModelOutputs() {
        super.setupViewModelOutputs()
        
        viewModel.$teamDetail
            .receive(on: mainQueue)
            .compactMap { $0?.name }
            .assign(to: \.title, on: rootView.navBar, ownership: .weak)
            .store(in: &cancellables)
        
        viewModel.$teamLogo
            .receive(on: mainQueue)
            .assign(to: \.image, on: rootView.logoImageView, ownership: .weak)
            .store(in: &cancellables)
    }
    
    override func setupActions() {
        super.setupActions()
        
        rootView.navBar.backButton.tapPublisher
            .sink { [unowned self] in delegate?.teamDetailViewControllerDidDismiss() }
            .store(in: &cancellables)
    }

    // MARK: -

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
