//
//  WeChatActivity.swift
//  iPrices
//
//  Created by chenglian on 15/12/13.
//  Copyright © 2015年 iPrices. All rights reserved.
//

import UIKit

class WeChatActivityGeneral: UIActivity {
    var text:String!
    var url:NSURL?
    var image:UIImage!
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
                image = item as! UIImage
            }
            if item is String {
                text = item as! String
            }
            if item is NSURL {
                url = item as? NSURL
            }
        }
    }
    
    override func performActivity() {
        let message = WXMediaMessage()
        
        message.title = text
        message.description = "TODO TODO"
        
        if url !== nil {// set link url
            let urlObject =  WXWebpageObject()
            urlObject.webpageUrl = url!.absoluteString
            message.mediaObject = urlObject
        } else {// set image
            let imageObject = WXImageObject()
            imageObject.imageData = UIImageJPEGRepresentation(image, 1)
            message.mediaObject = imageObject
        }
        
        // set the size of thumbnail image from original UIImage data
        let width = 240.0 as CGFloat
        let height = width*image.size.height/image.size.width
        UIGraphicsBeginImageContext(CGSizeMake(width, height))
        image.drawInRect(CGRectMake(0, 0, width, height))
        message.setThumbImage(UIGraphicsGetImageFromCurrentImageContext())
        UIGraphicsEndImageContext()
        
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
