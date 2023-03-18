//
//  UIView+Extensions.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        for view in views {
            addSubview(view)
        }
    }
}
