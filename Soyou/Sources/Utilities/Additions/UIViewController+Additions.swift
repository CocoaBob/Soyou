//
//  UIViewController+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 09/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

// MARK: Top/Bottom bars and scroll view insets
extension UIViewController {
    
    func hideToolbar(animated: Bool) {
        if let navController = self.navigationController {
            if !navController.toolbarHidden {
                navController.setToolbarHidden(true, animated: animated)
            }
        }
    }
    
    func showToolbar(animated: Bool) {
        if let navController = self.navigationController {
            if navController.toolbarHidden {
                navController.setToolbarHidden(false, animated: animated)
            }
        }
    }
    
    func topInset(parallaxHeaderHeight: CGFloat, _ statusBarIsVisible: Bool, _ navBarIsVisible: Bool) -> CGFloat {
        var topInset: CGFloat = parallaxHeaderHeight
        if statusBarIsVisible {
            topInset += 20
//            if !UIApplication.sharedApplication().statusBarHidden {
//                let statusBarFrame = UIApplication.sharedApplication().keyWindow?.convertRect(UIApplication.sharedApplication().statusBarFrame, fromView: self.view)
//                if let statusBarHeight = statusBarFrame?.height {
//                    topInset += statusBarHeight
//                }
//            }
        }
        if navBarIsVisible {
            var navigationController: UINavigationController?
            if let _navigationController = self.navigationController {
                navigationController = _navigationController
            }
            if let _navigationController = self.presentingViewController?.navigationController {
                navigationController = _navigationController
            }
            if let navigationController = navigationController {
                topInset += navigationController.navigationBar.frame.height
            } else {
                topInset += 44
            }
        }
        return topInset
    }
    
    func bottomInset(toolbarIsVisible: Bool, _ tabBarIsVisible: Bool) -> CGFloat {
        var bottomInset: CGFloat = 0
        if toolbarIsVisible {
            var navigationController: UINavigationController?
            if let _navigationController = self.navigationController {
                navigationController = _navigationController
            }
            if let _navigationController = self.presentingViewController?.navigationController {
                navigationController = _navigationController
            }
            if let navigationController = navigationController {
                bottomInset += navigationController.toolbar.frame.height
            } else {
                bottomInset += 44
            }
        }
        if tabBarIsVisible {
            var tabBarController: UITabBarController?
            if let _tabBarController = self.tabBarController {
                tabBarController = _tabBarController
            }
            if let _tabBarController = self.presentingViewController?.tabBarController {
                tabBarController = _tabBarController
            }            
            if let tabBarController = tabBarController {
                let tabBarFrame = tabBarController.tabBar.frame
                let viewFrame = self.view.frame
                bottomInset += max(0, (viewFrame.height - tabBarFrame.origin.y))
            } else {
                bottomInset += 49
            }
        }
        return bottomInset
    }
    
    func updateScrollViewInset(scrollView: UIScrollView, _ parallaxHeaderHeight: CGFloat, _ statusBarIsVisible: Bool, _ navBarIsVisible: Bool, _ toolbarIsVisible: Bool, _ tabBarIsVisible: Bool) {
        self.edgesForExtendedLayout = UIRectEdge.All
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = false
        let topInset = self.topInset(parallaxHeaderHeight, statusBarIsVisible, navBarIsVisible)
        let bottomInset = self.bottomInset(toolbarIsVisible, tabBarIsVisible)
        scrollView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: bottomInset, right: 0)
        scrollView.scrollIndicatorInsets = scrollView.contentInset
        scrollView.contentOffset = CGPoint(x: -scrollView.contentInset.left, y: -scrollView.contentInset.top)
    }
}

import ObjectiveC

private var __rotationAnimationDuration: NSTimeInterval = 0
private var __rotationAnimationOptions: UIViewAnimationOptions = .TransitionNone
private var __isRotationAnimation: Bool = false
private var __isDismissingKeyboard: Bool = false
private var __isKeyboardVisible: Bool = false
private var __originalRightBarButtonItemKey: UInt8 = 0
private var __originalRightBarButtonItemsKey: UInt8 = 0
private var __dismissKeyboardBarButtonItemTag: Int = 1001

// MARK: Keyboard Control
extension UIViewController {
    
