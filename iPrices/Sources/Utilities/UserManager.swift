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
            if newValue != nil {
                UICKeyChainStore.setString(newValue, forKey: Cons.App.deviceToken)
            } else {
                UICKeyChainStore.removeItemForKey(Cons.App.deviceToken)
            }
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
            if newValue != nil {
                UICKeyChainStore.setString(newValue, forKey: Cons.Usr.token)
            } else {
                UICKeyChainStore.removeItemForKey(Cons.Usr.token)
            }
            NSNotificationCenter.defaultCenter().postNotificationName(Cons.Usr.IsLoggedInDidChangeNotification, object: self)
        }
    }
    
    var roleCode: String? {
        get {
            return UICKeyChainStore.stringForKey(Cons.Usr.roleCode)
        }
        set {
            if newValue != nil {
                UICKeyChainStore.setString(newValue, forKey: Cons.Usr.roleCode)
            } else {
                UICKeyChainStore.removeItemForKey(Cons.Usr.roleCode)
            }
        }
    }
    
    var isLoggedIn: Bool {
        return self.token != nil
    }
    
}

// Routines
extension UserManager {
    
    func logIn(token: String, roleCode: String) {
        self.token = token
        self.roleCode = roleCode
    }
    
    func logOut() {
        self.token = nil
        self.roleCode = nil
    }
    
    func checkTokenValidity(validCompletion validCompletion: () -> Void, failCompletion: () -> Void){
        RequestManager.shared.checkToken({(responseObject: AnyObject?) -> () in validCompletion() },
            { (error: NSError?) -> () in
                self.logOut()
                failCompletion()
            }
        )
    }
}