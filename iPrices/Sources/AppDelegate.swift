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
        
        return true
    }

    func applicationWillTerminate(application: UIApplication) {
        MagicalRecord.cleanUp()
    }

}