    // Should be called in viewWillAppear:
    func keyboardControlInstall() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIViewController.keyboardWillChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIViewController.keyboardDidChangeFrame(_:)), name: UIKeyboardDidChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UIViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Should be called in viewDidDisappear:
    func keyboardControlUninstall() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardDidChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Called on step: #1
    // Called on iOS >= 8 from
    // viewWillTransitionToSize:withTransitionCoordinator:
    func keyboardControlRotateWithTransitionCoordinator(coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context: UIViewControllerTransitionCoordinatorContext) -> Void in
            // called on step: #2
            __rotationAnimationDuration = context.transitionDuration()
            var option = context.completionCurve()
            option = UIViewAnimationCurve(rawValue: option.rawValue | (option.rawValue << 16))!
            __rotationAnimationOptions = UIViewAnimationOptions(rawValue: UInt(option.rawValue))
            __isRotationAnimation = true
            }, completion: { (context: UIViewControllerTransitionCoordinatorContext) -> Void in
                __isRotationAnimation = false
        })
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
    
    func keyboardWillShow(notification: NSNotification) {
        var navigationItem: UINavigationItem?
        if self.parentViewController != nil && self.parentViewController != self.navigationController {
            navigationItem = self.parentViewController?.navigationItem
        } else {
            navigationItem = self.navigationItem
        }
        
        if __isKeyboardVisible || navigationItem?.rightBarButtonItem?.tag == __dismissKeyboardBarButtonItemTag {
            return
        }
        
        __isKeyboardVisible = true
        
        if let navigationItem = navigationItem {
            objc_setAssociatedObject(self, &__originalRightBarButtonItemKey, navigationItem.rightBarButtonItem, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            objc_setAssociatedObject(self, &__originalRightBarButtonItemsKey, navigationItem.rightBarButtonItems, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            UIView.setAnimationsEnabled(false)
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "img_keyboard_close"), style: .Plain, target: self, action: #selector(UIViewController.dismissKeyboard))
            navigationItem.rightBarButtonItem?.tag = __dismissKeyboardBarButtonItemTag
            UIView.setAnimationsEnabled(true)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        var navigationItem: UINavigationItem?
        if self.parentViewController != nil && self.parentViewController != self.navigationController {
            navigationItem = self.parentViewController?.navigationItem
        } else {
            navigationItem = self.navigationItem
        }
        
        if !__isKeyboardVisible && navigationItem?.rightBarButtonItem?.tag != __dismissKeyboardBarButtonItemTag {
            return
        }
        
        __isKeyboardVisible = false
        
        if let navigationItem = navigationItem {
            UIView.setAnimationsEnabled(false)
            navigationItem.rightBarButtonItem = objc_getAssociatedObject(self, &__originalRightBarButtonItemKey) as? UIBarButtonItem
            navigationItem.rightBarButtonItems = objc_getAssociatedObject(self, &__originalRightBarButtonItemsKey) as? [UIBarButtonItem]
            UIView.setAnimationsEnabled(true)
        }
    }
    
    func adjustViewsForKeyboardFrame(keyboardFrame: CGRect, _ isAnimated: Bool, _ duration: NSTimeInterval, _ options: UIViewAnimationOptions) {
        let updateFrameClosure: () -> () = { () -> () in
            var frame = self.view.frame
            frame.size.height = keyboardFrame.origin.y
            
            // If it's UIModalPresentationFormSheet, keyboardFrame.origin.y is far below the view
            if let superView = self.view.superview {
                if frame.height > superView.frame.height {
                    frame.size.height = superView.frame.height
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

    func showChildViewController(newChildViewController: UIViewController, _ animated: Bool, _ isInverted: Bool, _ completion: () -> Void) {
        let completionClosure: ((UIViewController) -> ()) = { newChildViewController in
            for childViewController in self.childViewControllers {
                if childViewController == newChildViewController {
                    continue
                }
                childViewController.willMoveToParentViewController(nil)
                childViewController.view.removeFromSuperview()
                childViewController.removeFromParentViewController()
            }
        }
        
        newChildViewController.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        if let oldChildViewController = self.childViewControllers.last {
            // Prepare ChildViewController hierarchy
            oldChildViewController.willMoveToParentViewController(nil)
            self.addChildViewController(newChildViewController)
            
            // Prepare frames
            let oldViewFrameStart = oldChildViewController.view.frame
            var oldViewFrameEnd = oldViewFrameStart
            oldViewFrameEnd.origin.x = isInverted ? -oldViewFrameEnd.size.width : oldViewFrameEnd.size.width
            
            var newViewFrameStart = oldViewFrameStart
            newViewFrameStart.origin.x = isInverted ? newViewFrameStart.size.width : -newViewFrameStart.size.width
            let newViewFrameEnd = oldViewFrameStart
            
            // Before Animation
            UIView.setAnimationsEnabled(false)
            oldChildViewController.view.frame = oldViewFrameStart
            newChildViewController.view.frame = newViewFrameStart
            newChildViewController.view.layoutIfNeeded()
            UIView.setAnimationsEnabled(true)
            
            // Animation
            self.transitionFromViewController(oldChildViewController,
                toViewController: newChildViewController,
                duration: 0.25,
                options: .CurveEaseInOut,
                animations: { () -> Void in
                    oldChildViewController.view.frame = oldViewFrameEnd
                    newChildViewController.view.frame = newViewFrameEnd
                },
                completion: { (finished) -> Void in
                    oldChildViewController.removeFromParentViewController()
                    newChildViewController.didMoveToParentViewController(self)
                    
                    completionClosure(newChildViewController)
            })
        } else {
            self.addChildViewController(newChildViewController)
            newChildViewController.view.frame = self.view.bounds
            self.view.addSubview(newChildViewController.view)
            newChildViewController.didMoveToParentViewController(self)
            completionClosure(newChildViewController)
        }
    }
}

// MARK: Routines
extension UIViewController {

    func dismissSelf() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: ZoomInteractiveTransition
extension UIViewController {
    
    func animationBlockForZoomTransition() -> ZoomAnimationBlock! {
        return { (animatedSnapshot: UIImageView!, sourceView: UIView!, destinationView: UIView!) -> Void in
            animatedSnapshot.transform = CGAffineTransformMakeScale(1.05, 1.05)
        }
    }
    
    func completionBlockForZoomTransition() -> ZoomCompletionBlock! {
        return { (animatedSnapshot: UIImageView!, sourceView: UIView!, destinationView: UIView!, completion: (() -> Void)?) -> Void in
            UIView.animateWithDuration(0.1, animations: { () -> Void in
                animatedSnapshot.transform = CGAffineTransformIdentity
                }, completion: { (Bool) -> Void in
                    if let completion = completion {
                        completion()
                    }
            })
        }
    }
}

// MARK: Find top view controller
extension UIViewController {
    
    func toppestViewController(base: UIViewController?) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return toppestViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return toppestViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return toppestViewController(presented)
        }
        if let searchController = base as? UISearchController {
            return toppestViewController(searchController.searchResultsController)
        }
        return base
    }
    
    func toppestViewController() -> UIViewController? {
        return self.toppestViewController(self)
    }
}
