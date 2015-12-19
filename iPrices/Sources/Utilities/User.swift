//
//  User.swift
//  iPrices
//
//  Created by chenglian on 15/12/19.
//  Copyright © 2015年 iPrices. All rights reserved.
//

import Foundation

class User {
    
    // user basic info
    var token: String{
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
    
    var roleCode: String{
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
    
    func setUser(token: String, roleCode: String, roleLabel: String) {
        self.token = token
        self.roleCode = roleCode
        self.roleLabel = roleLabel
    }
    
    func isAuthenticated() () -> Bool {
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
