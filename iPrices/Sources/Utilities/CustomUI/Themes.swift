//
//  Themes.swift
//  iPrices
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class Themes {
    
    class func setupAppearances() {
        // UIWindow
//        UIWindow.appearance().tintColor = UIColor(rgba: "#F3DE9C")
        
        // UINavigationBar
        UINavigationBar.appearance().barStyle = .Black
        UINavigationBar.appearance().tintColor = UIColor(rgba: "#FFB751") // Bar tint color
//        if let bgImage = UIImage(named: "img_bg_nav_bar")?.resizableImageWithCapInsets(UIEdgeInsetsZero, resizingMode: .Stretch),
//            let bgImageCompact = UIImage(named: "img_bg_nav_bar_compact")?.resizableImageWithCapInsets(UIEdgeInsetsZero, resizingMode: .Stretch) {
//                UINavigationBar.appearance().setBackgroundImage(bgImage, forBarMetrics: .Default)
//                UINavigationBar.appearance().setBackgroundImage(bgImageCompact, forBarMetrics: .Compact)
//                UINavigationBar.appearance().translucent = false
//        } else {
            UINavigationBar.appearance().translucent = true
//        }
//        UINavigationBar.appearance().barTintColor = UIColor(rgba: "#444") // Bar color
        
        // UITabBar
        UITabBar.appearance().translucent = true
//        UITabBar.appearance().barStyle = .Black
        UITabBar.appearance().tintColor = UIColor(rgba: "#FFB751") // Bar tint color
//        UITabBar.appearance().barTintColor = UIColor(rgba: "#C59E6D") // Bar color
        
        // UIToolbar
        UIToolbar.appearance().translucent = true
        UIToolbar.appearance().tintColor = UIColor(rgba: "#FFB751")
    }
}