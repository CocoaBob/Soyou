//
//  LoginViewController.swift
//  Soyou
//
//  Created by CocoaBob on 16/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

enum LoginType: Int {
    case Login
    case Register
    case ResetPassword
}

class LoginViewController: UIViewController {
    
    private var type: LoginType = .Login
    @IBInspectable var typeAdapter:Int {
        get {
            return self.type.rawValue
        }
        set(type) {
            self.type = LoginType(rawValue: type) ?? .Login
            
            // Update title
            switch self.type {
            case .Login:
                self.title = NSLocalizedString("login_vc_login_title")
            case .Register:
                self.title = NSLocalizedString("login_vc_register_title")
            case .ResetPassword:
                self.title = NSLocalizedString("login_vc_reset_password_title")
            }
        }
    }
    
    @IBOutlet var scrollView: UIScrollView?
    @IBOutlet var tfEmail: NextResponderTextField?
    @IBOutlet var tfPassword: NextResponderTextField?
    @IBOutlet var tfPasswordConfirm: NextResponderTextField?
    @IBOutlet var tfVerificationCode: NextResponderTextField?
    @IBOutlet var btnAction: UIButton?
    @IBOutlet var btnSignUp: UIButton?
    @IBOutlet var btnForgetPassword: UIButton?
    @IBOutlet var btnGetCode: UIButton?
    @IBOutlet var lbl3rdPartyLogins: UILabel?
    
    @IBOutlet var ctlGender: NYSegmentedControl?
    var selectedGender = "\(Cons.Usr.genderSecret)"
    
    var hasSentVerificationCode = false
    
    var lastLoginThirdId: String?
    var lastLoginThirdToken: String?
    
    
    // Class methods
    class func instantiate(type: LoginType) -> LoginViewController {
        switch type {
        case .Login:
            return (UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController)!
        case .Register:
            return (UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewControllerWithIdentifier("RegisterViewController") as? LoginViewController)!
        case .ResetPassword:
            return (UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewControllerWithIdentifier("ResetPasswordViewController") as? LoginViewController)!
        }
    }
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Bars
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Translate UI
        self.tfEmail?.placeholder = NSLocalizedString("login_vc_textfield_placeholder_email")
        self.tfPassword?.placeholder = NSLocalizedString(self.type == .ResetPassword ? "login_vc_textfield_placeholder_new_password" : "login_vc_textfield_placeholder_password")
        self.tfPasswordConfirm?.placeholder = NSLocalizedString("login_vc_textfield_placeholder_confirm_password")
        self.tfVerificationCode?.placeholder = NSLocalizedString("login_vc_textfield_placeholder_verification_code")
        self.lbl3rdPartyLogins?.text = NSLocalizedString("login_vc_3rd_party_logins")
        switch self.type {
        case .Login:
            self.btnAction?.setTitle(NSLocalizedString("login_vc_login_action_button"), forState: .Normal)
            self.btnSignUp?.setTitle(NSLocalizedString("login_vc_register_title"), forState: .Normal)
            self.btnForgetPassword?.setTitle(NSLocalizedString("login_vc_forget_password_title"), forState: .Normal)
        case .Register:
            self.btnAction?.setTitle(NSLocalizedString("login_vc_register_action_button"), forState: .Normal)
        case .ResetPassword:
            self.btnGetCode?.setTitle(NSLocalizedString("login_vc_reset_password_get_code"), forState: .Normal)
            self.btnAction?.setTitle(NSLocalizedString("login_vc_reset_password_action_button"), forState: .Normal)
        }
        
        // Navigation Bar Items
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(UIViewController.dismissSelf))
        
        // One Password Extension
        self.addOnePasswordButton()
        
        // Scroll View Inset
        if let scrollView = self.scrollView {
            self.updateScrollViewInset(scrollView, 0, true, true, false, false)
        }
        
        // Setup NYSegmentedControl
        if let segmentedControl = self.ctlGender {
            segmentedControl.backgroundColor = UIColor.whiteColor()
//            segmentedControl.titleFont = UIFont.systemFontOfSize(15)
            segmentedControl.titleTextColor = UIColor.lightGrayColor()
//            segmentedControl.selectedTitleFont = UIFont.systemFontOfSize(15)
            segmentedControl.selectedTitleTextColor = UIColor.whiteColor()
            segmentedControl.cornerRadius = 5.0
            segmentedControl.borderColor = UIColor(white: 0.75, alpha: 1)
            segmentedControl.borderWidth = 1 / 2.0//(self.view.window?.screen.scale ?? 1)
            segmentedControl.segmentIndicatorInset = segmentedControl.borderWidth + 1
            segmentedControl.drawsSegmentIndicatorGradientBackground = true
            segmentedControl.segmentIndicatorGradientTopColor = UIColor(white: 0.8, alpha: 1)
            segmentedControl.segmentIndicatorGradientBottomColor = UIColor(white: 0.8, alpha: 1)
            segmentedControl.segmentIndicatorBorderColor = UIColor.clearColor()
            segmentedControl.segmentIndicatorBorderWidth = 0
            segmentedControl.usesSpringAnimations = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        
        self.keyboardControlInstall()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.keyboardControlUninstall()
        MBProgressHUD.hide(self.view)
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if let scrollView = self.scrollView {
            self.updateScrollViewInset(scrollView, 0, true, true, false, false)
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        self.keyboardControlRotateWithTransitionCoordinator(coordinator)
    }
}

// MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let nextFirstResponder = (textField as? NextResponderTextField)!.nextFirstResponder {
            nextFirstResponder.becomeFirstResponder()
        }
        
        switch self.type {
        case .Login:
            if textField == tfPassword {
                self.login(nil)
            }
        case .Register:
            if textField == tfPasswordConfirm {
                self.register(nil)
            }
        case .ResetPassword:
            if textField == tfPasswordConfirm {
                self.resetPassword(nil)
            }
        }
        return true
    }
    
}

// MARK: Common
extension LoginViewController {
    
    private func validateActionButton() {
        self.btnAction?.enabled = false
        switch self.type {
        case .Login:
            if let strEmail = tfEmail?.text,
                strPassword = tfPassword?.text {
                self.btnAction?.enabled = (strEmail.isEmail() && !strPassword.isEmpty)
            }
        case .Register:
            if let strEmail = tfEmail?.text,
                strPassword = tfPassword?.text,
                strPasswordConfirm = tfPasswordConfirm?.text {
                self.btnAction?.enabled = (strEmail.isEmail() && !strPassword.isEmpty && strPassword == strPasswordConfirm)
            }
            break
        case .ResetPassword:
            let isEmail = (tfEmail?.text ?? "" ).isEmail()
            self.btnGetCode?.enabled = isEmail && !self.hasSentVerificationCode
            if let strVerificationCode = tfVerificationCode?.text,
                strPassword = tfPassword?.text,
                strPasswordConfirm = tfPasswordConfirm?.text {
                self.btnAction?.enabled = (isEmail && !strVerificationCode.isEmpty && !strPassword.isEmpty && strPassword == strPasswordConfirm)
            }
        }
    }
    
    @IBAction func textFieldDidChange(textField: UITextField?) {
        validateActionButton()
    }
}

// MARK: Login
extension LoginViewController {
    
