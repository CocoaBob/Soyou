//
//  SDWebImageManager+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 2018-01-06.
//  Copyright © 2018 Soyou. All rights reserved.
//

class SDWebImageManagerDelegateHandler: NSObject, SDWebImageManagerDelegate {
    
    static let shared = SDWebImageManagerDelegateHandler()
    
    func imageManager(_ imageManager: SDWebImageManager, transformDownloadedImage image: UIImage?, with imageURL: URL?) -> UIImage? {
        if let image = image {
            if image.size.width > 1080 && image.size.height > 1080 {
                return image.resizedImage(byMagick: "1080x1080^")
            }
        }
        return image
    }
}
