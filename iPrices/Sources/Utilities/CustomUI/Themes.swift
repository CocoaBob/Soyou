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
        UIWindow.appearance().tintColor = UIColor(rgba: Cons.UI.colorMain)
        
        // UINavigationBar
        UINavigationBar.appearance().barStyle = .Black
        UINavigationBar.appearance().tintColor = UIColor(rgba: Cons.UI.colorMain) // Bar tint color
        UINavigationBar.appearance().barTintColor = UIColor(white: 0.1, alpha: 0.0)
        UINavigationBar.appearance().translucent = true
        
        // UITabBar
        UITabBar.appearance().translucent = false
        UITabBar.appearance().tintColor = UIColor(rgba: Cons.UI.colorMain) // Bar tint color
        
        // UIToolbar
        UIToolbar.appearance().translucent = true
        UIToolbar.appearance().tintColor = UIColor(rgba: "#a0a0a0")
    }
}