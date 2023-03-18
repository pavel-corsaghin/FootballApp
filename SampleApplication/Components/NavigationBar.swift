//
//  NavigationBar.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import UIKit

final class NavigationBar: BaseView {

    // MARK: - Properties
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    var showSeparator: Bool = true {
        didSet {
            separator.isHidden = !showSeparator
        }
    }
    
    var showBackButton: Bool = true {
        didSet {
            toggleBackButtonVisibility()
        }
    }

    // 1st right bar button
    var right1stButtonImage: UIImage? {
        didSet {
            right1stButton.isHidden = false
            right1stButton.setImage(right1stButtonImage, for: .normal)
        }
    }
    
    var right1stButtonTitleText: String? {
        didSet {
            right1stButton.isHidden = false
            right1stButton.setTitle(right1stButtonTitleText, for: .normal)
        }
    }
    
    var right1stButtonTextColor: UIColor? {
        didSet {
            right1stButton.setTitleColor(right1stButtonTextColor, for: .normal)
        }
    }

    // 2nd right bar button
    var right2ndButtonImage: UIImage? {
        didSet {
            right2ndButton.isHidden = false
            right2ndButton.setImage(right2ndButtonImage, for: .normal)
        }
    }
    var right2ndButtonTitleText: String? {
        didSet {
            right2ndButton.isHidden = false
            right2ndButton.setTitle(right2ndButtonTitleText, for: .normal)
        }
    }
    
    var right2ndButtonTextColor: UIColor? {
        didSet {
            right2ndButton.setTitleColor(right2ndButtonTextColor, for: .normal)
        }
    }

    // MARK: - Subviews

    private(set) lazy var backButton = UIButton(type: .system).also {
        $0.setImage(UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal), for: .normal)
    }

    private lazy var titleLabel = UILabel().also {
        $0.textColor = .label
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textAlignment = .center
    }

    private(set) lazy var right1stButton = UIButton(type: .system).also {
        $0.isHidden = true
    }

    private(set) lazy var right2ndButton = UIButton(type: .system).also {
        $0.isHidden = true
    }

    private lazy var buttonStack = UIStackView(arrangedSubviews: [
        right1stButton,
        right2ndButton
    ]).also {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .center
        $0.spacing = 20
    }

    private lazy var separator = UIView().also {
        $0.backgroundColor = .separator
    }

    // MARK: - Setup
    
    override func setupView() {
        backgroundColor = .white
    }
    
    override func setupSubviews() {
        addSubviews(backButton, titleLabel, buttonStack, separator)
    }

    override func setupConstraints() {
        backButton.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(12)
            make.size.equalTo(28)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.leading.trailing.equalToSuperview().inset(60)
        }

        buttonStack.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.trailing.equalToSuperview().inset(20)
        }

        separator.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.height.equalTo(0.6)
        }
    }
    
    func toggleBackButtonVisibility() {
        if showBackButton {
            backButton.snp.remakeConstraints { make in
                make.leading.bottom.equalToSuperview().inset(12)
                make.size.equalTo(28)
            }
            backButton.isHidden = false
        } else {
            backButton.snp.remakeConstraints { make in
                make.leading.bottom.equalToSuperview().inset(12)
                make.height.equalTo(28)
                make.width.equalTo(8)
            }
            backButton.isHidden = true
        }
    }
}
