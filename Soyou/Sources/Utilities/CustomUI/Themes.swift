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
        UINavigationBar.appearance().tintColor = Cons.UI.colorNavBar
        UINavigationBar.appearance().isTranslucent = true
        
        // UITabBar
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().tintColor = Cons.UI.colorTab
        
        // UIToolbar
        UIToolbar.appearance().isTranslucent = true
        UIToolbar.appearance().tintColor = Cons.UI.colorToolbar
        
        // UITableViewHeaderFooterView
//        UITableViewHeaderFooterView.appearance().tintColor = UIColor.clear
        
        // UIScrollView
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
    }
}
