//
//  UIViewController+Additions.swift
//  iPrices
//
//  Created by CocoaBob on 09/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

// MARK: Top/Bottom bars and scroll view insets
extension UIViewController {
    
    func hideToolbar(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    func showToolbar() {
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    func topInset(includeStatusBar: Bool) -> CGFloat {
        var topInset: CGFloat = 0
        if includeStatusBar && !UIApplication.sharedApplication().statusBarHidden {
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
        if toolbarIsVisible {
            if let navigationController = self.navigationController {
                bottomInset += navigationController.toolbar.frame.size.height
            }
        }
        if let tabBarController = self.tabBarController {
            if !self.hidesBottomBarWhenPushed {
                let tabBarFrame = tabBarController.tabBar.frame
                let viewFrame = self.view.frame
                bottomInset += max(0, (viewFrame.size.height - tabBarFrame.origin.y))
            }
        }
        return bottomInset
    }
    
    func updateScrollViewInset(scrollView: UIScrollView, _ coverStatusBar: Bool, _ toolbarIsVisible: Bool) {
        self.edgesForExtendedLayout = UIRectEdge.All
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = false
        let topInset = self.topInset(!coverStatusBar)
        let bottomInset = self.bottomInset(toolbarIsVisible)
        scrollView.contentInset = UIEdgeInsetsMake(topInset, 0, bottomInset, 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        scrollView.contentOffset = CGPointMake(-scrollView.contentInset.left, -scrollView.contentInset.top)
    }
}

private var __rotationAnimationDuration: NSTimeInterval = 0
private var __rotationAnimationOptions: UIViewAnimationOptions = .TransitionNone
private var __isRotationAnimation: Bool = false
private var __isDismissingKeyboard: Bool = false

// MARK: Keyboard Control
extension UIViewController {
    
    // Should be called in viewWillAppear:
    func keyboardControlInstall() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillChangeFrame:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidChangeFrame:", name: UIKeyboardDidChangeFrameNotification, object: nil)
    }
    
    // Should be called in viewDidDisappear:
    func keyboardControlUninstall() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidChangeFrameNotification, object: nil)
    }
    
    // Called on step: #1
    // Called on iOS >= 8 from
    // viewWillTransitionToSize:withTransitionCoordinator:
    func keyboardControlRotateWithTransitionCoordinator(coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition(
            { (context: UIViewControllerTransitionCoordinatorContext) -> Void in
                // called on step: #2
                __rotationAnimationDuration = context.transitionDuration()
                var option = context.completionCurve()
                option = UIViewAnimationCurve(rawValue: option.rawValue | (option.rawValue << 16))!
                __rotationAnimationOptions = UIViewAnimationOptions(rawValue: UInt(option.rawValue))
                __isRotationAnimation = true
            }, completion:
            { (context: UIViewControllerTransitionCoordinatorContext) -> Void in
                __isRotationAnimation = false
            }
        )
    }
    
    // MARK: Overridden by subclasses
    
    // Called on iOS-7 and below on steps: #2, #4
    // Called on iOS-8 on steps: #3, #4, #6, #7
    func keyboardWillChangeFrame(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard var finalKeyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue else { return }
        
        // Convert the finalKeyboardFrame to view coordinates to take into account any rotation
        // factors applied to the window’s contents as a result of interface orientation changes.
        finalKeyboardFrame = self.view.convertRect(finalKeyboardFrame, fromView: self.view.window)
        
        if (!__isRotationAnimation) {
            // Get the animation curve and duration frp, keyboard notification info
            guard let animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] else { return }
            guard var option = UIViewAnimationCurve(rawValue: animationCurve.integerValue) else { return }
            option = UIViewAnimationCurve(rawValue: option.rawValue | (option.rawValue << 16))!
            guard let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] else { return }
            let rotationAnimationDuration: NSTimeInterval = animationDuration.doubleValue
            // On iOS8 if the rotationAnimationDuration is 0,
            // then the quicktype panel is being shown/hidden and the code executed here will be animated automatically
            if (rotationAnimationDuration == 0) {
                self.adjustViewsForKeyboardFrame(finalKeyboardFrame, false, 0, UIViewAnimationOptions(rawValue: 0))
            } else {
                self.adjustViewsForKeyboardFrame(finalKeyboardFrame, true, rotationAnimationDuration, UIViewAnimationOptions(rawValue: UInt(option.rawValue)))
            }
        } else {
            if UIView.areAnimationsEnabled() {
                self.adjustViewsForKeyboardFrame(finalKeyboardFrame, false, 0, UIViewAnimationOptions(rawValue: 0))
            } else {
                UIView.setAnimationsEnabled(true)
                self.adjustViewsForKeyboardFrame(finalKeyboardFrame, true, __rotationAnimationDuration, __rotationAnimationOptions)
                UIView.setAnimationsEnabled(false)
            }
        }
    }
    
    func keyboardDidChangeFrame(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard var finalKeyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue else { return }
        
        // Convert the finalKeyboardFrame to view coordinates to take into account any rotation
        // factors applied to the window’s contents as a result of interface orientation changes.
        finalKeyboardFrame = self.view.convertRect(finalKeyboardFrame, fromView: self.view.window)
        
        self.adjustViewsForKeyboardFrame(finalKeyboardFrame, false, 0, UIViewAnimationOptions(rawValue: 0))
    }
    
    func adjustViewsForKeyboardFrame(keyboardFrame: CGRect, _ isAnimated: Bool, _ duration: NSTimeInterval, _ options: UIViewAnimationOptions) {
        let updateFrameClosure: () -> () = { () -> () in
            var frame = self.view.frame
            frame.size.height = keyboardFrame.origin.y
            
            // If it's UIModalPresentationFormSheet, keyboardFrame.origin.y is far below the view
            if let superView = self.view.superview {
                if frame.size.height > superView.frame.size.height {
                    frame.size.height = superView.frame.size.height
                }
            }
            self.view.frame = frame
        }
        
        if isAnimated {
            UIView.animateWithDuration(duration, delay: 0, options: options, animations: updateFrameClosure, completion: nil)
        } else {
            updateFrameClosure()
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return !__isDismissingKeyboard
    }
    
    func dismissKeyboard() {
        __isDismissingKeyboard = true
        self.view.endEditing(true)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.25 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            __isDismissingKeyboard = false
        }
    }
}

// MARK: Child View Controller
extension UIViewController {

    func showChildViewController(newChildViewController: UIViewController) {
        let childViewControllers = self.childViewControllers
        
        self.addChildViewController(newChildViewController)
        newChildViewController.view.frame = self.view.bounds
        newChildViewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.view.addSubview(newChildViewController.view)
        newChildViewController.didMoveToParentViewController(self)
        
        for childViewController in childViewControllers {
            childViewController.willMoveToParentViewController(nil)
            childViewController.view.removeFromSuperview()
            childViewController.removeFromParentViewController()
        }
    }
}

// MARK: Routines
extension UIViewController {

    func dismissSelf() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}