//
//  UserManager.swift
//  Soyou
//
//  Created by CocoaBob on 25/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class UserManager: NSObject {
    
    static let shared = UserManager()
    fileprivate var currentUser: User?
    
    subscript(key: String) -> Any? {
        get {
            var returnValue: Any?
            MagicalRecord.save(blockAndWait: { (localContext) in
                if let user = self.currentUser?.mr_(in: localContext) {
                    if (user.entity.attributesByName[key] != nil) {
                        returnValue = user.value(forKey: key)
                    }
                }
            })
            return returnValue
        }
        set(newValue) {
            if self.currentUser == nil {
                self.loadCurrentUser(true)
            }
            MagicalRecord.save(blockAndWait: { (localContext) in
                let localUser = self.currentUser?.mr_(in: localContext)
                if let user = localUser {
                    if let attDesc = user.entity.attributesByName[key] {
                        if !(newValue is NSNull) {
                            user.setValue(newValue, forKey: key)
                            if key == "username" {
                                Crashlytics.sharedInstance().setUserName(newValue as? String)
                            }
                        } else {
                            if attDesc.attributeType == .stringAttributeType {
                                user.setValue("", forKey: key)
                            } else if attDesc.attributeType == .integer32AttributeType {
                                user.setValue(0, forKey: key)
                            }
                        }
                    }
                }
            })
        }
    }
}

// Confidential data
extension UserManager {
    
    // Device Info
    var deviceToken: String? {
        get {
            return UICKeyChainStore.string(forKey: Cons.App.deviceToken)
        }
        set {
            if newValue != nil {
                UICKeyChainStore.setString(newValue, forKey: Cons.App.deviceToken)
            } else {
                UICKeyChainStore.removeItem(forKey: Cons.App.deviceToken)
            }
        }
    }
    
    var uuid: String {
        get {
            if let value = UICKeyChainStore.string(forKey: Cons.Usr.uuid) {
                return value
            } else {
                let value = FCUUID.uuid()
                UICKeyChainStore.setString(value, forKey: Cons.Usr.uuid)
                return value!
            }
        }
        set {
            UICKeyChainStore.setString(newValue, forKey: Cons.Usr.uuid)
            RequestManager.shared.requestOperationManager.uuid = newValue
        }
    }
    
    // User authenticated token
    var token: String? {
        get {
            return UICKeyChainStore.string(forKey: Cons.Usr.token)
        }
        set {
            if newValue != nil {
                UICKeyChainStore.setString(newValue, forKey: Cons.Usr.token)
            } else {
                UICKeyChainStore.removeItem(forKey: Cons.Usr.token)
            }
        }
    }
}

// Login/Logout
extension UserManager {
    
    func loadCurrentUser(_ createIfNecessary: Bool) {
        MagicalRecord.save(blockAndWait: { (localContext) in
            self.currentUser = User.mr_findFirst(in: localContext)
            if createIfNecessary && self.currentUser == nil {
                self.currentUser = User.mr_createEntity(in: localContext)
            }
        })
    }
    
    func logIn(_ token: String) {
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
        Circle.deleteAll()
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
    
    var userID: Int? {
        set {
            self["id"] = newValue
        }
        get {
            return self["id"] as? Int
        }
    }
    
    var matricule: Int? {
        set {
            self["matricule"] = newValue
        }
        get {
            if self.isLoggedIn {
                if let value = self["matricule"] as? Int {
                    return value
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
    
    var isWeChatUser: Bool {
        get {
            guard let thirds = self["thirds"] as? [[String: Any]] else {
                return false
            }
            for dict in thirds {
                if dict["type"] as? String ?? "" == "wx" {
                    return true
                }
            }
            return false
        }
    }
    
    func loginOrDo(_ completion: VoidClosure?) {
        if self.isLoggedIn {
            completion?()
        } else {
            let vc = LoginViewController.instantiate(.login)
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .custom
            // Setup Transition Animator
            vc.loadViewIfNeeded()
            vc.setupTransitionAnimator(modalVC: nav)
            nav.transitioningDelegate = vc.transitionAnimator
            // Present
            UIApplication.shared.keyWindow?.rootViewController?.present(nav, animated: true, completion: nil)
        }
    }
}
