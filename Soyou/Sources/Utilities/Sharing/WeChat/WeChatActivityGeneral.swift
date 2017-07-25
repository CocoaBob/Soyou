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
    var url: URL?
    var image: UIImage?
    var descriptions: String?
    var isSessionScene = true
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        if WXApi.isWXAppInstalled() && WXApi.isWXAppSupport() {
            for item in activityItems {
                if item is UIImage {
                    return true
                }
                if item is String {
                    return true
                }
                if item is URL {
                    return true
                }
            }
        }
        return false
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        for item in activityItems {
            if item is UIImage {
                image = item as? UIImage
            }
            if let item = item as? String {
                if item.characters.count > 128 {
                    descriptions = item
                } else {
                    title = item
                }
            }
            if item is URL {
                url = item as? URL
            }
        }
    }
    
    override func perform() {
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
            
            message.setThumbImage(image.resizedImage(byMagick: "200x200#"))
        }
        
        let req =  SendMessageToWXReq()
        req.bText = false
        req.message = message
        
        if isSessionScene {
            req.scene = Int32(WXSceneSession.rawValue)
        } else {
            req.scene = Int32(WXSceneTimeline.rawValue)
        }
        
        WXApi.send(req)
        self.activityDidFinish(true)
    }
}
