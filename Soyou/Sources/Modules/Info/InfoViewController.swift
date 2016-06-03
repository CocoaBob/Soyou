//
//  InfoViewController.swift
//  Soyou
//
//  Created by CocoaBob on 31/05/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

import Foundation

class InfoViewController: UIViewController {
    
    // PageMenu
    var pageMenu: CAPSPageMenu?
    
    var newsViewController: NewsViewController = NewsViewController.instantiate()
    var discountsViewController: DiscountsViewController = DiscountsViewController.instantiate()
    
    // Zoom Transition
    var transition: ZoomInteractiveTransition?
    
    @IBOutlet var subViewsContainer: UIView!
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.edgesForExtendedLayout = UIRectEdge.All
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = false
        
        // UIViewController
        self.title = NSLocalizedString("info_vc_title")
        
        // UITabBarItem
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("info_vc_tab_title"), image: UIImage(named: "img_tab_news"), selectedImage: UIImage(named: "img_tab_news_selected"))
        
        // Bars
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SubViewControllers
        self.setupSubViewControllers()
        
        // Transitions
        self.transition = ZoomInteractiveTransition(navigationController: self.navigationController)
        self.transition?.handleEdgePanBackGesture = false
        self.transition?.transitionDuration = 0.3
        let animationOpts: UIViewAnimationOptions = .CurveEaseOut
        let keyFrameOpts: UIViewKeyframeAnimationOptions = UIViewKeyframeAnimationOptions(rawValue: animationOpts.rawValue)
        self.transition?.transitionAnimationOption = [UIViewKeyframeAnimationOptions.CalculationModeCubic, keyFrameOpts]
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        self.hideToolbar(false)
    }
}

// MARK: Sub View Controllers
extension InfoViewController {
    
    func setupSubViewControllers() {
        // Add page menu to the scroll view's subViewsContainer
        if self.pageMenu == nil {
            // Prepare childViewControllers
            var viewControllers = [UIViewController]()
            
            // News VC
            viewControllers.append(self.newsViewController)
            viewControllers.append(self.discountsViewController)
            
            // Setup view controllers
            let _ = viewControllers.map {
                ($0 as? InfoListBaseViewController)?.infoViewController = self
                let _ = $0.view
            }
            
            // Customize menu (Optional)
            let parameters: [String: AnyObject] = [
                CAPSPageMenuOptionMenuItemSeparatorWidth: NSNumber(double: 0),
                CAPSPageMenuOptionScrollMenuBackgroundColor: UIColor.whiteColor(),
                CAPSPageMenuOptionSelectionIndicatorColor: UIColor.darkGrayColor(),
                CAPSPageMenuOptionSelectedMenuItemLabelColor: UIColor.darkGrayColor(),
                CAPSPageMenuOptionUnselectedMenuItemLabelColor: UIColor.lightGrayColor(),
                CAPSPageMenuOptionUseMenuLikeSegmentedControl: NSNumber(bool: true),
                CAPSPageMenuOptionCenterMenuItems: NSNumber(bool: true),
                CAPSPageMenuOptionMenuItemFont: UIFont.boldSystemFontOfSize(15),
                CAPSPageMenuOptionMenuMargin: NSNumber(double: 10.0),
                CAPSPageMenuOptionMenuHeight: Cons.UI.heightPageMenuInfo,
                CAPSPageMenuOptionAddBottomMenuHairline: NSNumber(bool: true),
                CAPSPageMenuOptionBottomMenuHairlineColor: UIColor.whiteColor()
            ]
            
            // Create CAPSPageMenu
            let topInset = UIApplication.sharedApplication().statusBarFrame.height
            self.pageMenu = CAPSPageMenu(
                viewControllers: viewControllers,
                frame: CGRect(x: 0.0, y: topInset, width: self.view.frame.width, height: self.view.frame.height - topInset),
                options: parameters)
            
            // Add CAPSPageMenu
            if let pageMenu = self.pageMenu {
                pageMenu.view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
                self.subViewsContainer.addSubview(pageMenu.view)
                pageMenu.view.frame = CGRect(x: 0, y: topInset, width: self.subViewsContainer.frame.width, height: self.subViewsContainer.frame.height - topInset)
            }
        }
    }
}

// MARK: ZoomInteractiveTransition
extension InfoViewController: ZoomTransitionProtocol {
    
    func viewForZoomTransition(isSource: Bool) -> UIView? {
        guard let pageMenu = self.pageMenu else { return nil }
        guard let viewController = pageMenu.controllerArray[pageMenu.currentPageIndex] as? InfoListBaseViewController else { return nil }
        return viewController.viewForZoomTransition(isSource)
    }
    
    func initialZoomViewSnapshotFromProposedSnapshot(snapshot: UIImageView!) -> UIImageView? {
        guard let pageMenu = self.pageMenu else { return nil }
        guard let viewController = pageMenu.controllerArray[pageMenu.currentPageIndex] as? InfoListBaseViewController else { return nil }
        return viewController.initialZoomViewSnapshotFromProposedSnapshot(snapshot)
    }
    
    func shouldAllowZoomTransitionForOperation(operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController!, toViewController toVC: UIViewController!) -> Bool {
        guard let pageMenu = self.pageMenu else { return false }
        guard let viewController = pageMenu.controllerArray[pageMenu.currentPageIndex] as? InfoListBaseViewController else { return false }
        return viewController.shouldAllowZoomTransitionForOperation(operation, fromViewController: fromVC, toViewController: toVC)
    }
}
