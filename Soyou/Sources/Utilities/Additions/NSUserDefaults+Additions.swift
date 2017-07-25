//
//  NSUserDefaults+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 20/03/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

import Foundation

class UserDefaults {
    
    class func objectForKey(_ key: String) -> Any? {
        return Foundation.UserDefaults.standard.object(forKey: key)
    }
    
    class func integerForKey(_ key: String) -> Int {
        return Foundation.UserDefaults.standard.integer(forKey: key)
    }
    
    class func boolForKey(_ key: String) -> Bool {
        return Foundation.UserDefaults.standard.bool(forKey: key)
    }
    
    class func floatForKey(_ key: String) -> Float {
        return Foundation.UserDefaults.standard.float(forKey: key)
    }
    
    class func stringForKey(_ key: String) -> String? {
        return Foundation.UserDefaults.standard.string(forKey: key)
    }
    
    class func dataForKey(_ key: String) -> Data? {
        return Foundation.UserDefaults.standard.data(forKey: key)
    }
    
    class func arrayForKey(_ key: String) -> NSArray? {
        return Foundation.UserDefaults.standard.array(forKey: key) as NSArray?
    }
    
    class func dictionaryForKey(_ key: String) -> NSDictionary? {
        return Foundation.UserDefaults.standard.dictionary(forKey: key) as NSDictionary?
    }
    

    //-------------------------------------------------------------------------------------------
    // MARK: - Get value with default value
    //-------------------------------------------------------------------------------------------
    
    class func getObject(_ key: String, defaultValue: Any) -> Any? {
        if objectForKey(key) == nil {
            return defaultValue
        }
        return objectForKey(key)
    }
    
    class func getInt(_ key: String, defaultValue: Int) -> Int {
        if objectForKey(key) == nil {
            return defaultValue
        }
        return integerForKey(key)
    }
    
    class func getBool(_ key: String, defaultValue: Bool) -> Bool {
        if objectForKey(key) == nil {
            return defaultValue
        }
        return boolForKey(key)
    }
    
    class func getFloat(_ key: String, defaultValue: Float) -> Float {
        if objectForKey(key) == nil {
            return defaultValue
        }
        return floatForKey(key)
    }
    
    class func getString(_ key: String, defaultValue: String) -> String? {
        if objectForKey(key) == nil {
            return defaultValue
        }
        return stringForKey(key)
    }
    
    class func getData(_ key: String, defaultValue: Data) -> Data? {
        if objectForKey(key) == nil {
            return defaultValue
        }
        return dataForKey(key)
    }
    
    class func getArray(_ key: String, defaultValue: NSArray) -> NSArray? {
        if objectForKey(key) == nil {
            return defaultValue
        }
        return arrayForKey(key)
    }
    
    class func getDictionary(_ key: String, defaultValue: NSDictionary) -> NSDictionary? {
        if objectForKey(key) == nil {
            return defaultValue
        }
        return dictionaryForKey(key)
    }
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Set value
    //-------------------------------------------------------------------------------------------
    
    class func setObject(_ value: Any?, forKey key: String) {
        if value == nil {
            Foundation.UserDefaults.standard.removeObject(forKey: key)
        } else {
            Foundation.UserDefaults.standard.set(value, forKey: key)
        }
        Foundation.UserDefaults.standard.synchronize()
    }
    
    class func setInt(_ value: Int, forKey key: String) {
        Foundation.UserDefaults.standard.set(value, forKey: key)
        Foundation.UserDefaults.standard.synchronize()
    }
    
    class func setBool(_ value: Bool, forKey key: String) {
        Foundation.UserDefaults.standard.set(value, forKey: key)
        Foundation.UserDefaults.standard.synchronize()
    }
    
    class func setFloat(_ value: Float, forKey key: String) {
        Foundation.UserDefaults.standard.set(value, forKey: key)
        Foundation.UserDefaults.standard.synchronize()
    }
    
    class func setString(_ value: NSString?, forKey key: String) {
        if (value == nil) {
            Foundation.UserDefaults.standard.removeObject(forKey: key)
        } else {
            Foundation.UserDefaults.standard.set(value, forKey: key)
        }
        Foundation.UserDefaults.standard.synchronize()
    }
    
    class func setData(_ value: Data, forKey key: String) {
        setObject(value, forKey: key)
    }
    
    class func setArray(_ value: NSArray, forKey key: String) {
        setObject(value, forKey: key)
    }
    
    
    class func setDictionary(_ value: NSDictionary, forKey key: String) {
        setObject(value, forKey: key)
    }
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - Synchronize
    //-------------------------------------------------------------------------------------------
    
    class func Sync() {
        Foundation.UserDefaults.standard.synchronize()
    }
}
