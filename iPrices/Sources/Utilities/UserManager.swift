//
//  UserManager.swift
//  iPrices
//
//  Created by CocoaBob on 25/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

enum UserAttribute: String {
    case Username   = "username"
    case Gender     = "gender"
    case Matricule  = "matricule"
    case RoleCode   = "roleCode"
    case Region     = "region"
}

class UserManager {
    
    static let shared = UserManager()
    
    subscript(key: String) -> AnyObject? {
        get {
            var returnValue: AnyObject?
            MagicalRecord.saveWithBlockAndWait { (localContext) -> Void in
                if let user = User.MR_findFirstInContext(localContext) {
                    if (user.entity.attributesByName[key] != nil) {
                        returnValue = user.valueForKey(key)
                    }
                }
            }
            return returnValue
        }
        set(newValue) {
            MagicalRecord.saveWithBlockAndWait { (localContext) -> Void in
                var user = User.MR_findFirstInContext(localContext)
                if user == nil {
                    user = User.MR_createEntityInContext(localContext)
                }
                if (user?.entity.attributesByName[key] != nil) {
                    if let user = user {
                        user.setValue(newValue, forKey: key)
                    }
                }
            }
        }
    }
}

// Confidential data
extension UserManager {
    
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
    
    // User authenticated token
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
}

// Login/Logout
extension UserManager {
    
    func logIn(token: String) {
        self.token = token
    }
    
    func logOut() {
        self.token = nil
    }
    
    var isLoggedIn: Bool {
        return self.token != nil
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

// Routines
extension UserManager {
    
    func avatarImage() -> UIImage {
        if self.isLoggedIn {
            if let gender = self["gender"] as? NSNumber {
                return UIImage(named: (gender == 1) ? "img_avatar_neutral" : ((gender == 2) ? "img_avatar_male" : "img_avatar_female"))!
            }
        }
        return UIImage(named: "img_avatar_neutral")!
    }
    
    func userName() -> String? {
        return self.isLoggedIn ? (self[UserAttribute.Username.rawValue] as? String ?? "") : nil
    }
}