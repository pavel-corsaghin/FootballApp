//
//  String+Extensions.swift
//  SampleApplication
//
//  Created by HungNguyen on 2023/03/15.
//

import Foundation

extension String {
    
    func toDate(with format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
