//
//  BannedKeywords.swift
//  Soyou
//
//  Created by CocoaBob on 2018-05-09.
//  Copyright © 2018 Soyou. All rights reserved.
//

import Foundation
import UIKit

class BannedKeywords {
    
    private let kBannedKeywords = "kBannedKeywords"
    private let kLastUpdateDate = "kLastUpdateDate"
    
    private lazy var keywords: Set<String> = {
        let storedKeywords = UserDefaults.standard.object(forKey: kBannedKeywords) as? [String]
        if let storedKeywords = storedKeywords {
            return Set(storedKeywords)
        } else {
            return Set<String>()
        }
    }()
    
    private lazy var updateDate: Date = {
        let date = UserDefaults.standard.object(forKey: kLastUpdateDate) as? Date
        if let date = date {
            return date
        } else {
            return Date.distantPast
        }
    }()
    
    static let shared = BannedKeywords()
}

// MARK: - Methods
extension BannedKeywords {
    
    fileprivate func test(_ string: String?) -> Bool {
        guard !self.keywords.isEmpty else { return false }
        guard var string = string else { return false }
        string = String(String.UnicodeScalarView(string.unicodeScalars.filter({ CharacterSet.letters.contains($0) })))
        for keyword in self.keywords {
            if string.contains(keyword) {
                return true
            }
        }
        return false
    }
    
    static func censorThenDo(_ content: String?, _ completion: (()->())?) {
        if content?.containsBannedKeywords() ?? false {
            let alertController = UIAlertController(title: nil, message: localized("forbidden_content_alert"), preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: localized("alert_button_ok"),
                                                    style: UIAlertActionStyle.default,
                                                    handler: nil))
            var presentingVC = UIApplication.shared.keyWindow?.rootViewController
            if let presentedVC = presentingVC?.presentedViewController {
                presentingVC = presentedVC
            }
            presentingVC?.present(alertController, animated: true, completion: nil)
        } else {
            completion?()
        }
    }
}

// MARK: - Helper
extension String {
    
    fileprivate func containsBannedKeywords() -> Bool {
        if self.isEmpty {
            return false
        }
        return BannedKeywords.shared.test(self)
    }
    
    func censored() -> String {
        if self.containsBannedKeywords() {
            return localized("forbidden_content")
        }
        return self
    }
}
