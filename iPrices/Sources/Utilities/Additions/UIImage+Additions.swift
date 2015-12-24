//
//  UIImage+Additions.swift
//  iPrices
//
//  Created by CocoaBob on 24/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

public extension UIImage {
    
    convenience init(color: UIColor, opaque: Bool) {
        let rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, opaque, 1)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(CGImage: image.CGImage!)
    }
    
    class func imageWithRandomColor() -> UIImage {
        return UIImage(color: randomColor(hue: .Random, luminosity: .Light), opaque: true)
    }
}