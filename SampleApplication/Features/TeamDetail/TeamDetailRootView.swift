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
    private var upcomingTitleLabel: UILabel!
    private(set) var collectionView: UICollectionView!

    // MARK: - Setup
    
    override func setupView() {
        backgroundColor = UIColor(named: "BgPrimary")
    }

    override func setupSubviews() {
        navBar = NavigationBar().also {
            $0.showSeparator = false
        }
        
        logoImageView = UIImageView().also {
            $0.contentMode = .scaleAspectFit
        }
        
        upcomingTitleLabel = UILabel().also {
            $0.textColor = .label
            $0.font = .systemFont(ofSize: 20, weight: .semibold)
            $0.text = "Upcoming Matches"
        }
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).also {
            $0.backgroundColor = .clear
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
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        addSubview(upcomingTitleLabel)
        upcomingTitleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(upcomingTitleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    func toggleLoadingLogo(_ isLoading: Bool) {
        if isLoading {
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            logoImageView.addSubview(activityIndicator)
            activityIndicator.snp.makeConstraints { $0.center.equalToSuperview() }
            activityIndicator.startAnimating()
        } else {
            logoImageView.firstSubview(ofType: UIActivityIndicatorView.self)?.removeFromSuperview()
        }
    }
}
