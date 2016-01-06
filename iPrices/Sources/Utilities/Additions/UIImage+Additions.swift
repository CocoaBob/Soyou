//
//  UIImage+Additions.swift
//  iPrices
//
//  Created by CocoaBob on 24/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

public extension UIImage {
    
    convenience init(size: CGSize?, color: UIColor, opaque: Bool) {
        let rect = (size != nil) ? CGRectMake(0, 0, size!.width, size!.height) : CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, opaque, 1)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(CGImage: image.CGImage!)
    }
    
    class func imageWithRandomColor(size: CGSize?) -> UIImage {
        return UIImage(size: size, color: randomColor(hue: .Random, luminosity: .Light), opaque: true)
    }
}