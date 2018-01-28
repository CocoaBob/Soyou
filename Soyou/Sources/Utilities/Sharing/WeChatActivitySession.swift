//
//  WeChatActivitySession.swift
//  Soyou
//
//  Created by chenglian on 15/12/13.
//  Copyright © 2015年 Soyou. All rights reserved.
//

import UIKit

class WeChatActivitySession: WeChatActivityGeneral {
    
    override class var activityCategory : UIActivityCategory {
        return UIActivityCategory.share
    }
    
    override var activityType : UIActivityType? {
        return UIActivityType(rawValue: Bundle.main.bundleIdentifier! + ".WeChatActivitySession")
    }
    
    override var activityTitle : String? {
        isSessionScene = true
        return NSLocalizedString("wechat_session", comment: "")
    }
    
    override var activityImage : UIImage? {
        return UIImage(named: "wechat")
    }
}
