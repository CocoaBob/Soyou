//
//  UserManager.swift
//  Soyou
//
//  Created by CocoaBob on 25/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

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
                if let attDesc = user?.entity.attributesByName[key] {
                    if let user = user {
                        if !(newValue is NSNull) {
                            user.setValue(newValue, forKey: key)
                        } else {
                            if attDesc.attributeType == .StringAttributeType {
                                user.setValue("", forKey: key)
                            } else if attDesc.attributeType == .Integer32AttributeType {
                                user.setValue(0, forKey: key)
                            }
                        }
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
        // Load Favorites
        DataManager.shared.requestNewsFavorites(nil)
        DataManager.shared.requestProductFavorites(nil)
    }
    
    func logOut() {
        self.token = nil
        // Delete Favorites
        FavoriteNews.deleteAll()
        FavoriteProduct.deleteAll()
    }
    
    var isLoggedIn: Bool {
        return self.token != nil && User.MR_findFirst() != nil
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
    
    var username: String? {
        set {
            self["username"] = newValue
        }
        get {
            if self.isLoggedIn {
                if let value = self["username"] as? String {
                    if value != "" {
                        return value
                    }
                }
                return nil
            } else {
                return NSLocalizedString("user_vc_login")
            }
        }
    }
    
    var region: String? {
        set {
            self["region"] = newValue
        }
        get {
            if let value = self["region"] as? String {
                if value != "" {
                    return value
                }
            }
            return nil
        }
    }
    
    
    var gender: String? {
        set {
            self["gender"] = newValue
        }
        get {
            if let gender = self["gender"] as? String {
                if gender == "2" {
                    return NSLocalizedString("user_info_gender_male")
                } else if gender == "3" {
                    return NSLocalizedString("user_info_gender_female")
                }
            }
            return NSLocalizedString("user_info_gender_secret")
        }
    }
    
    var genderIndex: Int {
        get {
            if let gender = self["gender"] as? String {
                return (Int(gender) ?? 1) - 1
            }
            return 0
        }
    }
    
    func loginOrDo(completion: VoidClosure?) {
        if self.isLoggedIn {
            if let completion = completion { completion() }
        } else {
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(UINavigationController(rootViewController: LoginViewController.instantiate(.Login)), animated: true, completion: nil)
        }
    }
}