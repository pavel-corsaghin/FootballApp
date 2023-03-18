//
//  BaseViewController.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import UIKit
import Combine
import CombineCocoa
import CombineExt

class BaseViewController: UIViewController {
    
    // MARK: - Properties

    let viewModel: BaseViewModel
    var cancellables = Set<AnyCancellable>()
    private var activityIndicator: UIActivityIndicatorView?
    
    // MARK: - Status Bar

    override var preferredStatusBarStyle: UIStatusBarStyle { .lightContent }
    
    // MARK: - Initializer

    init(_ viewModel: BaseViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
    }
    
    // MARK: - Setups
    
    private func setupBindings() {
        setupActions()
        setupViewModelInputs()
        setupViewModelOutputs()
    }

    func setupActions() {}

    func setupViewModelInputs() {}

    func setupViewModelOutputs() {
        viewModel.$isLoading
            .removeDuplicates()
            .receive(on: mainQueue)
            .sink { [weak self] in self?.toggleLoading($0) }
            .store(in: &cancellables)

        viewModel.presentError
            .receive(on: mainQueue)
            .sink { [weak self] in self?.presentErrorAlert($0) }
            .store(in: &cancellables)
    }

    deinit {
        print("Deinit ===> \(self.description)")
    }
    
    // MARK: -

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BaseViewController {
    
    func toggleLoading(_ isLoading: Bool) {
        if isLoading {
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            view.addSubview(activityIndicator)
            activityIndicator.center = view.center
            activityIndicator.startAnimating()
            self.activityIndicator = activityIndicator
        } else {
            activityIndicator?.removeFromSuperview()
            activityIndicator = nil
        }
    }

    func presentErrorAlert(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))

        present(alertController, animated: true, completion: nil)
    }
    
    func addKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}
