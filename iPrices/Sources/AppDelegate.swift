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
        
        // Setup view controllers
        var viewControllers: Array = [UIViewController]()
        if let newsViewController = UIStoryboard(name: "NewsViewController", bundle: nil).instantiateInitialViewController() {
            viewControllers.append(UINavigationController(rootViewController: newsViewController))
        }
        
        // Setup the tab bar controller
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = viewControllers
        
        // Setup the window
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillTerminate(application: UIApplication) {
        MagicalRecord.cleanUp()
    }

}

