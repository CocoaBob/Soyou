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
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().tintColor = UIColor(rgba: "#FFB751") // Bar tint color
        UINavigationBar.appearance().barTintColor = UIColor(rgba: "#444") // Bar color
        
        // UITabBar
        UITabBar.appearance().translucent = false
        UITabBar.appearance().tintColor = UIColor(rgba: "#FFB751") // Bar tint color
//        UITabBar.appearance().barTintColor = UIColor(rgba: "#C59E6D") // Bar color
        
    }
}