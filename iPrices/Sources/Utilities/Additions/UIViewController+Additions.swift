//
//  UIViewController+Additions.swift
//  iPrices
//
//  Created by CocoaBob on 09/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

extension UIViewController {
    
    func hideTabBar(animated: Bool) {
        if let tabBar = self.tabBarController?.tabBar {
            var frame = tabBar.frame
            frame.origin.y = CGRectGetMaxY(self.view.frame)
            if frame != tabBar.frame {
                UIView.animateWithDuration(0.25) { () -> Void in
                    tabBar.frame = frame
                }
            }
        }
    }
    
    func showTabBar(animated: Bool) {
        if let tabBar = self.tabBarController?.tabBar {
            var frame = tabBar.frame
            frame.origin.y = CGRectGetMaxY(self.view.frame) - CGRectGetHeight(frame)
            if frame != tabBar.frame {
                if animated {
                    UIView.animateWithDuration(0.25) { () -> Void in
                        tabBar.frame = frame
                    }
                } else {
                    tabBar.frame = frame
                }
            }
        }
    }
    
    func hideToolbar(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: animated)
        
        let viewFrame = self.view.frame
        let barFrame = self.navigationController!.toolbar.frame
        
//        UIView.setAnimationsEnabled(false)
//        self.navigationController?.toolbar.frame = CGRectMake(0, CGRectGetHeight(viewFrame) - CGRectGetHeight(barFrame), CGRectGetWidth(viewFrame), CGRectGetHeight(barFrame))
        
        UIView.setAnimationsEnabled(animated)
        self.navigationController?.toolbar.frame = CGRectMake(0, CGRectGetHeight(viewFrame), CGRectGetWidth(viewFrame), CGRectGetHeight(barFrame))
        UIView.setAnimationsEnabled(true)
    }
    
    func showToolbar(animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: animated)
        
        let viewFrame = self.view.frame
        let barFrame = self.navigationController!.toolbar.frame
        
//        UIView.setAnimationsEnabled(false)
//        self.navigationController?.toolbar.frame = CGRectMake(0, CGRectGetHeight(viewFrame), CGRectGetWidth(viewFrame), CGRectGetHeight(barFrame))
        
        UIView.setAnimationsEnabled(animated)
        self.navigationController?.toolbar.frame = CGRectMake(0, CGRectGetHeight(viewFrame) - CGRectGetHeight(barFrame), CGRectGetWidth(viewFrame), CGRectGetHeight(barFrame))
        UIView.setAnimationsEnabled(true)
    }
    
    func bottomInset() -> Float {
        return 0
    }
    
    func topInset() -> Float {
        return 0
    }
}