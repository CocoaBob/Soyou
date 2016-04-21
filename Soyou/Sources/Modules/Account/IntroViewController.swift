//
//  IntroViewController.swift
//  Soyou
//
//  Created by CocoaBob on 11/02/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

enum IntroViewPage: Int {
    case Welcome
    case News
    case Search
    case Prices
    case Map
    case Count
}

class IntroViewController: NSObject {
    
    static let shared = IntroViewController()
    
    private var locationManager: CLLocationManager?
    var introView: EAIntroView?
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(IntroViewController.didRegisterForRemoteNotifications), name: Cons.Usr.DidRegisterForRemoteNotifications, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func showIntroView() {
        guard let keyWindow = UIApplication.sharedApplication().keyWindow else { return }
        
        var introPages = [EAIntroPage]()
        
        for i in 0..<IntroViewPage.Count.rawValue {
            let page: IntroViewPage = IntroViewPage(rawValue: i) ?? .Count
            switch page {
            case .Welcome:
                introPages.append(introPageForWelcome(keyWindow.bounds.size))
            case .Search:
                introPages.append(introPageForSearch(keyWindow.bounds.size))
            case .Prices:
                introPages.append(introPageForPrices(keyWindow.bounds.size))
            case .Map:
                introPages.append(introPageForMap(keyWindow.bounds.size))
            case .News:
                introPages.append(introPageForNews(keyWindow.bounds.size))
            default:
                break
            }
        }
        
        self.introView = EAIntroView(frame: keyWindow.bounds, andPages: introPages)
        self.introView?.delegate = self
        self.introView?.bgImage = UIImage(named: "img_bg_user")
        self.introView?.pageControlY = 24
        self.introView?.skipButtonY = 8
        self.introView?.skipButton.setTitle(NSLocalizedString("intro_vc_skip_button_done"), forState: .Normal)
        self.introView?.showSkipButtonOnlyOnLastPage = true
//        self.introView?.swipeToExit = false
        
        self.introView?.showInView(keyWindow, animateDuration: 0.3)
        
        // Update WTStatusBar colors
        Utils.updateWTStatusBarColors(UIColor.whiteColor(), UIColor(hex: "#5A76B3"), UIColor(hex: Cons.UI.colorTheme), true)
    }
}

// MARAK: Pages
extension IntroViewController {
    
    func newIntroPage(titleID: String, _ descID: String, _ imageID: String, _ viewSize: CGSize) -> EAIntroPage {
        let introPage = EAIntroPage()
        introPage.title = NSLocalizedString(titleID)
        introPage.desc = NSLocalizedString(descID)
        introPage.titleIconView = UIImageView(image: UIImage(named: NSLocalizedString(imageID)))
        introPage.titleIconView.contentMode = .ScaleAspectFit
        introPage.titleIconView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height - 220) // -160-8-44-8
        return introPage
    }
    
    func introPageForWelcome(viewSize: CGSize) -> EAIntroPage {
        let introPage = self.newIntroPage("intro_vc_title_welcome", "intro_vc_desc_welcome", "intro_vc_image_welcome", viewSize)
        return introPage
    }
    
    func introPageForSearch(viewSize: CGSize) -> EAIntroPage {
        let introPage = self.newIntroPage("intro_vc_title_search", "intro_vc_desc_search", "intro_vc_image_search", viewSize)
        return introPage
    }
    
    func introPageForPrices(viewSize: CGSize) -> EAIntroPage {
        let introPage = self.newIntroPage("intro_vc_title_prices", "intro_vc_desc_prices", "intro_vc_image_prices", viewSize)
        return introPage
    }
    
    func introPageForMap(viewSize: CGSize) -> EAIntroPage {
        let introPage = self.newIntroPage("intro_vc_title_map", "intro_vc_desc_map", "intro_vc_image_map", viewSize)
        
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            let actionButton = UIButton(frame: CGRect(x: (viewSize.width - 240)/2.0, y: viewSize.height - 50 - 44, width: 240, height: 44))
            actionButton.borderColor = UIColor.whiteColor()
            actionButton.borderWidth = 1
            actionButton.cornerRadius = 5
            actionButton.setTitle(NSLocalizedString("intro_vc_enable_location"), forState: .Normal)
            actionButton.addTarget(self, action: #selector(IntroViewController.enableLocation(_:)), forControlEvents: .TouchUpInside)
            introPage.subviews = [actionButton]
        }
        
        return introPage
    }
    
    func introPageForNews(viewSize: CGSize) -> EAIntroPage {
        let introPage = self.newIntroPage("intro_vc_title_news", "intro_vc_desc_news", "intro_vc_image_news", viewSize)
        
        if !UIApplication.sharedApplication().isRegisteredForRemoteNotifications() {
            let actionButton = UIButton(frame: CGRect(x: (viewSize.width - 240)/2.0, y: viewSize.height - 50 - 44, width: 240, height: 44))
            actionButton.borderColor = UIColor.whiteColor()
            actionButton.borderWidth = 1
            actionButton.cornerRadius = 5
            actionButton.setTitle(NSLocalizedString("intro_vc_enable_notification"), forState: .Normal)
            actionButton.addTarget(self, action: #selector(IntroViewController.enableNotification(_:)), forControlEvents: .TouchUpInside)
            introPage.subviews = [actionButton]
        }
        
        return introPage
    }
}

// MARK: EAIntroDelegate
extension IntroViewController: EAIntroDelegate {
    
    func introDidFinish(introView: EAIntroView!) {
        // Update WTStatusBar colors
        Utils.updateWTStatusBarColors(UIColor.darkGrayColor(), UIColor(hex: Cons.UI.colorBGNavBar), UIColor(hex: Cons.UI.colorTheme), false)
    }
    
    func intro(introView: EAIntroView!, pageAppeared page: EAIntroPage!, withIndex pageIndex: UInt) {
        
    }
    
    func intro(introView: EAIntroView!, pageStartScrolling page: EAIntroPage!, withIndex pageIndex: UInt) {
        
    }
    
    func intro(introView: EAIntroView!, pageEndScrolling page: EAIntroPage!, withIndex pageIndex: UInt) {
        
    }
}

// MARK: Actions
extension IntroViewController {
    
    func enableLocation(sender: UIButton) {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
    }
    
    func enableNotification(sender: UIButton) {
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil))
        UIApplication.sharedApplication().registerForRemoteNotifications()
    }
}

// MARK: Remove buttons
extension IntroViewController: CLLocationManagerDelegate {
    
    func removeSubviews(subviews: [UIView]) {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            for view in subviews {
                view.transform = CGAffineTransformMakeScale(1, 0.1)
                view.alpha = 0
            }
            }, completion: { finished -> Void in
                for view in subviews {
                    view.removeFromSuperview()
                }
        })
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse {
            if let page = self.introView?.pages[IntroViewPage.Map.rawValue] as? EAIntroPage {
                if let subViews = page.subviews as? [UIView] {
                    self.removeSubviews(subViews)
                }
            }
        }
    }
    
    // Notifications
    // Cons.Usr.DidRegisterForRemoteNotifications
    func didRegisterForRemoteNotifications() {
        if UIApplication.sharedApplication().isRegisteredForRemoteNotifications() {
            if let page = self.introView?.pages[IntroViewPage.News.rawValue] as? EAIntroPage {
                if let subViews = page.subviews as? [UIView] {
                    self.removeSubviews(subViews)
                }
            }
        }
    }
}
