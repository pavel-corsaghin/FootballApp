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
    
    func firstSubview<T: UIView>(ofType type: T.Type) -> T? {
        if let subview = subviews.first(where: { $0 is T }) as? T {
            return subview
        }
        return subviews.compactMap { $0.firstSubview(ofType: type) }.first
    }
}
