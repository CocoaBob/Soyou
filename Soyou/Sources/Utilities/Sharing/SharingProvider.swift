//
//  SharingProvider.swift
//  Soyou
//
//  Created by chenglian on 15/12/19.
//  Copyright © 2015年 Soyou. All rights reserved.
//

import Foundation

class SharingProvider {
    
    static let excludedActivityTypes = [
//        UIActivityTypePostToFacebook,
//        UIActivityTypePostToTwitter,
//        UIActivityTypePostToWeibo, // SinaWeibo
        UIActivityType.message,
        UIActivityType.mail,
        UIActivityType.print,
        UIActivityType.copyToPasteboard,
        UIActivityType.assignToContact,
        UIActivityType.saveToCameraRoll,
        UIActivityType.addToReadingList,
        UIActivityType.postToFlickr,
        UIActivityType.postToVimeo,
//        UIActivityType.postToTencentWeibo,
        UIActivityType.airDrop,
//        UIActivityType.openInIBooks
    ]
}
