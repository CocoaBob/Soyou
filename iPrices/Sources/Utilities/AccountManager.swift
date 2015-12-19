//
//  AccountManager.swift
//  iPrices
//
//  Created by CocoaBob on 25/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class AccountManager {
    static let shared = AccountManager()
    
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
    
    var deviceToken: String? {
        get {
            return UICKeyChainStore.stringForKey(Cons.App.deviceToken)
        }
        set {
            UICKeyChainStore.setString(deviceToken, forKey: Cons.App.deviceToken)
        }
    }
    
    var currentUser = User()
    
}