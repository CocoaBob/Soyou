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
        UIWindow.appearance().tintColor = UIColor(rgba: "#FFB751")
        
        // UINavigationBar
        UINavigationBar.appearance().barStyle = .Black
        UINavigationBar.appearance().tintColor = UIColor(rgba: "#FFB751") // Bar tint color
        UINavigationBar.appearance().translucent = true
        
        // UITabBar
        UITabBar.appearance().translucent = false
        UITabBar.appearance().tintColor = UIColor(rgba: "#FFB751") // Bar tint color
        
        // UIToolbar
        UIToolbar.appearance().translucent = true
        UIToolbar.appearance().tintColor = UIColor(rgba: "#a0a0a0")
    }
}