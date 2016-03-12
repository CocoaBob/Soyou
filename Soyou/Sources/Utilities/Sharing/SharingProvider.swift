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
        UIActivityTypeMessage,
        UIActivityTypeMail,
        UIActivityTypePrint,
        UIActivityTypeCopyToPasteboard,
        UIActivityTypeAssignToContact,
        UIActivityTypeSaveToCameraRoll,
        UIActivityTypeAddToReadingList,
        UIActivityTypePostToFlickr,
        UIActivityTypePostToVimeo,
//        UIActivityTypePostToTencentWeibo,
        UIActivityTypeAirDrop,
//        UIActivityTypeOpenInIBooks
    ]
}