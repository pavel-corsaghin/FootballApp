//
//  MatchesRootView.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import UIKit

final class MatchesRootView: BaseView {

    // MARK: - Subviews

    private(set) var navBar: NavigationBar!
    private(set) var searchInputView: SearchInputView!
    private(set) var collectionView: UICollectionView!
    
    // MARK: - Setup
    
    override func setupView() {
        backgroundColor = UIColor(named: "BgPrimary")
    }
    
    override func setupSubviews() {
        navBar = NavigationBar().also {
            $0.title = "Matches"
            $0.showBackButton = false
        }
        
        searchInputView = SearchInputView()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).also {
            $0.backgroundColor = .clear
            $0.contentInset = .init(top: 10, left: 0, bottom: 10, right: 0)
            $0.keyboardDismissMode = .interactive
        }
    }

    override func setupConstraints() {
        addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.top).offset(48)
        }
        
        addSubview(searchInputView)
        searchInputView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(50)
        }
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchInputView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
