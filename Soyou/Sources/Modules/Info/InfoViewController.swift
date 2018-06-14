//
//  InfoViewController.swift
//  Soyou
//
//  Created by CocoaBob on 31/05/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

import Foundation

class InfoViewController: UIViewController {
    
    var newsViewController: NewsViewController = NewsViewController.instantiate()
    
    // Zoom Transition
    var transition: ZoomInteractiveTransition?
    
    @IBOutlet var subViewsContainer: UIView!
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.title = NSLocalizedString("info_vc_title")
        
        self.edgesForExtendedLayout = UIRectEdge.all
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = false
        
        // UITabBarItem
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("info_vc_tab_title"),
                                       image: UIImage(named: "img_tab_news"),
                                       selectedImage: UIImage(named: "img_tab_news_selected"))
        
        // Bars
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIViewController
        self.title = NSLocalizedString("info_vc_title")
        
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
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        self.hideToolbar(false)
        self.newsViewController.viewWillAppear(animated)
    }
}

// MARK: Sub View Controllers
extension InfoViewController {
    
    func setupSubViewControllers() {
        self.newsViewController.infoViewController = self
        
        self.newsViewController.view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        self.subViewsContainer.addSubview(self.newsViewController.view)
        
        let topInset = Cons.UI.statusBarHeight
        self.newsViewController.view.frame = CGRect(x: 0,
                                                    y: topInset,
                                                    width: self.subViewsContainer.frame.width,
                                                    height: self.subViewsContainer.frame.height - topInset)
    }
}

// MARK: ZoomInteractiveTransition
extension InfoViewController: ZoomTransitionProtocol {
    
    func view(forZoomTransition isSource: Bool) -> UIView? {
        return self.newsViewController.view(forZoomTransition: isSource)
    }
    
    func initialZoomViewSnapshot(fromProposedSnapshot snapshot: UIImageView!) -> UIImageView? {
        return self.newsViewController.initialZoomViewSnapshot(fromProposedSnapshot: snapshot)
    }
    
    func shouldAllowZoomTransition(for operation: UINavigationControllerOperation, from fromVC: UIViewController!, to toVC: UIViewController!) -> Bool {
        return self.newsViewController.shouldAllowZoomTransition(for: operation, from: fromVC, to: toVC)
    }
}
