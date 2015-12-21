//
//  UserManager.swift
//  iPrices
//
//  Created by CocoaBob on 25/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class UserManager {
    static let shared = UserManager()
    
    // Device Info
    var deviceToken: String? {
        get {
            return UICKeyChainStore.stringForKey(Cons.App.deviceToken)
        }
        set {
            UICKeyChainStore.setString(newValue, forKey: Cons.App.deviceToken)
        }
    }
    
    // User info
    var uuid: String {
        get {
            if let value = UICKeyChainStore.stringForKey(Cons.Usr.uuid) {
                return value
            } else {
                let value = FCUUID.uuid()
                UICKeyChainStore.setString(value, forKey: Cons.Usr.uuid)
                return value
            }
        }
        set {
            UICKeyChainStore.setString(newValue, forKey: Cons.Usr.uuid)
        }
    }
    
    var token: String? {
        get {
            return UICKeyChainStore.stringForKey(Cons.Usr.token)
        }
        set {
            UICKeyChainStore.setString(newValue, forKey: Cons.Usr.token)
            NSNotificationCenter.defaultCenter().postNotificationName(Cons.Usr.IsLoggedInDidChangeNotification, object: nil)
        }
    }
    
    var roleCode: String? {
        get {
            return UICKeyChainStore.stringForKey(Cons.Usr.roleCode)
        }
        set {
            UICKeyChainStore.setString(newValue, forKey: Cons.Usr.roleCode)
        }
    }
    
    var roleLabel: String? {
        get {
            return UICKeyChainStore.stringForKey(Cons.Usr.roleLabel)
        }
        set {
            UICKeyChainStore.setString(newValue, forKey: Cons.Usr.roleLabel)
        }
    }
    
    var isLoggedIn: Bool {
        return self.token != nil
    }
    
}

// Routines
extension UserManager {
    
    func setUser(token: String, roleCode: String, roleLabel: String) {
        self.token = token
        self.roleCode = roleCode
        self.roleLabel = roleLabel
    }
    
    func checkTokenValidity(validCompletion: () -> Void, failCompletion: () -> Void){
        ServerManager.shared.checkToken({(responseObject: AnyObject?) -> () in validCompletion() },
            { (error: NSError?) -> () in
                self.token = nil
                self.roleCode = nil
                self.roleLabel = nil
                failCompletion()
            }
        )
    }
}