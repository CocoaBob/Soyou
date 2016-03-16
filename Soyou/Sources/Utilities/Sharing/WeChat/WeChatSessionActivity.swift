//
//  WeChatSessionActivity.swift
//  Soyou
//
//  Created by chenglian on 15/12/13.
//  Copyright © 2015年 Soyou. All rights reserved.
//

import UIKit

class WeChatSessionActivity: WeChatActivityGeneral {
    
    override class func activityCategory() -> UIActivityCategory {
        return UIActivityCategory.Share
    }
    
    override func activityType() -> String? {
        return NSBundle.mainBundle().bundleIdentifier! + ".WeChatSessionActivity"
    }
    
    override func activityTitle() -> String? {
        isSessionScene = true
        return NSLocalizedString("wechat_session", comment: "")
    }
    
    override func activityImage() -> UIImage? {
        return UIImage(named: "wechat")
    }
    
}
