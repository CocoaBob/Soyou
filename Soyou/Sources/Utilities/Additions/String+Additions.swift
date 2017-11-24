//
//  String+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 17/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

// MARK: Email
extension String {

    func isEmail() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.count)) != nil
        } catch {
            return false
        }
    }
}
