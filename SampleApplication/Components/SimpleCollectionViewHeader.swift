//
//  SimpleCollectionViewHeader.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/15.
//

import UIKit

class SimpleCollectionViewHeader: BaseCollectionViewCell {

    // MARK: - Subviews

    private var titleLabel: UILabel!

    // MARK: - Setup

    override func setupCell() {
        backgroundColor = .clear
    }
    
    override func setupSubviews() {
        titleLabel = UILabel().also {
            $0.textColor = .label
            $0.font = .systemFont(ofSize: 18, weight: .semibold)
        }
    }

    override func setupConstraints() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerY.leading.trailing.equalToSuperview()
        }
    }
    
    func configureCell(_ title: String) {
        titleLabel.text = title
    }
}
