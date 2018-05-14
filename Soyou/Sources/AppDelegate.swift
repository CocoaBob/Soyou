//
//  AppDelegate.swift
//  Soyou
//
//  Created by CocoaBob on 15/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: MBFingerTipWindow?
    var overlayWindow = UIWindow()
    
    var dbIsInitialized = false
    var shortcutItemType = ""
    var uiIsInitialized = false
    
    var tabBarTapCounter : Int = 0
    var tabBarTappedVC = UIViewController()
    
    // KVO Context
    fileprivate var KVOContextAppDelegate = 0
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        UserManager.shared.removeObserver(self, forKeyPath: "isLoggedIn", context: &KVOContextAppDelegate)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Disable constaint error log
//        UserDefaults.setBool(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        
        // AFNetworkActivityIndicatorManager
        AFNetworkActivityIndicatorManager.shared().isEnabled = true

        // Exclude database & cache from iCloud backup
        FileManager.excludeFromBackup(FileManager.dbDir)
        FileManager.excludeFromBackup(FileManager.cacheURL)
        
        // Setup URLCache
        URLCache.shared = URLCache(memoryCapacity:64*1024*1024, diskCapacity:512*1024*1024, diskPath:FileManager.cacheURL.path)
        
        // Setup SDWebImage cache
        SDWebImageDownloader.shared().shouldDecompressImages = false
        SDWebImageDownloader.shared().executionOrder = SDWebImageDownloaderExecutionOrder.lifoExecutionOrder
        SDWebImageManager.shared().delegate = SDWebImageManagerDelegateHandler.shared
        SDImageCache.shared().config.shouldDecompressImages = false
        
        // Setup themes
        Themes.setupAppearances()
        
        // Setup the window (must before MBProgressHUD)
        self.setupWindow()
        
        // Setup TabBarController
        self.setupTabBarController()
        
        // Setup view controllers (Must after setupWindow())
        self.setupViewControllers()
        
        // Observe
        UserManager.shared.addObserver(self, forKeyPath: "isLoggedIn", options: .new, context: &KVOContextAppDelegate)
        
        // Setup the overlay window
        self.setupOverlayWindow()
        
        // Setup Social Services
        self.setupSocialServices()
        
        // In case if it hasn't been registered on the server
        DataManager.shared.registerForNotification(false)
        
        // Initializing database
        self.setupDatabase()
        
        // Load current user
        UserManager.shared.loadCurrentUser(false)
        
        // Get Username from database
        Crashlytics.sharedInstance().setUserName(UserManager.shared.username)
        
        // If app is launched by 3D Touch shortcut menu
        self.showShortcutView()
        
        // Show Introduction view
        DispatchQueue.main.async {
            // Make sure NewsViewController's viewWillAppear is called before showIntroView()
            self.checkIfShowIntroView()
        }
        
        // RocketChat
        RocketChatManager.appDidFinishLaunchingWithOptions(launchOptions)
        
        // Crashlytics
        if UserManager.shared.isGDPRAccepted {
            Fabric.with([Crashlytics.self])
            Crashlytics.sharedInstance().setUserIdentifier(UIDevice.current.identifierForVendor?.uuidString)
        } else {
            UserManager.shared.checkGDPR()
        }
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        MagicalRecord.cleanUp()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Check server version to see if supported
        RequestManager.shared.checkServerVersion()
        // Update data
        self.updateDataAfterLaunching()
        // RocketChat
        RocketChatManager.appDidBecomeActive()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // RocketChat
        RocketChatManager.appDidEnterBackground()
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        DLog("applicationDidReceiveMemoryWarning")
        
        // Delete memory cache
        SDImageCache.shared().clearMemory()
    }
    
    // MARK: Shortcut and Deep Link
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        self.shortcutItemType = shortcutItem.type
        self.showShortcutView()
    }
    
    // iOS < 9
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        return DDSocialShareHandler.sharedInstance().application(application, handleOpen: url, sourceApplication: nil, annotation: nil)
    }
    
    // iOS < 9
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return DDSocialShareHandler.sharedInstance().application(application, handleOpen: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    // iOS >= 9
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        if RocketChatManager.handleDeepLink(url, completion: {
            if let tabBarController = self.window?.rootViewController as? UITabBarController,
                let navController = tabBarController.viewControllers?[1] as? UINavigationController,
                let chatVC = ChatViewController.shared {
                tabBarController.selectedIndex = 0
                navController.popToRootViewController(animated: false)
                navController.pushViewController(chatVC, animated: false)
            }
        }) {
            return true
        }
        var newOptions = [String: Any]()
        options.forEach { newOptions[$0.rawValue] = $1 }
        return DDSocialShareHandler.sharedInstance().application(app, open: url, options: newOptions )
    }
}

