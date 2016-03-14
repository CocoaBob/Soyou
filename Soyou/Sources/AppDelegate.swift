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

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Continuous Integration
        Fabric.with([Crashlytics.self])
        Crashlytics.sharedInstance().setUserIdentifier(UIDevice.currentDevice().identifierForVendor?.UUIDString)

        // Exclude database from iCloud backup
        FileManager.excludeFromBackup(FileManager.dbDir)
        
        // Check upgrades, may change database
        checkIfUpgraded()
        
        // Setup Database
        MagicalRecord.setLoggingLevel(.Error)
        MagicalRecord.setShouldDeleteStoreOnModelMismatch(true)
        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreAtURL(FileManager.dbURL)
        
        // Get Username from database
        Crashlytics.sharedInstance().setUserName(UserManager.shared.username)
        
        // Setup SDWebImage cache
        SDImageCache.sharedImageCache().shouldDecompressImages = false
        SDWebImageDownloader.sharedDownloader().shouldDecompressImages = false
        
        // Setup themes
        Themes.setupAppearances()
        
        // Setup view controllers
        let storyboardNames = ["NewsViewController", "ProductsViewController", "UserViewController"]
        let viewControllers = storyboardNames.map { (storyboardName) -> UINavigationController in
            return UIStoryboard(name: storyboardName, bundle: nil).instantiateInitialViewController() as! UINavigationController
        }
        
        // Setup the tab bar controller
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = viewControllers
        
        // Setup the window
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        
        // Show Introduction view
        self.checkIfShowIntroView()
        
        // Setup WeChat
        //use your AppID from dev.wechat.com to replace YOUR_WECHAT_APPID
        WXApi.registerApp("wxe3346afe30577009", withDescription:"奢有")
        
        return true
    }

    func applicationWillTerminate(application: UIApplication) {
        MagicalRecord.cleanUp()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Check if there are new Brands/Products/Regions/Stores to download
        DataManager.shared.updateData(nil)
        
        // Currency Manager
        CurrencyManager.shared.updateCurrencyRates(nil)
        
        // Check if the user token is valid
        if UserManager.shared.isLoggedIn {
            DataManager.shared.checkToken()
        }
    }

    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        DLog("applicationDidReceiveMemoryWarning")
        
        // Delete memory cache
        SDImageCache.sharedImageCache().clearMemory()
    }
    
    @available(iOS 9.0, *)
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        if shortcutItem.type == "shortcut.search" {
            self.showSearchView()
        } else if shortcutItem.type == "shortcut.favorites" {
            self.showFavoritesView()
        }
    }
}

// MARK: Notifications
extension AppDelegate {
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        DataManager.shared.registerForNotification(deviceTokenString)
        
        NSNotificationCenter.defaultCenter().postNotificationName(Cons.Usr.DidRegisterForRemoteNotifications, object: nil)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        DLog("userInfo=\(error.localizedDescription)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        DLog("userInfo=\(userInfo)")
    }

}

// MARK: Routines
extension AppDelegate {
    
    func checkIfUpgraded() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let lastInstalledBuild = userDefaults.objectForKey(Cons.App.lastInstalledBuild) as? String
        let currentAppBuild = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as? String
        if let lastInstalledVersion = lastInstalledBuild, currentAppVersion = currentAppBuild {
            if lastInstalledVersion == currentAppVersion {
                return
            }
        }
        
        userDefaults.setObject(currentAppBuild, forKey: Cons.App.lastInstalledBuild)
        
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
            brandsViewController = navController.viewControllers.first as? BrandsViewController
        {
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
            navController = tabBarController.viewControllers?[2] as? UINavigationController
        {
            tabBarController.selectedIndex = 2
            navController.popToRootViewControllerAnimated(false)
        }
    }
}
