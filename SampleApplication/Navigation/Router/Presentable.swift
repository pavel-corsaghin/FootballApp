//
//  Presentable.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import UIKit

protocol Presentable {
    func toPresent() -> UIViewController?
}

extension UIViewController: Presentable {
    func toPresent() -> UIViewController? {
        return self
    }
}
