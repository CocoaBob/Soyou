//
//  AppDelegate.swift
//  iPrices
//
//  Created by CocoaBob on 15/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
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
        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreNamed("iPrices.sqlite")
        
        // Setup Push notification
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Alert, categories: nil))
        application.registerForRemoteNotifications()
        
        // Setup themes
        Themes.setupAppearances()
        
        // Setup view controllers
        let storyboardNames = ["NewsViewController", "BrandsViewController", "UserViewController"]
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
        self.showIntroView()
        
        // Setup WeChat
        //use your AppID from dev.wechat.com to replace YOUR_WECHAT_APPID
        WXApi.registerApp("wx0cb0066522588a9c", withDescription:"包打听")
        
        return true
    }

    func applicationWillTerminate(application: UIApplication) {
        MagicalRecord.cleanUp()
    }

}

// MARK: Notifications
extension AppDelegate {
    
    private func handleSuccess(responseObject: AnyObject?, deviceTokenString: String) {
        UserManager.shared.deviceToken = deviceTokenString
        DLog("Push register success")
    }
    
    private func handleError(error: NSError?) {
        DLog(error)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
        let deviceTokenString: String = ( deviceToken.description as NSString )
            .stringByTrimmingCharactersInSet( characterSet )
            .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
        
        RequestManager.shared.registerForNotification(UserManager.shared.uuid, deviceTokenString,
            { (responseObject: AnyObject?) -> () in self.handleSuccess(responseObject, deviceTokenString: deviceTokenString) },
            { (error: NSError?) -> () in self.handleError(error) }
        );
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        DLog("userInfo=\(error.localizedDescription)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        DLog("userInfo=\(userInfo)")
    }

}

// MARK:
extension AppDelegate: EAIntroDelegate {
    
    func showIntroView() {
        let lastIntroVersion = NSUserDefaults.standardUserDefaults().objectForKey(Cons.App.lastVerIntro) as? String
        let currentAppVersion = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as? String
        if let lastIntroVersion = lastIntroVersion, currentAppVersion = currentAppVersion {
            if lastIntroVersion == currentAppVersion {
                return
            }
        }
        
        NSUserDefaults.standardUserDefaults().setObject(currentAppVersion, forKey: Cons.App.lastVerIntro)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        var introPages = [EAIntroPage]()
        for i in 1...4 {
            let introPage = EAIntroPage()
            introPage.title = "Introduction Page \(i)"
            introPage.desc = "Introduction descriptions for Page \(i)"
            introPage.bgImage = UIImage(named: "bg\(i)")
            introPage.titleIconView = UIImageView(image: UIImage(named: "title\(i)"))
            introPages.append(introPage)
        }
        let introView = EAIntroView(frame: self.window!.bounds, andPages: introPages)
        introView.delegate = self
        
        introView.showInView(self.window!, animateDuration: 0.3)
    }
    
    func introDidFinish(introView: EAIntroView!) {
        
    }
}

