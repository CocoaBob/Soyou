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
    var pageMenuHeight: CGFloat = 30
    
    var newsViewController: NewsViewController = NewsViewController.instantiate()
    
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
            self.newsViewController.title = NSLocalizedString("news_vc_title")
            self.newsViewController.view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
            viewControllers.append(self.newsViewController)
            
            // Customize menu (Optional)
            let parameters: [String: AnyObject] = [
                CAPSPageMenuOptionMenuItemSeparatorWidth: NSNumber(double: 0),
                CAPSPageMenuOptionScrollMenuBackgroundColor: UIColor.whiteColor(),
                CAPSPageMenuOptionSelectionIndicatorColor: UIColor.darkGrayColor(),
                CAPSPageMenuOptionSelectedMenuItemLabelColor: UIColor.darkGrayColor(),
                CAPSPageMenuOptionUnselectedMenuItemLabelColor: UIColor.lightGrayColor(),
                CAPSPageMenuOptionUseMenuLikeSegmentedControl: NSNumber(bool: true),
                CAPSPageMenuOptionCenterMenuItems: NSNumber(bool: true),
                CAPSPageMenuOptionMenuItemFont: UIFont.systemFontOfSize(13),
                CAPSPageMenuOptionMenuMargin: NSNumber(double: 10.0),
                CAPSPageMenuOptionMenuHeight: self.pageMenuHeight,
                CAPSPageMenuOptionAddBottomMenuHairline: NSNumber(bool: true),
                CAPSPageMenuOptionBottomMenuHairlineColor: UIColor.whiteColor()
            ]
            
            // Create CAPSPageMenu
            self.pageMenu = CAPSPageMenu(
                viewControllers: viewControllers,
                frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height),
                options: parameters)
            
            // Add CAPSPageMenu
            if let pageMenu = self.pageMenu {
                pageMenu.view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
                self.subViewsContainer.addSubview(pageMenu.view)
                pageMenu.view.frame = CGRect(x: 0, y: 0, width: self.subViewsContainer.frame.width, height: self.subViewsContainer.frame.height)
            }
        }
    }
}
