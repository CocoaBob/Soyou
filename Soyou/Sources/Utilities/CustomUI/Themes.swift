//
//  Themes.swift
//  Soyou
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class Themes {
    
    class func setupAppearances() {
        // UIWindow
        UIWindow.appearance().tintColor = UIColor(rgba: Cons.UI.colorWindow)
        
        // UINavigationBar
        UINavigationBar.appearance().barStyle = .Default
        UINavigationBar.appearance().tintColor = UIColor(rgba: Cons.UI.colorNavBar)
        UINavigationBar.appearance().translucent = true
        
        // UITabBar
        UITabBar.appearance().translucent = false
        UITabBar.appearance().tintColor = UIColor(rgba: Cons.UI.colorTab)
        
        // UIToolbar
        UIToolbar.appearance().translucent = true
        UIToolbar.appearance().tintColor = UIColor(rgba: Cons.UI.colorToolbar)
    }
}
