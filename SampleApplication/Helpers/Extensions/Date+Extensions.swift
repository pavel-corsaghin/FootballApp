//
//  Date+Extensions.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/15.
//

import Foundation

extension Date {
    func formatted(with format: String = "EEEE, yyyy MMM d h:mm a") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
