//
//  UserManager.swift
//  Soyou
//
//  Created by CocoaBob on 25/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

@objcMembers
class UserManager: NSObject {
    
    static let shared = UserManager()
    fileprivate var currentUser: User? {
        didSet {
            self.willChangeValue(for: \.isLoggedIn)
            self.didChangeValue(for: \.isLoggedIn)
        }
    }
    var hasCurrentUserBadges = false
    
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
            if let value = UserDefaults.stringForKey(Cons.Usr.uuid) {
                return value
            } else {
                let value = FCUUID.uuid()
                UserDefaults.setObject(value, forKey: Cons.Usr.uuid)
                return value!
            }
        }
        set {
            UserDefaults.setObject(newValue, forKey: Cons.Usr.uuid)
            RequestManager.shared.requestOperationManager.uuid = newValue
        }
    }
    
    // User authenticated token
    var token: String? {
        get {
            return UserDefaults.stringForKey(Cons.Usr.token)
        }
        set {
            self.willChangeValue(for: \.isLoggedIn)
            UserDefaults.setObject(newValue, forKey: Cons.Usr.token)
            self.didChangeValue(for: \.isLoggedIn)
        }
    }
    
    // Rocket Chat User Id
    var imUserId: String? {
        get {
            return UserDefaults.stringForKey(Cons.Usr.imUserId)
        }
        set {
            self.willChangeValue(for: \.isLoggedIn)
            UserDefaults.setObject(newValue, forKey: Cons.Usr.imUserId)
            self.didChangeValue(for: \.isLoggedIn)
        }
    }
    
    // Rocket Chat token
    var imAuthToken: String? {
        get {
            return UserDefaults.stringForKey(Cons.Usr.imAuthToken)
        }
        set {
            self.willChangeValue(for: \.isLoggedIn)
            UserDefaults.setObject(newValue, forKey: Cons.Usr.imAuthToken)
            self.didChangeValue(for: \.isLoggedIn)
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
    
    func userDidLogIn(_ token: String) {
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
        self.currentUser = nil
        self.avatar = nil
        self.token = nil
        
        // Delete Favorites
        FavoriteNews.deleteAll()
        FavoriteDiscount.deleteAll()
        FavoriteProduct.deleteAll()
        Circle.deleteAll()
        
        // RocketChat
        if self.imUserId != nil || self.imAuthToken != nil {
            self.imUserId = nil
            self.imAuthToken = nil
            RocketChatManager.signOut()
        }
    }
    
    var isLoggedIn: Bool {
        return self.token != nil && self.currentUser != nil && self.imUserId != nil && self.imAuthToken != nil
    }
}

// RocketChat
extension UserManager {
    
    func signInRocketChat(_ completion: (()->())?) {
        guard let imUserId = self.imUserId, let imAuthToken = self.imAuthToken else {
            completion?()
            return
        }
        let server = Utils.isSTGMode() ? Cons.Svr.rocketChatServerSTG : Cons.Svr.rocketChatServerPROD
        RocketChatManager.signIn(socketServerAddress: server, userId: imUserId, token: imAuthToken, completion: completion)
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
            // Setup Navigation Controller
            let navC = UINavigationController(rootViewController: vc)
            navC.modalPresentationStyle = .custom
            navC.modalPresentationCapturesStatusBarAppearance = true
            // Setup Transition Animator
            vc.loadViewIfNeeded()
            vc.setupTransitionAnimator(modalVC: vc)
            navC.transitioningDelegate = vc.transitionAnimator
            // Present
            if !UIView.areAnimationsEnabled {
                UIView.setAnimationsEnabled(true)
            }
            UIApplication.shared.keyWindow?.rootViewController?.present(navC, animated: true, completion: nil)
        }
    }
}

// GDPR
extension UserManager {
    
    // User authenticated token
    var isGDPRAccepted: Bool {
        get {
            return UserDefaults.boolForKey(Cons.Usr.isGDPRAccepted)
        }
        set {
            UserDefaults.setObject(newValue, forKey: Cons.Usr.isGDPRAccepted)
        }
    }
    
    func checkGDPR() {
        if let userID = self.userID {
            DataManager.shared.getUserInfo(userID) { response, error in
                if let response = response as? Dictionary<String, AnyObject>,
                    let data = response["data"] as? [String: AnyObject] {
                    // If it's the current user, check if GDPR is accepted
                    if data["isGDPRAccepted"] is NSNull {
                        UserManager.shared.askGDPRQuestion() { isAccepted in
                            if isAccepted {
                                Fabric.with([Crashlytics.self])
                                Crashlytics.sharedInstance().setUserIdentifier(UIDevice.current.identifierForVendor?.uuidString)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func askGDPRQuestion(_ completion: ((Bool)->())?) {
        UIAlertController.presentAlert(message: NSLocalizedString("gdpr_question"),
                                       UIAlertAction(title: NSLocalizedString("alert_button_ok"),
                                                     style: UIAlertActionStyle.default,
                                                     handler: { (action: UIAlertAction) -> Void in
                                                        DataManager.shared.setGDPR(true, nil)
                                                        UserManager.shared.isGDPRAccepted = true
                                                        completion?(true)
                                       }))
    }
}
