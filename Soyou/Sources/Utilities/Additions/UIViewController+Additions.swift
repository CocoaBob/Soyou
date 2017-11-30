//
//  UIViewController+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 09/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

// MARK: Top/Bottom bars and scroll view insets
extension UIViewController {
    
    func hideToolbar(_ animated: Bool) {
        if let navController = self.navigationController {
            if !navController.isToolbarHidden {
                navController.setToolbarHidden(true, animated: animated)
            }
        }
    }
    
    func showToolbar(_ animated: Bool) {
        if let navController = self.navigationController {
            if navController.isToolbarHidden {
                navController.setToolbarHidden(false, animated: animated)
            }
        }
    }
    
    func topInset(_ parallaxHeaderHeight: CGFloat, _ statusBarIsVisible: Bool, _ navBarIsVisible: Bool) -> CGFloat {
        var topInset: CGFloat = parallaxHeaderHeight
        if statusBarIsVisible {
            topInset += Cons.UI.statusBarHeight
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
    
    func bottomInset(_ toolbarIsVisible: Bool, _ tabBarIsVisible: Bool) -> CGFloat {
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
    
    func updateScrollViewInset(_ scrollView: UIScrollView, _ parallaxHeaderHeight: CGFloat, _ statusBarIsVisible: Bool, _ navBarIsVisible: Bool, _ toolbarIsVisible: Bool, _ tabBarIsVisible: Bool) {
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }
        self.edgesForExtendedLayout = UIRectEdge.all
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

private var __rotationAnimationDuration: TimeInterval = 0
private var __rotationAnimationOptions: UIViewAnimationOptions = []
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
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillChangeFrame(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardDidChangeFrame(_:)), name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Should be called in viewDidDisappear:
    func keyboardControlUninstall() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidChangeFrame, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Called on step: #1
    // Called on iOS >= 8 from
    // viewWillTransitionToSize:withTransitionCoordinator:
    func keyboardControlRotateWithTransitionCoordinator(_ coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context: UIViewControllerTransitionCoordinatorContext) -> Void in
            // called on step: #2
            __rotationAnimationDuration = context.transitionDuration
            var option = context.completionCurve
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
    @objc func keyboardWillChangeFrame(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard var finalKeyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        // Convert the finalKeyboardFrame to view coordinates to take into account any rotation
        // factors applied to the window’s contents as a result of interface orientation changes.
        finalKeyboardFrame = self.view.convert(finalKeyboardFrame, from: self.view.window)
        
        if (!__isRotationAnimation) {
            // Get the animation curve and duration frp, keyboard notification info
            guard let animationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else { return }
            guard var option = UIViewAnimationCurve(rawValue: animationCurve.intValue) else { return }
            option = UIViewAnimationCurve(rawValue: option.rawValue | (option.rawValue << 16))!
            guard let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else { return }
            let rotationAnimationDuration: TimeInterval = animationDuration.doubleValue
            // On iOS8 if the rotationAnimationDuration is 0,
            // then the quicktype panel is being shown/hidden and the code executed here will be animated automatically
            if (rotationAnimationDuration == 0) {
                self.adjustViewsForKeyboardFrame(finalKeyboardFrame, false, 0, UIViewAnimationOptions(rawValue: 0))
            } else {
                self.adjustViewsForKeyboardFrame(finalKeyboardFrame, true, rotationAnimationDuration, UIViewAnimationOptions(rawValue: UInt(option.rawValue)))
            }
        } else {
            if UIView.areAnimationsEnabled {
                self.adjustViewsForKeyboardFrame(finalKeyboardFrame, false, 0, UIViewAnimationOptions(rawValue: 0))
            } else {
                UIView.setAnimationsEnabled(true)
                self.adjustViewsForKeyboardFrame(finalKeyboardFrame, true, __rotationAnimationDuration, __rotationAnimationOptions)
                UIView.setAnimationsEnabled(false)
            }
        }
    }
    
    @objc func keyboardDidChangeFrame(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard var finalKeyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        // Convert the finalKeyboardFrame to view coordinates to take into account any rotation
        // factors applied to the window’s contents as a result of interface orientation changes.
        finalKeyboardFrame = self.view.convert(finalKeyboardFrame, from: self.view.window)
        
        self.adjustViewsForKeyboardFrame(finalKeyboardFrame, false, 0, UIViewAnimationOptions(rawValue: 0))
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        var navigationItem: UINavigationItem?
        if self.parent != nil && self.parent != self.navigationController {
            navigationItem = self.parent?.navigationItem
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
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "img_keyboard_close"), style: .plain, target: self, action: #selector(UIViewController.dismissKeyboard))
            navigationItem.rightBarButtonItem?.tag = __dismissKeyboardBarButtonItemTag
            UIView.setAnimationsEnabled(true)
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        var navigationItem: UINavigationItem?
        if self.parent != nil && self.parent != self.navigationController {
            navigationItem = self.parent?.navigationItem
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
    
    @objc func adjustViewsForKeyboardFrame(_ keyboardFrame: CGRect, _ isAnimated: Bool, _ duration: TimeInterval, _ options: UIViewAnimationOptions) {
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
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: updateFrameClosure, completion: nil)
        } else {
            updateFrameClosure()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return !__isDismissingKeyboard
    }
    
    @objc func dismissKeyboard() {
        __isDismissingKeyboard = true
        self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
            __isDismissingKeyboard = false
        }
    }
}

// MARK: Child View Controller
extension UIViewController {

    func showChildViewController(_ newChildViewController: UIViewController, _ animated: Bool, _ isInverted: Bool, _ completion: () -> Void) {
        let completionClosure: ((UIViewController) -> ()) = { newChildViewController in
            for childViewController in self.childViewControllers {
                if childViewController == newChildViewController {
                    continue
                }
                childViewController.willMove(toParentViewController: nil)
                childViewController.view.removeFromSuperview()
                childViewController.removeFromParentViewController()
            }
        }
        
        newChildViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if let oldChildViewController = self.childViewControllers.last {
            // Prepare ChildViewController hierarchy
            oldChildViewController.willMove(toParentViewController: nil)
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
            self.transition(from: oldChildViewController,
                            to: newChildViewController,
                duration: 0.25,
                options: .curveEaseInOut,
                animations: { () -> Void in
                    oldChildViewController.view.frame = oldViewFrameEnd
                    newChildViewController.view.frame = newViewFrameEnd
                },
                completion: { (finished) -> Void in
                    oldChildViewController.removeFromParentViewController()
                    newChildViewController.didMove(toParentViewController: self)
                    
                    completionClosure(newChildViewController)
            })
        } else {
            self.addChildViewController(newChildViewController)
            newChildViewController.view.frame = self.view.bounds
            self.view.addSubview(newChildViewController.view)
            newChildViewController.didMove(toParentViewController: self)
            completionClosure(newChildViewController)
        }
    }
}

// MARK: Routines
extension UIViewController {

    @IBAction func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: ZoomInteractiveTransition
extension UIViewController {
    
    func animationBlockForZoomTransition() -> ZoomAnimationBlock! {
        return { (animatedSnapshot: UIImageView!, sourceView: UIView!, destinationView: UIView!) -> Void in
            animatedSnapshot.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }
    }
    
    func completionBlockForZoomTransition() -> ZoomCompletionBlock! {
        return { (animatedSnapshot: UIImageView!, sourceView: UIView!, destinationView: UIView!, completion: (() -> Void)?) -> Void in
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                animatedSnapshot.transform = CGAffineTransform.identity
            }, completion: { (Bool) -> Void in
                completion?()
            })
        }
    }
}

// MARK: Find top view controller
extension UIViewController {
    
    func toppestViewController(_ base: UIViewController?) -> UIViewController? {
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
