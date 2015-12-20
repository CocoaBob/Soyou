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
            UICKeyChainStore.setString(deviceToken, forKey: Cons.App.deviceToken)
        }
    }
    
    // User info
    var uuid: String {
        get {
            if let strUUID = UICKeyChainStore.stringForKey(Cons.Usr.uuid) {
                return strUUID
            } else {
                let strUUID = FCUUID.uuid()
                UICKeyChainStore.setString(strUUID, forKey: Cons.Usr.uuid)
                return strUUID
            }
        }
        set {
            UICKeyChainStore.setString(uuid, forKey: Cons.Usr.uuid)
        }
    }
    
    var token: String {
        get {
            if let token = UICKeyChainStore.stringForKey(Cons.Usr.token) {
                return token
            } else {
                return ""
            }
        }
        set {
            UICKeyChainStore.setString(token, forKey: Cons.Usr.token)
        }
    }
    
    var roleCode: String {
        get {
            if let token = UICKeyChainStore.stringForKey(Cons.Usr.roleCode) {
                return token
            } else {
                return ""
            }
        }
        set {
            UICKeyChainStore.setString(token, forKey: Cons.Usr.roleCode)
        }
    }
    
    var roleLabel: String {
        get {
            if let token = UICKeyChainStore.stringForKey(Cons.Usr.roleLabel) {
                return token
            } else {
                return ""
            }
        }
        set {
            UICKeyChainStore.setString(token, forKey: Cons.Usr.roleLabel)
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
        return token != ""
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