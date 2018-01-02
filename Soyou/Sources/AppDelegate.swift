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

    var window: UIWindow?
    var overlayWindow = UIWindow()
    
    var dbIsInitialized = false
    var shortcutItemType = ""
    var uiIsInitialized = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Crashlytics
        Fabric.with([Crashlytics.self])
        Crashlytics.sharedInstance().setUserIdentifier(UIDevice.current.identifierForVendor?.uuidString)
        
        // AFNetworkActivityIndicatorManager
        AFNetworkActivityIndicatorManager.shared().isEnabled = true

        // Exclude database & cache from iCloud backup
        FileManager.excludeFromBackup(FileManager.dbDir)
        FileManager.excludeFromBackup(FileManager.cacheURL)
        
        // Setup URLCache
        URLCache.shared = URLCache(memoryCapacity:64*1024*1024, diskCapacity:512*1024*1024, diskPath:FileManager.cacheURL.path)
        
        // Setup SDWebImage cache
        SDWebImageDownloader.shared().shouldDecompressImages = false
        
        // Setup themes
        Themes.setupAppearances()
        
        // Setup the window (must before MBProgressHUD)
        self.setupWindow()
        
        // Setup view controllers (Must after setupWindow())
        self.setupTabBarController()
        
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
        
        // Check updates
        self.updateDataAfterLaunching()
        
        // If app is launched by 3D Touch shortcut menu
        self.showShortcutView()
        
        // Show Introduction view
        DispatchQueue.main.async {
            // Make sure NewsViewController's viewWillAppear is called before showIntroView()
            self.checkIfShowIntroView()
        }
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        MagicalRecord.cleanUp()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        self.updateDataAfterLaunching()
        
        // Clear badge
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        DLog("applicationDidReceiveMemoryWarning")
        
        // Delete memory cache
        SDImageCache.shared().clearMemory()
    }
    
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
        var newOptions = [String: Any]()
        options.forEach { newOptions[$0.rawValue] = $1 }
        return DDSocialShareHandler.sharedInstance().application(app, open: url, options: newOptions )
    }
}

// MARK: Notifications
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
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        DLog(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        DLog(userInfo)
    }
}

// MARK: Routines
extension AppDelegate {
    
    func setupWindow() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
    }
    
    func setupOverlayWindow() {
        self.overlayWindow.frame = CGRect(x: 0, y: 0,
                                          width: UIScreen.main.bounds.width,
                                          height: Cons.UI.statusBarHeight)
        self.overlayWindow.windowLevel = UIWindowLevelStatusBar
        let isSTGMode = UserDefaults.boolForKey(Cons.App.isSTGMode)
        self.overlayWindow.backgroundColor = isSTGMode ? UIColor.init(red: 1, green: 0, blue: 0, alpha: 0.1) : UIColor.clear
        self.overlayWindow.rootViewController = UIViewController()
        self.overlayWindow.isHidden = false
    }
    
    func setupDatabase() {
        // Check upgrades, may change database
        self.checkIfUpgraded()
        
        // Setup Database
        MagicalRecord.setLoggingLevel(.error)
        MagicalRecord.setShouldDeleteStoreOnModelMismatch(true)
        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStore(at: FileManager.dbURL)
        self.dbIsInitialized = true
    }
    
    func setupTabBarController() {
        let storyboardNames = ["InfoViewController", "ProductsViewController", "CirclesViewController", "UserViewController"]
        let viewControllers = storyboardNames.flatMap {
            UIStoryboard(name: $0, bundle: nil).instantiateInitialViewController()
        }
        
        // Setup the tab bar controller
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = viewControllers
        tabBarController.delegate = self
        
        self.window?.rootViewController = tabBarController
        self.uiIsInitialized = true
    }
    
    func setupSocialServices() {
        DDSocialShareHandler.sharedInstance().register(.weChat, appKey: "wxe3346afe30577009", appSecret: "", redirectURL: "", appDescription: "奢有为您搜罗全球顶级时尚奢侈品单价，分享各国折扣信息，提供品牌专卖店导航以及最新时尚资讯。")
        DDSocialShareHandler.sharedInstance().register(.sina, appKey: "2873812073", redirectURL: "https://api.weibo.com/oauth2/default.html")
        DDSocialShareHandler.sharedInstance().register(.QQ, appKey: "1105338972")
        DDSocialShareHandler.sharedInstance().register(.facebook)
        DDSocialShareHandler.sharedInstance().register(.google)
        DDSocialShareHandler.sharedInstance().register(.twitter, appKey: "wjOno5zRnBwENYuXtbYCS7bw5", appSecret: "vVlY71WUqP0rTc1D7vK6tqylB2PJpEhpMM88VvVVG3ONfwtu7I")
    }
    
    func showShortcutView() {
        if self.shortcutItemType == "shortcut.search" {
            self.showSearchView()
        } else if self.shortcutItemType == "shortcut.favorites" {
            self.showFavoritesView()
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
        
        // Check if the user token is valid
        if UserManager.shared.isLoggedIn {
            DataManager.shared.checkToken()
        }
        
        // Analytics
        DataManager.shared.analyticsAppBecomeActive()
    }
    
    func checkIfUpgraded() {
        let lastInstalledBuild = UserDefaults.stringForKey(Cons.App.lastInstalledBuild)
        let currentAppBuild = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
        if let lastInstalledBuild = lastInstalledBuild, let currentAppVersion = currentAppBuild {
            if lastInstalledBuild == currentAppVersion {
                return
            }
        }
        
        UserDefaults.setObject(currentAppBuild as AnyObject?, forKey: Cons.App.lastInstalledBuild)
        
        // TODO
        // Database schema changed in commit 417, delete old database
//        if lastInstalledBuild == nil || Int(lastInstalledBuild ?? "0") < 417 {
//            guard let dbPath = FileManager.dbURL.path else {
//                return
//            }
//            if Foundation.FileManager.default.fileExists(atPath: dbPath) {
//                do {
//                    try Foundation.FileManager.default.removeItem(at: FileManager.dbURL as URL)
//                } catch {
//                    DLog(error)
//                }
//            }
//        }
    }
    
    func needsToShowIntroView() -> Bool {
        // If not first time to launch version 1.x
        // TODO: Remove in v1.5
//        if let _ = UserDefaults.stringForKey(Cons.App.lastInstalledBuild) {
//            return false
//        }
        
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
    
    func showSearchView() {
        if let tabBarController = self.window?.rootViewController as? UITabBarController,
            let navController = tabBarController.viewControllers?[1] as? UINavigationController,
            let brandsViewController = navController.viewControllers.first as? BrandsViewController {
            tabBarController.selectedIndex = 1
            navController.popToRootViewController(animated: false)
            let _ = brandsViewController.view
            DispatchQueue.main.async {
                brandsViewController.searchController?.searchBar.becomeFirstResponder()
            }
        }
    }
    
    func showFavoritesView() {
        if let tabBarController = self.window?.rootViewController as? UITabBarController,
            let navController = tabBarController.viewControllers?[2] as? UINavigationController {
            tabBarController.selectedIndex = 2
            navController.popToRootViewController(animated: false)
        }
    }
}

// MARK: UITabBarControllerDelegate
extension AppDelegate: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let toppestViewController = viewController.toppestViewController()
        toppestViewController?.viewDidAppear(false)
    }
}
