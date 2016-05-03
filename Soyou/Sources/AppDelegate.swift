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
    
    var dbIsInitialized = false
    var shortcutItemType = ""
    var uiIsInitialized = false

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Crashlytics
        Fabric.with([Crashlytics.self])
        Crashlytics.sharedInstance().setUserIdentifier(UIDevice.currentDevice().identifierForVendor?.UUIDString)
        
        // AFNetworkActivityIndicatorManager
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true

        // Exclude database from iCloud backup
        FileManager.excludeFromBackup(FileManager.dbDir)
        
        // Setup SDWebImage cache
        SDImageCache.sharedImageCache().shouldDecompressImages = false
        SDWebImageDownloader.sharedDownloader().shouldDecompressImages = false
        
        // Setup themes
        Themes.setupAppearances()
        
        // Setup the window (must before MBProgressHUD)
        self.setupWindow()
        
        // Show updating massage
        DispatchAfter(0.3) {
            self.showInitializationView()
        }
        
        DispatchAfter(0.4) {
            self.setupDatabase()
            
            // Load current user
            UserManager.shared.loadCurrentUser(false)
            
            // Get Username from database
            Crashlytics.sharedInstance().setUserName(UserManager.shared.username)
            
            // Hide updating message
            self.hideInitializationView()
            
            // Setup view controllers (Must after initializing the database)
            self.setupTabBarController()
            
            // Check updates
            self.updateDataAfterLaunching()
            
            // If app is launched by 3D Touch shortcut menu
            self.showShortcutView()
            
            // Show Introduction view
            DispatchAfter(0.01) {
                // Make sure NewsViewController's viewWillAppear is called before showIntroView()
                self.checkIfShowIntroView()
            }
        }
        
        // Setup Social Services
        self.setupSocialServices()
        
        // In case if it hasn't been registered on the server
        DataManager.shared.registerForNotification()
        
        return true
    }

    func applicationWillTerminate(application: UIApplication) {
        MagicalRecord.cleanUp()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        self.updateDataAfterLaunching()
    }

    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        DLog("applicationDidReceiveMemoryWarning")
        
        // Delete memory cache
        SDImageCache.sharedImageCache().clearMemory()
    }
    
    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        self.shortcutItemType = shortcutItem.type
        self.showShortcutView()
    }
    
    // iOS < 9
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return DDSocialShareHandler.sharedInstance().application(application, handleOpenURL: url, sourceApplication: nil, annotation: nil)
    }
    
    // iOS < 9
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return DDSocialShareHandler.sharedInstance().application(application, handleOpenURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    // iOS >= 9
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        return DDSocialShareHandler.sharedInstance().application(app, openURL: url, options: options)
    }
}

// MARK: Notifications
extension AppDelegate {
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let characterSet: NSCharacterSet = NSCharacterSet(charactersInString:"<>")
        let pushNotificationDeviceTokenString = deviceToken.description.stringByTrimmingCharactersInSet(characterSet).stringByReplacingOccurrencesOfString(" ", withString:"")
        if pushNotificationDeviceTokenString != UserManager.shared.deviceToken {
            UserManager.shared.deviceToken = pushNotificationDeviceTokenString
            UserDefaults.setBool(false, forKey: Cons.App.hasRegisteredForNotification)
        }
        
        DataManager.shared.registerForNotification()
        
        NSNotificationCenter.defaultCenter().postNotificationName(Cons.Usr.DidRegisterForRemoteNotifications, object: nil)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        DLog(error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        DLog(userInfo)
    }

}

// MARK: Routines
extension AppDelegate {
    
    func showInitializationView() {
        if let hud = MBProgressHUD.showLoader(self.window!) {
            hud.mode = MBProgressHUDMode.Text
            hud.labelText = NSLocalizedString("initializing_database")
        }
    }
    
    func hideInitializationView() {
        MBProgressHUD.hideLoader(self.window!)
    }
    
    func setupWindow() {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = UINavigationController(rootViewController: UIViewController())
        self.window?.rootViewController?.view.backgroundColor = UIColor(hex: Cons.UI.colorBG)
        self.window?.makeKeyAndVisible()
    }
    
    func setupDatabase() {
        // Check upgrades, may change database
        self.checkIfUpgraded()
        
        // Setup Database
        MagicalRecord.setLoggingLevel(.Error)
        MagicalRecord.setShouldDeleteStoreOnModelMismatch(true)
        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreAtURL(FileManager.dbURL)
        self.dbIsInitialized = true
    }
    
