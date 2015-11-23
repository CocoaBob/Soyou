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
        
        // Setup themes
        Themes.setupAppearances()
        
        // Setup view controllers
        var viewControllers: Array = [UIViewController]()
        if let viewController = UIStoryboard(name: "NewsViewController", bundle: nil).instantiateInitialViewController() {
            viewControllers.append(UINavigationController(rootViewController: viewController))
        }
        if let viewController = UIStoryboard(name: "BrandsViewController", bundle: nil).instantiateInitialViewController() {
            viewControllers.append(UINavigationController(rootViewController: viewController))
        }
        if let viewController = UIStoryboard(name: "AccountViewController", bundle: nil).instantiateInitialViewController() {
            viewControllers.append(UINavigationController(rootViewController: viewController))
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
        
        return true
    }

    func applicationWillTerminate(application: UIApplication) {
        MagicalRecord.cleanUp()
    }

}

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