// MARK: - Notifications
extension AppDelegate {
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let characterSet: CharacterSet = CharacterSet(charactersIn:"<>")
        let pushNotificationDeviceTokenString = deviceToken.description.trimmingCharacters(in: characterSet).replacingOccurrences(of: " ", with:"")
        if pushNotificationDeviceTokenString != UserManager.shared.deviceToken {
            UserManager.shared.deviceToken = pushNotificationDeviceTokenString
            UserDefaults.setBool(false, forKey: Cons.App.hasRegisteredForNotification)
        }
        
        DataManager.shared.registerForNotification(false)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: Cons.Usr.DidRegisterForRemoteNotifications), object: nil)
        
        RocketChatManager.appDidRegisterForRemoteNotificationsWithDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        RocketChatManager.appDidFailToRegisterForRemoteNotificationsWithError(error)
        DLog(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        DLog(userInfo)
    }
}

// MARK: - KVO
extension AppDelegate {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "isLoggedIn" {
            self.setupViewControllers()
        }
    }
}

// MARK: - Routines
extension AppDelegate {
    
    func setupWindow() {
        self.window = MBFingerTipWindow(frame: UIScreen.main.bounds)
        self.window?.alwaysShowTouches = self.isMirroring()
        self.window?.makeKeyAndVisible()
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.updateFingerTouchEffect), name: NSNotification.Name.AVAudioSessionRouteChange, object: nil)
    }
    
    func setupOverlayWindow() {
        self.overlayWindow.isUserInteractionEnabled = false
        self.overlayWindow.frame = CGRect(x: 0, y: 0,
                                          width: UIScreen.main.bounds.width,
                                          height: Cons.UI.statusBarHeight)
        self.overlayWindow.windowLevel = UIWindowLevelStatusBar
        self.overlayWindow.backgroundColor = Utils.isSTGMode() ? UIColor.init(red: 1, green: 0, blue: 0, alpha: 0.1) : UIColor.clear
        self.overlayWindow.rootViewController = UIViewController()
        self.overlayWindow.isHidden = false
    }
    
    func setupDatabase() {
        // Setup Database
        MagicalRecord.setLoggingLevel(.error)
        MagicalRecord.setShouldDeleteStoreOnModelMismatch(true)
        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStore(at: FileManager.dbURL)
        self.dbIsInitialized = true
    }
    
    func setupTabBarController() {
        // Setup the tab bar controller
        let tabBarController = UITabBarController()
        tabBarController.delegate = self
        
        self.window?.rootViewController = tabBarController
        self.uiIsInitialized = true
    }
    
    func setupViewControllers() {
        guard let tabBarController = self.window?.rootViewController as? UITabBarController else { return }
        
        var viewControllers = [UIViewController]()
        if let existingVCs = tabBarController.viewControllers {
            viewControllers.append(contentsOf: existingVCs)
        } else {
            let storyboardNames = ["CirclesViewController", "ProductsViewController", "InfoViewController", "UserViewController"]
            let newVCs = storyboardNames.flatMap {
                UIStoryboard(name: $0, bundle: nil).instantiateInitialViewController()
            }
            viewControllers.append(contentsOf: newVCs)
        }
        
        if UserManager.shared.isLoggedIn && viewControllers.count == 4 {
            // Get subscriptions update
            SubscriptionsViewController.shared?.delegate = self
            // Setup SubscriptionsViewController
            SubscriptionsViewController.setup()
            if let rocketChatVC = SubscriptionsViewController.shared {
                let navV = UINavigationController(rootViewController: rocketChatVC)
                viewControllers.insert(navV, at: 1)
            }
            // Setup ChatViewController
            ChatViewController.setup()
        } else if !UserManager.shared.isLoggedIn && viewControllers.count == 5 {
            viewControllers.remove(at: 1)
        }
        
        tabBarController.setViewControllers(viewControllers, animated: false)
    }
    
    func setupSocialServices() {
        DDSocialShareHandler.sharedInstance().register(.weChat, appKey: "wxe3346afe30577009", appSecret: "485df03e708c879eea75686ce3432ab0", redirectURL: "", appDescription: "奢有为您搜罗全球顶级时尚奢侈品单价，分享各国折扣信息，提供品牌专卖店导航以及最新时尚资讯。")
        DDSocialShareHandler.sharedInstance().register(.sina, appKey: "2873812073", redirectURL: "https://api.weibo.com/oauth2/default.html")
        DDSocialShareHandler.sharedInstance().register(.QQ, appKey: "1105338972")
        DDSocialShareHandler.sharedInstance().register(.facebook)
        DDSocialShareHandler.sharedInstance().register(.google)
        DDSocialShareHandler.sharedInstance().register(.twitter, appKey: "wjOno5zRnBwENYuXtbYCS7bw5", appSecret: "vVlY71WUqP0rTc1D7vK6tqylB2PJpEhpMM88VvVVG3ONfwtu7I")
    }
    
    func showShortcutView() {
        if self.shortcutItemType == "shortcut.news" {
            self.showNewsView()
        } else if self.shortcutItemType == "shortcut.search" {
            self.showSearchView()
        } else if self.shortcutItemType == "shortcut.circles" {
            self.showCirclesView()
        } else if self.shortcutItemType == "shortcut.favorites" {
            self.showFavoritesView()
        } else if self.shortcutItemType == "shortcut.scan" {
            self.showScanView()
        } else if self.shortcutItemType == "shortcut.qr_code" {
            self.showMyQRCodeView()
        }
    }
    
    func updateDataAfterLaunching() {
        if !self.dbIsInitialized {
            return
        }
        // Check if there are new Brands/Products/Regions/Stores to download
        DataManager.shared.updateData(nil)
        
        // Currency Manager
        CurrencyManager.shared.updateCurrencyRates(CurrencyManager.shared.userCurrency, nil)
        
        // Banned Keywords
        CensorshipManager.shared.updateFromServer()
        
        // Check if the user token is valid
        if UserManager.shared.isLoggedIn {
            DataManager.shared.checkToken()
        }
        
        // Analytics
        DataManager.shared.analyticsAppBecomeActive()
    }
    
    func needsToShowIntroView() -> Bool {
        let lastIntroVersion = UserDefaults.stringForKey(Cons.App.lastIntroVersion)
        let currentAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString" as String) as? String
        
        // If versions are same, skip
        if let lastIntroVersion = lastIntroVersion, let currentAppVersion = currentAppVersion {
            if lastIntroVersion == currentAppVersion {
                return false
            }
        }
        
        // If main versions are same, skip
        if let lastMainVersion = lastIntroVersion?.components(separatedBy: ".").first,
            let currMainVersion = currentAppVersion?.components(separatedBy: ".").first,
            let lastMainVersionInt = Int(lastMainVersion),
            let currMainVersionInt = Int(currMainVersion) {
            if lastMainVersionInt >= currMainVersionInt {
                return false
            }
        }
        
        return true
    }
    
    func checkIfShowIntroView() {
        if self.needsToShowIntroView() {
            let currentAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString" as String) as? String
            
            // Remember the current version
            UserDefaults.setObject(currentAppVersion as AnyObject?, forKey: Cons.App.lastIntroVersion)
            
            IntroViewController.shared.showIntroView()
        }
    }
    
    func showCirclesView() {
        if let tabBarController = self.window?.rootViewController as? UITabBarController,
            let navController = tabBarController.viewControllers?[2] as? UINavigationController {
            tabBarController.selectedIndex = 0
            navController.popToRootViewController(animated: false)
        }
    }
    
    func showSearchView() {
        if let tabBarController = self.window?.rootViewController as? UITabBarController,
            let viewControllers = tabBarController.viewControllers {
            var searchTabIndex = 1
            if viewControllers.count == 5 {
                searchTabIndex = 2
            }
            if let navController = viewControllers[searchTabIndex] as? UINavigationController,
                let brandsViewController = navController.viewControllers.first as? BrandsViewController {
                tabBarController.selectedIndex = searchTabIndex
                navController.popToRootViewController(animated: false)
                let _ = brandsViewController.view
                DispatchQueue.main.async {
                    brandsViewController.searchController?.searchBar.becomeFirstResponder()
                }
            }
        }
    }
    
    func showNewsView() {
        if let tabBarController = self.window?.rootViewController as? UITabBarController,
            let navController = tabBarController.viewControllers?[0] as? UINavigationController {
            tabBarController.selectedIndex = 2
            navController.popToRootViewController(animated: false)
        }
    }
    
    func showFavoritesView() {
        if let tabBarController = self.window?.rootViewController as? UITabBarController,
            let navController = tabBarController.viewControllers?[3] as? UINavigationController {
            tabBarController.selectedIndex = 3
            navController.popToRootViewController(animated: false)
        }
    }
    
    func showScanView() {
        Utils.shared.showScanViewController(nil)
    }
    
    func showMyQRCodeView() {
        Utils.showMyQRCode(nil)
    }
}

