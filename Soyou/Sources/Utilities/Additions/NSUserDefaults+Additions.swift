//
//  NSUserDefaults+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 20/03/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

import Foundation

class UserDefaults {
    
    class func objectForKey(key: String) -> AnyObject? {
        return NSUserDefaults.standardUserDefaults().objectForKey(key)
    }
    
    class func integerForKey(key: String) -> Int {
        return NSUserDefaults.standardUserDefaults().integerForKey(key)
    }
    
    class func boolForKey(key: String) -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(key)
    }
    
    class func floatForKey(key: String) -> Float {
        return NSUserDefaults.standardUserDefaults().floatForKey(key)
    }
    
    class func stringForKey(key: String) -> String? {
        return NSUserDefaults.standardUserDefaults().stringForKey(key)
    }
    
    class func dataForKey(key: String) -> NSData? {
        return NSUserDefaults.standardUserDefaults().dataForKey(key)
    }
    
    class func arrayForKey(key: String) -> NSArray? {
        return NSUserDefaults.standardUserDefaults().arrayForKey(key)
    }
    
    class func dictionaryForKey(key: String) -> NSDictionary? {
        return NSUserDefaults.standardUserDefaults().dictionaryForKey(key)
    }
    

    //-------------------------------------------------------------------------------------------
    // MARK: - Get value with default value
    //-------------------------------------------------------------------------------------------
    
    class func getObject(key: String, defaultValue: AnyObject) -> AnyObject? {
        if objectForKey(key) == nil {
            return defaultValue
        }
        return objectForKey(key)
    }
    
    class func getInt(key: String, defaultValue: Int) -> Int {
        if objectForKey(key) == nil {
            return defaultValue
        }
        return integerForKey(key)
    }
    
    class func getBool(key: String, defaultValue: Bool) -> Bool {
        if objectForKey(key) == nil {
            return defaultValue
        }
        return boolForKey(key)
    }
    
    class func getFloat(key: String, defaultValue: Float) -> Float {
        if objectForKey(key) == nil {
            return defaultValue
        }
        return floatForKey(key)
    }
    
    class func getString(key: String, defaultValue: String) -> String? {
        if objectForKey(key) == nil {
            return defaultValue
        }
        return stringForKey(key)
    }
    
    class func getData(key: String, defaultValue: NSData) -> NSData? {
        if objectForKey(key) == nil {
            return defaultValue
        }
        return dataForKey(key)
    }
    
    class func getArray(key: String, defaultValue: NSArray) -> NSArray? {
        if objectForKey(key) == nil {
            return defaultValue
        }
        return arrayForKey(key)
    }
    
    class func getDictionary(key: String, defaultValue: NSDictionary) -> NSDictionary? {
        if objectForKey(key) == nil {
            return defaultValue
        }
        return dictionaryForKey(key)
    }
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Set value
    //-------------------------------------------------------------------------------------------
    
    class func setObject(value: AnyObject?, forKey key: String) {
        if value == nil {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        } else {
            NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setInt(value: Int, forKey key: String) {
        NSUserDefaults.standardUserDefaults().setInteger(value, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setBool(value: Bool, forKey key: String) {
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setFloat(value: Float, forKey key: String) {
        NSUserDefaults.standardUserDefaults().setFloat(value, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setString(value: NSString?, forKey key: String) {
        if (value == nil) {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        } else {
            NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
        }
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setData(value: NSData, forKey key: String) {
        setObject(value, forKey: key)
    }
    
    class func setArray(value: NSArray, forKey key: String) {
        setObject(value, forKey: key)
    }
    
    
    class func setDictionary(value: NSDictionary, forKey key: String) {
        setObject(value, forKey: key)
    }
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Synchronize
    //-------------------------------------------------------------------------------------------
    
    class func Sync() {
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}