    func setupTabBarController() {
        let storyboardNames = ["NewsViewController", "ProductsViewController", "UserViewController"]
        let viewControllers = storyboardNames.flatMap {
            UIStoryboard(name: $0, bundle: nil).instantiateInitialViewController()
        }
        
        // Setup the tab bar controller
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = viewControllers
        tabBarController.delegate = self
        
        self.window?.rootViewController = tabBarController
        self.uiIsInitialized = true
        
//        for viewController in viewControllers {
//            if viewController is UINavigationController {
//                if let firstViewController = (viewController as? UINavigationController)?.viewControllers.first {
//                    let _ = firstViewController.view
//                }
//            } else {
//                let _ = viewController.view
//            }
//        }
    }
    
    func setupSocialServices() {
        DDSocialShareHandler.sharedInstance().registerPlatform(.WeChat, appKey: "wxe3346afe30577009", appSecret: "", redirectURL: "", appDescription: "奢有为您搜罗全球顶级时尚奢侈品单价，分享各国折扣信息，提供品牌专卖店导航以及最新时尚资讯。")
        DDSocialShareHandler.sharedInstance().registerPlatform(.Sina, appKey: "2873812073", redirectURL: "https://api.weibo.com/oauth2/default.html")
        DDSocialShareHandler.sharedInstance().registerPlatform(.QQ, appKey: "1105338972")
        DDSocialShareHandler.sharedInstance().registerPlatform(.Facebook)
        DDSocialShareHandler.sharedInstance().registerPlatform(.Google)
        DDSocialShareHandler.sharedInstance().registerPlatform(.Twitter, appKey: "wjOno5zRnBwENYuXtbYCS7bw5", appSecret: "vVlY71WUqP0rTc1D7vK6tqylB2PJpEhpMM88VvVVG3ONfwtu7I")
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
        let currentAppBuild = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as? String
        if let lastInstalledVersion = lastInstalledBuild, currentAppVersion = currentAppBuild {
            if lastInstalledVersion == currentAppVersion {
                return
            }
        }
        
        UserDefaults.setObject(currentAppBuild, forKey: Cons.App.lastInstalledBuild)
        
        // Database schema changed in commit 417, delete old database
        if lastInstalledBuild == nil || Int(lastInstalledBuild ?? "0") < 417 {
            guard let dbPath = FileManager.dbURL.path else {
                return
            }
            if NSFileManager.defaultManager().fileExistsAtPath(dbPath) {
                do {
                    try NSFileManager.defaultManager().removeItemAtURL(FileManager.dbURL)
                } catch {
                    DLog(error)
                }
            }
        }
    }
    
    func checkIfShowIntroView() {
        let lastIntroVersion = DataManager.shared.getAppInfo(Cons.App.lastIntroVersion)
        let currentAppVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString" as String) as? String
        
        // If versions are same, skip
        if let lastIntroVersion = lastIntroVersion, currentAppVersion = currentAppVersion {
            if lastIntroVersion == currentAppVersion {
                return
            }
        }
        
        // Remember the current version
        DataManager.shared.setAppInfo(currentAppVersion ?? "", forKey: Cons.App.lastIntroVersion)
        
        // If main versions are same, skip
        if let lastMainVersion = lastIntroVersion?.componentsSeparatedByString(".").first,
            currMainVersion = currentAppVersion?.componentsSeparatedByString(".").first,
            lastMainVersionInt = Int(lastMainVersion),
            currMainVersionInt = Int(currMainVersion) {
                if lastMainVersionInt >= currMainVersionInt {
                    return
                }
        }
        
        // Show Intro View
        IntroViewController.shared.showIntroView()
    }
    
    func showSearchView() {
        if let tabBarController = self.window?.rootViewController as? UITabBarController,
            navController = tabBarController.viewControllers?[1] as? UINavigationController,
            brandsViewController = navController.viewControllers.first as? BrandsViewController {
            tabBarController.selectedIndex = 1
            navController.popToRootViewControllerAnimated(false)
            let _ = brandsViewController.view
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                brandsViewController.searchController?.searchBar.becomeFirstResponder()
            })
        }
    }
    
    func showFavoritesView() {
        if let tabBarController = self.window?.rootViewController as? UITabBarController,
            navController = tabBarController.viewControllers?[2] as? UINavigationController {
            tabBarController.selectedIndex = 2
            navController.popToRootViewControllerAnimated(false)
        }
    }
}

// MARK: UITabBarControllerDelegate
extension AppDelegate: UITabBarControllerDelegate {
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        let toppestViewController = viewController.toppestViewController()
        toppestViewController?.viewDidAppear(false)
    }
}
