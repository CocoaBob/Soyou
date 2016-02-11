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
        // Setup Database
        MagicalRecord.setLoggingLevel(.Error)
        MagicalRecord.setShouldDeleteStoreOnModelMismatch(true)
        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreNamed("Soyou.sqlite")
        
        // Setup SDWebImage cache
        SDImageCache.sharedImageCache().shouldDecompressImages = false
        SDWebImageDownloader.sharedDownloader().shouldDecompressImages = false
        
        // Setup Push notification
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil))
        application.registerForRemoteNotifications()
        
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
        WXApi.registerApp("wx0cb0066522588a9c", withDescription:"奢有")
        
        return true
    }

    func applicationWillTerminate(application: UIApplication) {
        MagicalRecord.cleanUp()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Check if there are new Brands/Products/Regions/Stores to download
        DataManager.shared.updateData(nil)
        
        // Currency Manager
        CurrencyManager.shared.updateCurrencyRates()
        
        // Check if the user token is valid
        DataManager.shared.checkToken()
    }

    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        DLog("applicationDidReceiveMemoryWarning")
        
        // Delete memory cache
        SDImageCache.sharedImageCache().clearMemory()
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
        let lastInstalledVersion = DataManager.shared.getAppInfo(Cons.App.lastInstalledVersion)
        let currentAppVersion = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as? String
        if let lastInstalledVersion = lastInstalledVersion, currentAppVersion = currentAppVersion {
            if lastInstalledVersion == currentAppVersion {
                return
            }
        }
        
        DataManager.shared.setAppInfo(currentAppVersion ?? "", forKey: Cons.App.lastInstalledVersion)
        
        // Do something for the new version
    }
    
    func checkIfShowIntroView() {
        let lastIntroVersion = DataManager.shared.getAppInfo(Cons.App.lastIntroVersion)
        let currentAppVersion = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as? String
        if let lastIntroVersion = lastIntroVersion, currentAppVersion = currentAppVersion {
            if lastIntroVersion == currentAppVersion {
                return
            }
        }
        
        DataManager.shared.setAppInfo(currentAppVersion ?? "", forKey: Cons.App.lastIntroVersion)
        
        // Check if it's main version upgrade
        if let lastMainVersion = lastIntroVersion?.componentsSeparatedByString(".").first,
            currMainVersion = currentAppVersion?.componentsSeparatedByString(".").first,
            lastMainVersionInt = Int(lastMainVersion),
            currMainVersionInt = Int(currMainVersion) {
                if lastMainVersionInt >= currMainVersionInt {
                    return
                }
        }
        
        // Show Intro View
        IntroViewController.showIntroView()
    }
}
