//
//  IntroViewController.swift
//  Soyou
//
//  Created by CocoaBob on 11/02/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

enum IntroViewPage: Int {
    case welcome
    case news
    case search
    case prices
    case map
    case count
}

class IntroViewController: NSObject {
    
    static let shared = IntroViewController()
    
    fileprivate var locationManager: CLLocationManager?
    var introView: EAIntroView?
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(IntroViewController.didRegisterForRemoteNotifications), name: NSNotification.Name(rawValue: Cons.Usr.DidRegisterForRemoteNotifications), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func showIntroView() {
        guard let keyWindow = UIApplication.shared.keyWindow else { return }
        
        var introPages = [EAIntroPage]()
        
        for i in 0..<IntroViewPage.count.rawValue {
            let page: IntroViewPage = IntroViewPage(rawValue: i) ?? .count
            switch page {
            case .welcome:
                introPages.append(introPageForWelcome(keyWindow.bounds.size))
            case .search:
                introPages.append(introPageForSearch(keyWindow.bounds.size))
            case .prices:
                introPages.append(introPageForPrices(keyWindow.bounds.size))
            case .map:
                introPages.append(introPageForMap(keyWindow.bounds.size))
            case .news:
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
        self.introView?.skipButton.setTitle(NSLocalizedString("intro_vc_skip_button_done"), for: .normal)
        self.introView?.showSkipButtonOnlyOnLastPage = true
//        self.introView?.swipeToExit = false
        
        self.introView?.show(in: keyWindow, animateDuration: 0.3)
    }
}

// MARAK: Pages
extension IntroViewController {
    
    func newIntroPage(_ titleID: String, _ descID: String, _ imageID: String, _ viewSize: CGSize) -> EAIntroPage {
        let introPage = EAIntroPage()
        introPage.title = NSLocalizedString(titleID)
        introPage.desc = NSLocalizedString(descID)
        introPage.titleIconView = UIImageView(image: UIImage(named: NSLocalizedString(imageID)))
        introPage.titleIconView.contentMode = .scaleAspectFit
        introPage.titleIconView.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height - 220) // -160-8-44-8
        return introPage
    }
    
    func introPageForWelcome(_ viewSize: CGSize) -> EAIntroPage {
        let introPage = self.newIntroPage("intro_vc_title_welcome", "intro_vc_desc_welcome", "intro_vc_image_welcome", viewSize)
        return introPage
    }
    
    func introPageForSearch(_ viewSize: CGSize) -> EAIntroPage {
        let introPage = self.newIntroPage("intro_vc_title_search", "intro_vc_desc_search", "intro_vc_image_search", viewSize)
        return introPage
    }
    
    func introPageForPrices(_ viewSize: CGSize) -> EAIntroPage {
        let introPage = self.newIntroPage("intro_vc_title_prices", "intro_vc_desc_prices", "intro_vc_image_prices", viewSize)
        return introPage
    }
    
    func introPageForMap(_ viewSize: CGSize) -> EAIntroPage {
        let introPage = self.newIntroPage("intro_vc_title_map", "intro_vc_desc_map", "intro_vc_image_map", viewSize)
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            let actionButton = UIButton(frame: CGRect(x: (viewSize.width - 240)/2.0, y: viewSize.height - 50 - 44, width: 240, height: 44))
            actionButton.borderColor = UIColor.white
            actionButton.borderWidth = 1
            actionButton.cornerRadius = 5
            actionButton.setTitle(NSLocalizedString("intro_vc_enable_location"), for: .normal)
            actionButton.addTarget(self, action: #selector(IntroViewController.enableLocation(_:)), for: .touchUpInside)
            introPage.subviews = [actionButton]
        }
        
        return introPage
    }
    
    func introPageForNews(_ viewSize: CGSize) -> EAIntroPage {
        let introPage = self.newIntroPage("intro_vc_title_news", "intro_vc_desc_news", "intro_vc_image_news", viewSize)
        
        if !UIApplication.shared.isRegisteredForRemoteNotifications {
            let actionButton = UIButton(frame: CGRect(x: (viewSize.width - 240)/2.0, y: viewSize.height - 50 - 44, width: 240, height: 44))
            actionButton.borderColor = UIColor.white
            actionButton.borderWidth = 1
            actionButton.cornerRadius = 5
            actionButton.setTitle(NSLocalizedString("intro_vc_enable_notification"), for: .normal)
            actionButton.addTarget(self, action: #selector(IntroViewController.enableNotification(_:)), for: .touchUpInside)
            introPage.subviews = [actionButton]
        }
        
        return introPage
    }
}

// MARK: EAIntroDelegate
extension IntroViewController: EAIntroDelegate {
    
    func introDidFinish(_ introView: EAIntroView!) {

    }
    
    func intro(_ introView: EAIntroView!, pageAppeared page: EAIntroPage!, with pageIndex: UInt) {
        
    }
    
    func intro(_ introView: EAIntroView!, pageStartScrolling page: EAIntroPage!, with pageIndex: UInt) {
        
    }
    
    func intro(_ introView: EAIntroView!, pageEndScrolling page: EAIntroPage!, with pageIndex: UInt) {
        
    }
}

// MARK: Actions
extension IntroViewController {
    
    @objc func enableLocation(_ sender: UIButton) {
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
    }
    
    @objc func enableNotification(_ sender: UIButton) {
        UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert],
                                                                                         categories: nil))
        UIApplication.shared.registerForRemoteNotifications()
    }
}

// MARK: Remove buttons
extension IntroViewController: CLLocationManagerDelegate {
    
    func removeSubviews(_ subviews: [UIView]) {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            for view in subviews {
                view.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                view.alpha = 0
            }
            }, completion: { finished -> Void in
                for view in subviews {
                    view.removeFromSuperview()
                }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            if let page = self.introView?.pages[IntroViewPage.map.rawValue] {
                if let subViews = page.subviews {
                    self.removeSubviews(subViews)
                }
            }
        }
    }
    
    // Notifications
    // Cons.Usr.DidRegisterForRemoteNotifications
    @objc func didRegisterForRemoteNotifications() {
        if UIApplication.shared.isRegisteredForRemoteNotifications {
            if let page = self.introView?.pages[IntroViewPage.news.rawValue] {
                if let subViews = page.subviews {
                    self.removeSubviews(subViews)
                }
            }
        }
    }
}
