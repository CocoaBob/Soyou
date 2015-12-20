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
    
    var token: String {
        get {
            if let value = UICKeyChainStore.stringForKey(Cons.Usr.token) {
                return value
            } else {
                return ""
            }
        }
        set {
            UICKeyChainStore.setString(newValue, forKey: Cons.Usr.token)
        }
    }
    
    var roleCode: String {
        get {
            if let value = UICKeyChainStore.stringForKey(Cons.Usr.roleCode) {
                return value
            } else {
                return ""
            }
        }
        set {
            UICKeyChainStore.setString(newValue, forKey: Cons.Usr.roleCode)
        }
    }
    
    var roleLabel: String {
        get {
            if let value = UICKeyChainStore.stringForKey(Cons.Usr.roleLabel) {
                return value
            } else {
                return ""
            }
        }
        set {
            UICKeyChainStore.setString(newValue, forKey: Cons.Usr.roleLabel)
        }
    }
    
}

// Routines
extension UserManager {
    
    func setUser(token: String, roleCode: String, roleLabel: String) {
        self.token = token
        self.roleCode = roleCode
        self.roleLabel = roleLabel
    }
    
    func isAuthenticated() -> Bool {
        return self.token != ""
    }
    
    func checkTokenValidity(validCompletion: () -> Void, failCompletion: () -> Void){
        ServerManager.shared.checkToken({(responseObject: AnyObject?) -> () in validCompletion() },
            { (error: NSError?) -> () in
                self.token = ""
                self.roleCode = ""
                self.roleLabel = ""
                failCompletion()})
    }
}