//
//  ViewControllable.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import UIKit

protocol ViewControllable {
    associatedtype RootView: UIView
    associatedtype ViewModel: BaseViewModel
}

extension ViewControllable where Self: BaseViewController {
    var rootView: RootView {
        guard let rootView = view as? RootView else {
            fatalError("Expected rootView to be of type \(RootView.self) but got \(type(of: view)) instead")
        }

        return rootView
    }
    
    var viewModel: ViewModel {
        guard let viewModel = viewModel as? ViewModel else {
            fatalError("Expected viewModel to be of type \(ViewModel.self) but got \(type(of: view)) instead")
        }

        return viewModel
    }
}
