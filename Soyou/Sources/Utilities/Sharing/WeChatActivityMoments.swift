//
//  WeChatActivityMoments.swift
//  Soyou
//
//  Created by chenglian on 15/12/13.
//  Copyright © 2015年 Soyou. All rights reserved.
//

import UIKit

class WeChatActivityMoments: WeChatActivityGeneral {
    
    override class var activityCategory : UIActivityCategory {
        return UIActivityCategory.share
    }
    
    override var activityType : UIActivityType? {
        return UIActivityType(rawValue: Bundle.main.bundleIdentifier! + ".WeChatActivityMoments")
    }
    
    override var activityTitle : String? {
        isSessionScene = false
        return NSLocalizedString("wechat_moments", comment: "")
    }
    
    override var activityImage : UIImage? {
        return UIImage(named: "wechat_moments")
    }
}
