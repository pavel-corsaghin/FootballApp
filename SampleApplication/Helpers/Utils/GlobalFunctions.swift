//
//  GlobalFunctions.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/13.
//

import Foundation

let backgroundQueue = DispatchQueue.global(qos: .background)
let mainQueue = DispatchQueue.main

func asyncAfter(_ delay: Double, in queue: DispatchQueue = mainQueue, closure: @escaping () -> Void) {
    queue.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
        execute: closure
    )
}

func async(in queue: DispatchQueue = mainQueue, closure: @escaping () -> Void) {
    queue.async(execute: closure)
}

func sync(in queue: DispatchQueue, closure: @escaping () -> Void) {
    queue.sync(execute: closure)
}
