//
//  AccountManager.swift
//  iPrices
//
//  Created by CocoaBob on 25/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class AccountManager {
    
    class var uuid: String {
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
    
    class var deviceToken: String? {
        get {
            return UICKeyChainStore.stringForKey(Cons.App.deviceToken)
        }
        set {
            UICKeyChainStore.setString(deviceToken, forKey: Cons.App.deviceToken)
        }
    }
}