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
    var pageMenuViewControllers: [UIViewController] = [UIViewController]()
    var pageMenuCurrentPageIndex = 0
    
    var newsViewController: NewsViewController = NewsViewController.instantiate()
    var discountsViewController: DiscountsViewController = DiscountsViewController.instantiate()
    
    // Zoom Transition
    var transition: ZoomInteractiveTransition?
    
    @IBOutlet var subViewsContainer: UIView!
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.edgesForExtendedLayout = UIRectEdge.all
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
        let animationOpts: UIViewAnimationOptions = .curveEaseOut
        let keyFrameOpts: UIViewKeyframeAnimationOptions = UIViewKeyframeAnimationOptions(rawValue: animationOpts.rawValue)
        self.transition?.transitionAnimationOption = [UIViewKeyframeAnimationOptions.calculationModeCubic, keyFrameOpts]
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
            // News VC
            self.pageMenuViewControllers.append(self.newsViewController)
            self.pageMenuViewControllers.append(self.discountsViewController)
            
            // Setup view controllers
            let _ = self.pageMenuViewControllers.map {
                ($0 as? InfoListBaseViewController)?.infoViewController = self
                let _ = $0.view
            }
            
            // Customize menu (Optional)
            let parameters: [CAPSPageMenuOption] = [
                .menuItemSeparatorWidth(0),
                .scrollMenuBackgroundColor(UIColor.white),
                .selectionIndicatorColor(UIColor.darkGray),
                .selectedMenuItemLabelColor(UIColor.darkGray),
                .unselectedMenuItemLabelColor(UIColor.lightGray),
                .useMenuLikeSegmentedControl(true),
                .centerMenuItems(true),
                .menuItemFont(UIFont.boldSystemFont(ofSize: 15)),
                .menuMargin(10.0),
                .menuHeight(Cons.UI.heightPageMenuInfo),
                .addBottomMenuHairline(true),
                .bottomMenuHairlineColor(UIColor.white)
            ]
            
            // Create CAPSPageMenu
            let topInset = Cons.UI.statusBarHeight
            self.pageMenu = CAPSPageMenu(
                viewControllers: self.pageMenuViewControllers,
                frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.height - topInset),
                pageMenuOptions: parameters)
            self.pageMenu?.delegate = self
            
            // Add CAPSPageMenu
            if let pageMenu = self.pageMenu {
                pageMenu.view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
                self.subViewsContainer.addSubview(pageMenu.view)
                pageMenu.view.frame = CGRect(x: 0,
                                             y: topInset,
                                             width: self.subViewsContainer.frame.width,
                                             height: self.subViewsContainer.frame.height - topInset)
            }
        }
    }
}

// MARK: CAPSPageMenuDelegate
extension InfoViewController: CAPSPageMenuDelegate {
    
    func didMoveToPage(_ controller: UIViewController, index: Int) {
        self.pageMenuCurrentPageIndex = index
    }
}

// MARK: ZoomInteractiveTransition
extension InfoViewController: ZoomTransitionProtocol {
    
    func view(forZoomTransition isSource: Bool) -> UIView? {
        guard let viewController = self.pageMenuViewControllers[self.pageMenuCurrentPageIndex] as? InfoListBaseViewController else { return nil }
        return viewController.view(forZoomTransition: isSource)
    }
    
    func initialZoomViewSnapshot(fromProposedSnapshot snapshot: UIImageView!) -> UIImageView? {
        guard let viewController = self.pageMenuViewControllers[self.pageMenuCurrentPageIndex] as? InfoListBaseViewController else { return nil }
        return viewController.initialZoomViewSnapshot(fromProposedSnapshot: snapshot)
    }
    
    func shouldAllowZoomTransition(for operation: UINavigationControllerOperation, from fromVC: UIViewController!, to toVC: UIViewController!) -> Bool {
        guard let viewController = self.pageMenuViewControllers[self.pageMenuCurrentPageIndex] as? InfoListBaseViewController else { return false }
        return viewController.shouldAllowZoomTransition(for: operation, from: fromVC, to: toVC)
    }
}
