//
//  Coordinator.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import Foundation

/// Objects conforming to Coordinator are in charge of managing the flow between different modules and other coordinators
protocol Coordinator: AnyObject {
    func start()
}
