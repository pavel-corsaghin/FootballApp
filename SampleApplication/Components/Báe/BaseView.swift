//
//  BaseView.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import UIKit
import Combine
import SnapKit

class BaseView: UIView {
    
    // MARK: - Properties
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    // MARK: - Setup

    func setup() {
        setupView()
        setupSubviews()
        setupConstraints()
    }
    
    func setupView() {}

    func setupSubviews() {}

    func setupConstraints() {}
    
    @available(*, unavailable, message: "Don't use init(coder:), override init(frame:)")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
