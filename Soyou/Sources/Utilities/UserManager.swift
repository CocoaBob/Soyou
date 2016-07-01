//
//  UserManager.swift
//  Soyou
//
//  Created by CocoaBob on 25/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class UserManager: NSObject {
    
    static let shared = UserManager()
    private var currentUser: User?
    
    subscript(key: String) -> AnyObject? {
        get {
            var returnValue: AnyObject?
            MagicalRecord.saveWithBlockAndWait { (localContext) -> Void in
                if let user = self.currentUser?.MR_inContext(localContext) {
                    if (user.entity.attributesByName[key] != nil) {
                        returnValue = user.valueForKey(key)
                    }
                }
            }
            return returnValue
        }
        set(newValue) {
            if self.currentUser == nil {
                self.loadCurrentUser(true)
            }
            MagicalRecord.saveWithBlockAndWait { (localContext) -> Void in
                let localUser = self.currentUser?.MR_inContext(localContext)
                if let user = localUser {
                    if let attDesc = user.entity.attributesByName[key] {
                        if !(newValue is NSNull) {
                            user.setValue(newValue, forKey: key)
                            if key == "username" {
                                Crashlytics.sharedInstance().setUserName(newValue as? String)
                            }
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
        }
    }
}

// Login/Logout
extension UserManager {
    
    func loadCurrentUser(createIfNecessary: Bool) {
        MagicalRecord.saveWithBlockAndWait { (localContext) -> Void in
            self.currentUser = User.MR_findFirstInContext(localContext)
            if createIfNecessary && self.currentUser == nil {
                self.currentUser = User.MR_createEntityInContext(localContext)
            }
        }
    }
    
    func logIn(token: String) {
        self.token = token
        // Load Favorites
        DataManager.shared.requestNewsFavorites(nil)
        DataManager.shared.requestDiscountFavorites(nil)
        DataManager.shared.requestProductFavorites(nil)
        // Update device token to this accout
        DataManager.shared.registerForNotification(true)
    }
    
    func logOut() {
        self.username = nil
        self.matricule = nil
        self.region = nil
        self.gender = nil
        self.avatar = nil
        self.token = nil
        self.currentUser = nil
        // Delete Favorites
        FavoriteNews.deleteAll()
        FavoriteDiscount.deleteAll()
        FavoriteProduct.deleteAll()
    }
    
    var isLoggedIn: Bool {
        return self.token != nil && self.currentUser != nil
    }
}

// Routines
extension UserManager {
    
    func defaultAvatarImage() -> UIImage {
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
    
    var matricule: String? {
        set {
            self["matricule"] = newValue
        }
        get {
            if self.isLoggedIn {
                if let value = self["matricule"] as? NSNumber {
                    if value != "" {
                        return "\(value)"
                    }
                }
            }
            return nil
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
    
    var avatar: String? {
        set {
            self["avatar"] = newValue
        }
        get {
            if let value = self["avatar"] as? String {
                if value != "" {
                    return value
                }
            }
            return nil
        }
    }
    
    func loginOrDo(completion: VoidClosure?) {
        if self.isLoggedIn {
            if let completion = completion { completion() }
        } else {
            let viewController = LoginViewController.instantiate(.Login)
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
        }
    }
}
