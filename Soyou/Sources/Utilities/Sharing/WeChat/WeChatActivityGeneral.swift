//
//  WeChatActivity.swift
//  Soyou
//
//  Created by chenglian on 15/12/13.
//  Copyright © 2015年 Soyou. All rights reserved.
//

import UIKit

class WeChatActivityGeneral: UIActivity {
    var title: String?
    var url: NSURL?
    var image: UIImage?
    var descriptions: String?
    var isSessionScene = true
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        if WXApi.isWXAppInstalled() && WXApi.isWXAppSupportApi() {
            for item in activityItems {
                if item is UIImage {
                    return true
                }
                if item is String {
                    return true
                }
                if item is NSURL {
                    return true
                }
            }
        }
        return false
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        for item in activityItems {
            if item is UIImage {
                image = item as? UIImage
            }
            if item is String {
                if (item as! String).characters.count > 128 {
                    descriptions = item as? String
                } else {
                    title = item as? String
                }
            }
            if item is NSURL {
                url = item as? NSURL
            }
        }
    }
    
    override func performActivity() {
        let message = WXMediaMessage()
        
        message.title = title
        message.description = descriptions
        
        if let url = url {// set link url
            let urlObject =  WXWebpageObject()
            urlObject.webpageUrl = url.absoluteString
            message.mediaObject = urlObject
        }
        
        if let image = image {
            if url == nil {
                let imageObject = WXImageObject()
                imageObject.imageData = UIImageJPEGRepresentation(image, 1)
                message.mediaObject = imageObject
            }
            
            message.setThumbImage(image.resizedImageByMagick("200x200#"))
        }
        
        let req =  SendMessageToWXReq()
        req.bText = false
        req.message = message
        
        if isSessionScene {
            req.scene = Int32(WXSceneSession.rawValue)
        } else {
            req.scene = Int32(WXSceneTimeline.rawValue)
        }
        
        WXApi.sendReq(req)
        self.activityDidFinish(true)
    }
}
