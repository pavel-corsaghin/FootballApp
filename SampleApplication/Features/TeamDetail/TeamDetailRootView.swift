//
//  TeamDetailRootView.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/15.
//

import UIKit

final class TeamDetailRootView: BaseView {

    // MARK: - Subviews

    private(set) var navBar: NavigationBar!
    private(set) var logoImageView: UIImageView!

    // MARK: - Setup
    
    override func setupView() {
        backgroundColor = UIColor(named: "BgPrimary")
    }

    override func setupSubviews() {
        navBar = NavigationBar().also {
            $0.showSeparator = false
        }
        
        logoImageView = UIImageView().also {
            $0.contentMode = .scaleAspectFill
        }
    }

    override func setupConstraints() {
        addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.top).offset(48)
        }
        
        addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
