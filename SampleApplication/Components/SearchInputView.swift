//
//  SearchInputView.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/15.
//

import UIKit

final class SearchInputView: BaseView {
    
    // MARK: - Subviews
    
    private(set) var textField: UITextField!
    private var searchImageView: UIImageView!
    
    // MARK: - Setups
    
    override func setupView() {
        layer.cornerRadius = 12
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.separator.cgColor
    }
    
    override func setupSubviews() {
        textField = UITextField().also {
            $0.placeholder = "Search matches by teams"
            $0.font = .systemFont(ofSize: 14, weight: .regular)
            $0.textColor = .label
        }
        
        searchImageView = UIImageView().also {
            $0.image = UIImage(named: "iconSearch")
        }
    }
    
    override func setupConstraints() {
        addSubview(searchImageView)
        searchImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(18)
        }
        
        addSubview(textField)
        textField.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalTo(searchImageView.snp.trailing).offset(8)
        }
    }
}