// MARK: - UITabBarControllerDelegate
extension AppDelegate: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let toppestViewController = viewController.toppestViewController()
        toppestViewController?.viewDidAppear(false)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        self.tabBarTapCounter += 1
        let hasTappedTwice = self.tabBarTappedVC == viewController
        self.tabBarTappedVC = viewController
        
        // Double Tapped
        if self.tabBarTapCounter == 2 && hasTappedTwice {
            self.tabBarTapCounter = 0
            viewController.scrollToTop()
        }
        if self.tabBarTapCounter == 1 {
            DispatchAfter(0.3) {
                self.tabBarTapCounter = 0
            }
        }
        return true
    }
}

// MARK: - Show FingerTips
extension AppDelegate {
    
    func isMirroring() -> Bool {
        var returnValue = false
        for output in AVAudioSession.sharedInstance().currentRoute.outputs {
            if (output.portType == AVAudioSessionPortHDMI) {
                returnValue = true
            }
        }
        return returnValue;
    }
    
    @objc func updateFingerTouchEffect() {
        self.window?.alwaysShowTouches = self.isMirroring()
    }
}

// MARK: - Handle Universsal Links
extension AppDelegate {
    
    // Universal Links
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            guard let url = userActivity.webpageURL else { return false }
            UniversalLinkerHandler.shared.handleURL(url)
            return true
        }
        return false
    }
}

