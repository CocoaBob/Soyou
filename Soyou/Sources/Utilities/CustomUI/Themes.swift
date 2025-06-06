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
        UIWindow.appearance().tintColor = Cons.UI.colorWindow
        
        // UINavigationBar
        UINavigationBar.appearance().barStyle = .default
        UINavigationBar.appearance().isOpaque = true
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = Cons.UI.colorNavBar
        UINavigationBar.appearance().backgroundColor = Cons.UI.colorBG
        
        // UITabBar
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = Cons.UI.colorTab
        
        // UIToolbar
        UIToolbar.appearance().isTranslucent = true
        UIToolbar.appearance().tintColor = Cons.UI.colorToolbar
        
        // UIScrollView
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .always
        }
    }
}
