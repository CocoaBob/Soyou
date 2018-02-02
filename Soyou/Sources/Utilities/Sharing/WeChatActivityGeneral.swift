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
    var imageDatas = [Data]()
    var descriptions: String?
    var isSessionScene = true
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        if WXApi.isWXAppInstalled() && WXApi.isWXAppSupport() {
            return true
        }
        return false
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        for item in activityItems {
            if let item = item as? Data {
                imageDatas.append(item)
            } else if let item = item as? UIImage {
                image = item
            } else if let item = item as? String {
                if item.count > 128 {
                    descriptions = item
                } else {
                    title = item
                }
            } else if let item = item as? URL {
                url = item
            }
        }
    }
    
    override func perform() {
        // Switch to another app to hide the name
        DDSocialShareHandler.sharedInstance().register(.weChat, appKey: "wx0cb0066522588a9c", appSecret: "139362fbfbd0d23011626cd4d4c44782", redirectURL: "", appDescription: "")
        
        let message = WXMediaMessage()
        
        message.title = title
        message.description = descriptions
        
        if let url = url {
            let urlObject =  WXWebpageObject()
            urlObject.webpageUrl = url.absoluteString
            message.mediaObject = urlObject
        }
        
        if imageDatas.count > 0 && url == nil {
            image = createLongImage(imageDatas: imageDatas)
        }
        
        if let image = image {
            if url == nil {
                let imageObject = WXImageObject()
                imageObject.imageData = UIImageJPEGRepresentation(image, 0.7)
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
        
        // Switch back to Soyou
        DDSocialShareHandler.sharedInstance().register(.weChat, appKey: "wxe3346afe30577009", appSecret: "485df03e708c879eea75686ce3432ab0", redirectURL: "", appDescription: "")
        
        self.activityDidFinish(true)
    }
    
    func createLongImage(imageDatas: [Data]) -> UIImage? {
        if imageDatas.isEmpty {
            return nil
        } else if imageDatas.count == 1 {
            return UIImage(data: imageDatas[0])
        }
        let width = CGFloat(1080)
        let images = imageDatas.flatMap { UIImage(data: $0) }
        let sizes = images.map { CGSize(width: width, height: width * $0.size.height / $0.size.width) }
        let height = sizes.reduce(0) { $0 + $1.height }
        var currentY = CGFloat(0)
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        if let context = UIGraphicsGetCurrentContext() {
            UIGraphicsPushContext(context)
        }
        for i in 0..<images.count {
            let image = images[i]
            let size = sizes[i]
            let rect = CGRect(x: 0, y: currentY, width: size.width, height: size.height)
            image.draw(in: rect)
            currentY += size.height
        }
        UIGraphicsPopContext()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
