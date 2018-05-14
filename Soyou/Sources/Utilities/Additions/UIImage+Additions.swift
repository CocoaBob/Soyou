//
//  UIImage+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 2018-04-18.
//  Copyright © 2018 Soyou. All rights reserved.
//

extension UIImage {
    
    func rotated() -> UIImage {
        UIGraphicsBeginImageContext(size)
        draw(at: .zero)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage ?? self
    }
}
