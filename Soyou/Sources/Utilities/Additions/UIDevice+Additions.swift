//
//  UIDevice+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 2017-11-20.
//  Copyright © 2017 Soyou. All rights reserved.
//

extension UIDevice {
    
    static func isX() -> Bool {
        if #available(iOS 11.0, *) {
            return UIScreen.main.bounds.height == 812
        } else {
            return false
        }
    }
}
