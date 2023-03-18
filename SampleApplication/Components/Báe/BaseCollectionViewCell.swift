//
//  BaseCollectionViewCell.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/14.
//

import UIKit
import Combine

class BaseCollectionViewCell: UICollectionViewCell {
    
    var cancellables = Set<AnyCancellable>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
    }

    func setup() {
        setupCell()
        setupSubviews()
        setupConstraints()
    }
    
    func setupCell() {}

    func setupSubviews() {}

    func setupConstraints() {}
}