    @IBAction func login(sender: UIButton?) {
        self.dismissKeyboard()
        
        if let strEmail = tfEmail?.text,
            strPassword = tfPassword?.text {
            // Strat indicator
            MBProgressHUD.show(self.view)
            
            DataManager.shared.login(strEmail, strPassword) { responseObject, error in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    MBProgressHUD.hide(self.view)
                    if let error = error {
                        DataManager.showRequestFailedAlert(error)
                    } else {
                        self.dismissSelf()
                    }
                })
            }
        }
    }
    
    func startLoadingInfoFromThirdLogin() {
        MBProgressHUD.show()
    }
    
    func stopLoadingInfoFromThirdLogin(error: NSError?) {
        MBProgressHUD.hide()
        if let error = error {
            DataManager.showRequestFailedAlert(error)
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.dismissSelf()
            })
        }
    }
    
    @IBAction func loginSinaWeibo(sender: UIButton?) {
        DDSocialAuthHandler.sharedInstance().authWithPlatform(.Sina, controller: self) { (platform, state, result, error) in
            if state == .Success {
                self.startLoadingInfoFromThirdLogin()
                let thirdId = result.thirdId
                let accessToken = result.thirdToken
                let detailRequestURL = "https://api.weibo.com/2/users/show.json?access_token=\(accessToken)&uid=\(thirdId)"
                RequestManager.shared.getAsyncExternal(detailRequestURL, { (responseObject) in
                    guard let responseDict = responseObject as? [String: AnyObject] else {
                        self.stopLoadingInfoFromThirdLogin(FmtError(1, NSLocalizedString("login_vc_login_failed")))
                        return
                    }
                    
                    var username: String?
                    if let value = responseDict["name"] as? String {
                        username = value
                    } else if let value = responseDict["screen_name"] as? String {
                        username = value
                    }
                    var gender: String?
                    if let value = responseDict["gender"] as? String {
                        gender = "\((value == "m") ? Cons.Usr.genderMale : ((value == "f") ? Cons.Usr.genderFemale : Cons.Usr.genderSecret))"
                    }
                    var avatar: String?
                    if let value = responseDict["avatar_large"] as? String {
                        avatar = value
                    }
                    
                    DataManager.shared.loginThird("sinaweibo", accessToken, thirdId, username, gender, { (responseObject, error) in
                        if error == nil {
                            UserManager.shared.avatar = avatar
                        }
                        self.stopLoadingInfoFromThirdLogin(error)
                    })
                }, { (error) in
                    self.stopLoadingInfoFromThirdLogin(error)
                })
            }
        }
    }
    
    @IBAction func loginWechat(sender: UIButton?) {
        DDSocialAuthHandler.sharedInstance().authWithPlatform(.WeChat, controller: self) { (platform, state, result, error) in
            
        }
    }
    
    @IBAction func loginQQ(sender: UIButton?) {
        DDSocialAuthHandler.sharedInstance().authWithPlatform(.QQ, controller: self) { (platform, state, result, error) in
            if state == .Success {
                if let tencentOAuth = result.userInfo as? TencentOAuth {
                    self.startLoadingInfoFromThirdLogin()
                    tencentOAuth.sessionDelegate = self
                    tencentOAuth.getUserInfo()
                    self.lastLoginThirdId = result.thirdId
                    self.lastLoginThirdToken = result.thirdToken
                }
            }
        }
    }
    
    @IBAction func loginFacebook(sender: UIButton?) {
        DDSocialAuthHandler.sharedInstance().authWithPlatform(.Facebook, controller: self) { (platform, state, result, error) in
            if state == .Success {
                self.startLoadingInfoFromThirdLogin()
                let thirdId = result.thirdId
                let accessToken = result.thirdToken
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "email,name,gender,picture.type(large)"]).startWithCompletionHandler({ (connection, result, error) in
                    guard let result = result as? [String: AnyObject] else {
                        self.stopLoadingInfoFromThirdLogin(FmtError(1, NSLocalizedString("login_vc_login_failed")))
                        return
                    }
//                    let email = result["email"]
                    var username: String?
                    if let value = result["name"] as? String {
                        username = value
                    }
                    var gender: String?
                    if let genderString = result["gender"] as? String {
                        gender = "\((genderString == "male") ? Cons.Usr.genderMale : ((genderString == "female") ? Cons.Usr.genderFemale : Cons.Usr.genderSecret))"
                    }
                    var avatar: String?
                    if let value = ((result["picture"] as? [String: AnyObject])?["data"] as? [String: AnyObject])?["url"] as? String {
                        avatar = value
                    }
                    
                    DataManager.shared.loginThird("facebook", accessToken, thirdId, username, gender, { (responseObject, error) in
                        if error == nil {
                            UserManager.shared.avatar = avatar
                        }
                        self.stopLoadingInfoFromThirdLogin(error)
                    })
                })
            }
        }
    }
    
    @IBAction func loginTwitter(sender: UIButton?) {
        DDSocialAuthHandler.sharedInstance().authWithPlatform(.Twitter, controller: self) { (platform, state, result, error) in
            if state == .Success {
                if let session = result.userInfo as? TWTRSession {
                    self.startLoadingInfoFromThirdLogin()
                    let thirdId = result.thirdId
                    let accessToken = result.thirdToken
                    let authTokenSecret = session.authTokenSecret
                    let username = session.userName
                    TWTRAPIClient.clientWithCurrentUser().loadUserWithID(thirdId, completion: { (user: TWTRUser?, error) in
                        if error != nil {
                            self.stopLoadingInfoFromThirdLogin(error)
                        } else {
                            var avatar: String?
                            if let value = user?.profileImageLargeURL {
                                avatar = value
                            }
                            
                            DataManager.shared.loginThird("twitter", accessToken+"|"+authTokenSecret, thirdId, username, nil, { (responseObject, error) in
                                if error == nil {
                                    UserManager.shared.avatar = avatar
                                }
                                self.stopLoadingInfoFromThirdLogin(error)
                            })
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func loginGoogle(sender: UIButton?) {
        DDSocialAuthHandler.sharedInstance().authWithPlatform(.Google, controller: self) { (platform, state, result, error) in
            if state == .Success {
                if let googleUser = result.userInfo as? GIDGoogleUser {
                    self.startLoadingInfoFromThirdLogin()
                    let thirdId = result.thirdId
                    let accessToken = result.thirdToken
                    let username = googleUser.profile.name
                    let detailRequestURL = "https://www.googleapis.com/oauth2/v2/userinfo?access_token="+accessToken
                    RequestManager.shared.getAsyncExternal(detailRequestURL, { (responseObject) in
                        guard let responseObject = responseObject as? [String: AnyObject] else {
                            self.stopLoadingInfoFromThirdLogin(FmtError(1, NSLocalizedString("login_vc_login_failed")))
                            return
                        }
                        DLog(responseObject)
//                        let email = responseObject["email"]
                        let picture = responseObject["picture"] as? String
                        var gender: String?
                        if let genderString = responseObject["gender"] as? String {
                            gender = "\((genderString == "male") ? Cons.Usr.genderMale : ((genderString == "female") ? Cons.Usr.genderFemale : Cons.Usr.genderSecret))"
                        }
                        DataManager.shared.loginThird("google", accessToken, thirdId, username, gender, { (responseObject, error) in
                            if error == nil {
                                UserManager.shared.avatar = picture
                            }
                            self.stopLoadingInfoFromThirdLogin(error)
                        })
                    }, { (error) in
                        self.stopLoadingInfoFromThirdLogin(error)
                    })
                }
            }
        }
    }
}

// MARK: TencentSessionDelegate
extension LoginViewController: TencentSessionDelegate {
    
    func tencentDidLogin() {}
    
    func tencentDidNotLogin(cancelled: Bool) {}
    
    func tencentDidNotNetWork() {}
    
    func getUserInfoResponse(response: APIResponse) {
        if response.retCode == 1 { // URLREQUEST_FAILED
            self.stopLoadingInfoFromThirdLogin(FmtError(1, NSLocalizedString("login_vc_login_failed")))
            return
        }
        guard let accessToken = self.lastLoginThirdToken else {
            self.stopLoadingInfoFromThirdLogin(FmtError(1, NSLocalizedString("login_vc_login_failed")))
            return
        }
        guard let thirdId = self.lastLoginThirdId else {
            self.stopLoadingInfoFromThirdLogin(FmtError(1, NSLocalizedString("login_vc_login_failed")))
            return
        }
        var username: String?
        if let value = response.jsonResponse["nickname"] as? String {
            username = value
        }
        var gender: String?
        if let value = response.jsonResponse["gender"] as? String {
            gender = "\((value == "男") ? Cons.Usr.genderMale : ((value == "女") ? Cons.Usr.genderFemale : Cons.Usr.genderSecret))"
        }
        var avatar: String?
        if let value = response.jsonResponse["figureurl_qq_2"] as? String {
            avatar = value
        }
        
        DataManager.shared.loginThird("qq", accessToken, thirdId, username, gender, { (responseObject, error) in
            if error == nil {
                UserManager.shared.avatar = avatar
            }
            self.stopLoadingInfoFromThirdLogin(error)
        })
    }
}

// MARK: Register
extension LoginViewController {
    
    @IBAction func register(sender: UIButton?) {
        self.dismissKeyboard()
        
        if let strEmail = tfEmail?.text,
            strPassword = tfPassword?.text {
            // Strat indicator
            MBProgressHUD.show(self.view)
            
            // Request
            DataManager.shared.register(strEmail, strPassword, self.selectedGender) { responseObject, error in
                MBProgressHUD.hide(self.view)
                if let error = error {
                    DataManager.showRequestFailedAlert(error)
                } else {
                    // Show alert
                    let alertView = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
                    alertView.addButton(NSLocalizedString("login_vc_register_alert_button")) { () -> Void in
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                    alertView.showSuccess(NSLocalizedString("alert_title_success"), subTitle: NSLocalizedString("login_vc_register_alert_message"))
                }
            }
        }
    }
    
    @IBAction func selectGender(sender: NYSegmentedControl?) {
        if let segmentedControl = sender {
            self.selectedGender = "\(segmentedControl.selectedSegmentIndex + 1)"
        }
    }
}

// MARK: Reset Password
extension LoginViewController {
    
    @IBAction func getCode(sender: UIButton?) {
        self.dismissKeyboard()
        
        if let strEmail = tfEmail?.text {
            // Strat indicator
            MBProgressHUD.show(self.view)
            
            // Request
            DataManager.shared.requestVerifyCode(strEmail) { responseObject, error in
                MBProgressHUD.hide(self.view)
                if let error = error {
                    DataManager.showRequestFailedAlert(error)
                } else {
                    self.hasSentVerificationCode = true
                    self.btnGetCode?.enabled = !self.hasSentVerificationCode
                    let alertView = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: true))
                    alertView.showSuccess(NSLocalizedString("alert_title_info"), subTitle: NSLocalizedString("login_vc_reset_password_get_code_alert_message"))
                }
            }
        }
    }
    
    @IBAction func resetPassword(sender: UIButton?) {
        self.dismissKeyboard()
        
        if let strVerificationCode = tfVerificationCode?.text,
            strPassword = tfPassword?.text {
            // Strat indicator
            MBProgressHUD.show(self.view)
            
            // Request
            DataManager.shared.resetPassword(strVerificationCode, strPassword) { responseObject, error in
                MBProgressHUD.hide(self.view)
                if let error = error {
                    DataManager.showRequestFailedAlert(error)
                } else {
                    self.dismissSelf()
                    DispatchAfter(0.3, closure: {
                        let alertView = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
                        alertView.showSuccess(NSLocalizedString("alert_title_success"), subTitle: NSLocalizedString("login_vc_reset_password_alert_message"), closeButtonTitle: NSLocalizedString("alert_button_ok"), duration: 3)
                    })
                }
            }
        }
    }
}

// MARK: KeyboardControl
extension LoginViewController {
    
    override func adjustViewsForKeyboardFrame(keyboardFrame: CGRect, _ isAnimated: Bool, _ duration: NSTimeInterval, _ options: UIViewAnimationOptions) {
        super.adjustViewsForKeyboardFrame(keyboardFrame, isAnimated, duration, options)
        if let scrollView = self.scrollView {
            self.updateScrollViewInset(scrollView, 0, true, true, false, false)
        }
    }
}

// MARK: NYSegmentedControlDataSource
extension LoginViewController: NYSegmentedControlDataSource {
    
    func numberOfSegmentsOfControl(control: NYSegmentedControl!) -> UInt {
        return 3
    }
    
    func segmentedControl(control: NYSegmentedControl!, titleAtIndex index: Int) -> String! {
        if index == Cons.Usr.genderSecretIndex {
            return NSLocalizedString("user_info_gender_secret")
        } else if index == Cons.Usr.genderMaleIndex {
            return NSLocalizedString("user_info_gender_male")
        } else if index == Cons.Usr.genderFemaleIndex {
            return NSLocalizedString("user_info_gender_female")
        }
        return ""
    }
}

// MARK: 1Password
extension LoginViewController {
    
    func addOnePasswordButton() {
        if OnePasswordExtension.sharedExtension().isAppExtensionAvailable() {
            let opImage = UIImage(named: "onepassword-navbar")
            switch self.type {
            case .Login:
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: opImage, style: .Plain, target: self, action: #selector(LoginViewController.findLoginFrom1Password(_:)))
            case .Register:
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: opImage, style: .Plain, target: self, action: #selector(LoginViewController.saveLoginTo1Password(_:)))
            case .ResetPassword:
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: opImage, style: .Plain, target: self, action: #selector(LoginViewController.changePasswordIn1Password(_:)))
            }
        }
    }
    
    func findLoginFrom1Password(sender: AnyObject?) {
        OnePasswordExtension.sharedExtension().findLoginForURLString("soyou.io", forViewController: self, sender: sender) { loginDictionary, error in
            self.tfEmail?.text = loginDictionary?[AppExtensionUsernameKey] as? String
            self.tfPassword?.text = loginDictionary?[AppExtensionPasswordKey] as? String
            self.validateActionButton()
        }
    }
    
    func saveLoginTo1Password(sender: AnyObject?) {
        OnePasswordExtension.sharedExtension().storeLoginForURLString("soyou.io", loginDetails: nil, passwordGenerationOptions: nil, forViewController: self, sender: sender) { loginDictionary, error in
            self.tfEmail?.text = loginDictionary?[AppExtensionUsernameKey] as? String
            self.tfPassword?.text = loginDictionary?[AppExtensionPasswordKey] as? String
            self.tfPasswordConfirm?.text = loginDictionary?[AppExtensionPasswordKey] as? String
            self.validateActionButton()
        }
    }
    
    func changePasswordIn1Password(sender: AnyObject?) {
        OnePasswordExtension.sharedExtension().changePasswordForLoginForURLString("soyou.io", loginDetails: nil, passwordGenerationOptions: nil, forViewController: self, sender: sender) { loginDictionary, error in
            self.tfEmail?.text = loginDictionary?[AppExtensionUsernameKey] as? String
            self.tfPassword?.text = loginDictionary?[AppExtensionPasswordKey] as? String
            self.tfPasswordConfirm?.text = loginDictionary?[AppExtensionPasswordKey] as? String
            self.validateActionButton()
        }
    }
}
