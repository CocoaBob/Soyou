//
//  UIViewController+Additions.swift
//  iPrices
//
//  Created by CocoaBob on 09/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

extension UIViewController {
    
    func hideToolbar(animated: Bool) {
//        let viewFrame = self.view.frame
//        var barFrame = self.navigationController!.toolbar.frame
//        barFrame = CGRectMake(0, CGRectGetHeight(viewFrame), CGRectGetWidth(viewFrame), CGRectGetHeight(barFrame))
//        
//        if (animated) {
//            UIView.animateWithDuration(0.25,
//                animations: { () -> Void in
//                self.navigationController?.toolbar.frame = barFrame
//                },
//                completion: { (finished) -> Void in
//                    self.navigationController?.setToolbarHidden(true, animated: false)
//            })
//        } else {
//            UIView.setAnimationsEnabled(false)
//            self.navigationController?.toolbar.frame = barFrame
//            UIView.setAnimationsEnabled(true)
            self.navigationController?.setToolbarHidden(true, animated: false)
//        }
    }
    
    func showToolbar() {
//        UIView.setAnimationsEnabled(false)
//        
        self.navigationController?.setToolbarHidden(false, animated: false)
//
//        let viewFrame = self.view.frame
//        var barFrame = self.navigationController!.toolbar.frame
//        barFrame = CGRectMake(0, CGRectGetHeight(viewFrame) - CGRectGetHeight(barFrame), CGRectGetWidth(viewFrame), CGRectGetHeight(barFrame))
//        self.navigationController?.toolbar.frame = barFrame
        
//        UIView.setAnimationsEnabled(true)
    }
    
    func topInset() -> CGFloat {
        var topInset: CGFloat = 0
        if !UIApplication.sharedApplication().statusBarHidden {
            topInset += UIApplication.sharedApplication().statusBarFrame.size.height
        }
        if let navigationController = self.navigationController {
            if !navigationController.navigationBarHidden {
                topInset += navigationController.navigationBar.frame.size.height
            }
        }
        return topInset
    }
    
    func bottomInset(toolbarIsVisible: Bool) -> CGFloat {
        var bottomInset: CGFloat = 0
        if let navigationController = self.navigationController {
            if toolbarIsVisible {
                bottomInset += navigationController.toolbar.frame.size.height
            }
        }
        if let tabBarController = self.tabBarController {
            if !self.hidesBottomBarWhenPushed {
                let tabBarFrame = tabBarController.tabBar.frame
                let viewFrame = self.view.frame
                bottomInset += (viewFrame.size.height - tabBarFrame.origin.y)
            }
        }
        return bottomInset
    }
    
    func updateScrollViewInset(scrollView: UIScrollView, toolbarIsVisible: Bool) {
        self.edgesForExtendedLayout = UIRectEdge.All
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = false
        scrollView.contentInset = UIEdgeInsetsMake(self.topInset(), 0, self.bottomInset(toolbarIsVisible), 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        scrollView.contentOffset = CGPointMake(-scrollView.contentInset.left, -scrollView.contentInset.top)
    }
}