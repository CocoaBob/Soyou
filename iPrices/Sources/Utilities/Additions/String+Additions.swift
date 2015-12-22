//
//  String+Additions.swift
//  iPrices
//
//  Created by CocoaBob on 17/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

// MARK: Email
extension String {

    func isEmail() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .CaseInsensitive)
            return regex.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
}