// MARK: - Rocket Chat Update
extension AppDelegate: SubscriptionsViewControllerDelegate {
    
    func rocketChatDidUpdateSubscriptions() {
        RocketChatManager.getUnreadNumber { unreadNumber in
            self.updateRocketChatUnreadNumber(unreadNumber)
        }
    }
    
    func updateRocketChatUnreadNumber(_ unreadNumber: Int) {
        if unreadNumber == 0 {
            hideRocketChatUnreadNumber()
            return
        }
        
        let tabBarController = self.window?.rootViewController as? UITabBarController
        guard let tabbar = tabBarController?.tabBar else { return }
        
        if !isRocketChatUnreadNumberVisible() {
            let tabIndex = 1
            let radius: CGFloat = 8
            let topMargin: CGFloat = 4
            let width: CGFloat = unreadNumber > 99 ? 30 : (unreadNumber > 9 ? 23 : (unreadNumber > 0 ? 16 : 0))
            let count = CGFloat(tabbar.items!.count)
            let tabHalfWidth: CGFloat = tabbar.bounds.width / (count * 2)
            let xOffset  = tabHalfWidth * CGFloat(tabIndex * 2 + 1)
            let imageHalfWidth: CGFloat = (tabbar.items?[tabIndex].selectedImage?.size.width ?? 0) / 2.0
            let bgView = UIView(frame: CGRect(x: xOffset + imageHalfWidth - radius, y: topMargin, width: width, height: radius * 2))
            bgView.tag = 2345
            bgView.backgroundColor = UIColor(hex8:0xE1483CFF)
            bgView.layer.cornerRadius = radius
            bgView.addSubview(UILabel())
            tabbar.addSubview(bgView)
        }
        
        if let bgView = tabbar.subviews.filter({ $0.tag == 2345 }).last,
            let lbl = bgView.subviews.last as? UILabel {
            lbl.text = "\(unreadNumber)"
            lbl.font = UIFont.systemFont(ofSize: 11)
            lbl.textColor = .white
            lbl.sizeToFit()
            lbl.center = CGPoint(x: bgView.bounds.width / 2.0, y: bgView.bounds.height / 2.0)
        }
    }
    
    func hideRocketChatUnreadNumber() {
        let tabBarController = self.window?.rootViewController as? UITabBarController
        guard let tabbar = tabBarController?.tabBar else { return }
        tabbar.subviews.filter({ $0.tag == 2345 }).last?.removeFromSuperview()
    }
    
    func isRocketChatUnreadNumberVisible() -> Bool {
        let tabBarController = self.window?.rootViewController as? UITabBarController
        guard let tabbar = tabBarController?.tabBar else { return false }
        return !tabbar.subviews.filter({ $0.tag == 2345 }).isEmpty
    }
}
