//
//  LoginViewController.swift
//  Soyou
//
//  Created by CocoaBob on 16/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

enum LoginType: Int {
    case login
    case register
    case resetPassword
}

class LoginViewController: UIViewController {
    
    fileprivate var type: LoginType = .login
    @IBInspectable var typeAdapter:Int {
        get {
            return self.type.rawValue
        }
        set(type) {
            self.type = LoginType(rawValue: type) ?? .login
            
            // Update title
            switch self.type {
            case .login:
                self.title = NSLocalizedString("login_vc_login_title")
            case .register:
                self.title = NSLocalizedString("login_vc_register_title")
            case .resetPassword:
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
    @IBOutlet var stack3rdPartyLogins: UIStackView?
    @IBOutlet var btnWeChat: UIButton!
    @IBOutlet var btnWeibo: UIButton!
    @IBOutlet var btnQQ: UIButton!
    @IBOutlet var btnFacebook: UIButton!
    @IBOutlet var btnTwitter: UIButton!
    @IBOutlet var btnGoogle: UIButton!
    
    @IBOutlet var ctlGender: NYSegmentedControl?
    var selectedGender = "\(Cons.Usr.genderSecret)"
    
    var hasSentVerificationCode = false
    
    var lastLoginThirdId: String?
    var lastLoginThirdToken: String?
    
    // Notification Context
    fileprivate var KVOContextLoginViewController = 0
    
    // ZFModalTransitionAnimator
    var transitionAnimator: ZFModalTransitionAnimator?
    
    // Class methods
    class func instantiate(_ type: LoginType) -> LoginViewController {
        switch type {
        case .login:
            return (UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController)!
        case .register:
            return (UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewController(withIdentifier: "RegisterViewController") as? LoginViewController)!
        case .resetPassword:
            return (UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewController(withIdentifier: "ResetPasswordViewController") as? LoginViewController)!
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
        
        // Setup 3rd party login buttons
        self.stack3rdPartyLogins?.addArrangedSubview(self.btnWeChat)
        self.stack3rdPartyLogins?.addArrangedSubview(self.btnWeibo)
        if DDTencentHandler.isInstalled() {
            self.stack3rdPartyLogins?.addArrangedSubview(self.btnQQ)
        }
        self.stack3rdPartyLogins?.addArrangedSubview(self.btnFacebook)
        self.stack3rdPartyLogins?.addArrangedSubview(self.btnTwitter)
        self.stack3rdPartyLogins?.addArrangedSubview(self.btnGoogle)
        self.stack3rdPartyLogins?.setNeedsLayout()
        self.stack3rdPartyLogins?.layoutIfNeeded()
        
        // Translate UI
        self.tfEmail?.placeholder = NSLocalizedString("login_vc_textfield_placeholder_email")
        self.tfPassword?.placeholder = NSLocalizedString(self.type == .resetPassword ? "login_vc_textfield_placeholder_new_password" : "login_vc_textfield_placeholder_password")
        self.tfPasswordConfirm?.placeholder = NSLocalizedString("login_vc_textfield_placeholder_confirm_password")
        self.tfVerificationCode?.placeholder = NSLocalizedString("login_vc_textfield_placeholder_verification_code")
        self.lbl3rdPartyLogins?.text = NSLocalizedString("login_vc_3rd_party_logins")
        switch self.type {
        case .login:
            self.btnAction?.setTitle(NSLocalizedString("login_vc_login_action_button"), for: .normal)
            self.btnSignUp?.setTitle(NSLocalizedString("login_vc_register_title"), for: .normal)
            self.btnForgetPassword?.setTitle(NSLocalizedString("login_vc_forget_password_title"), for: .normal)
        case .register:
            self.btnAction?.setTitle(NSLocalizedString("login_vc_register_action_button"), for: .normal)
        case .resetPassword:
            self.btnGetCode?.setTitle(NSLocalizedString("login_vc_reset_password_get_code"), for: .normal)
            self.btnAction?.setTitle(NSLocalizedString("login_vc_reset_password_action_button"), for: .normal)
        }
        
        // Navigation Bar Items
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(UIViewController.dismissSelf))
        
        // One Password Extension
        self.addOnePasswordButton()
        
        // Scroll View Inset
        if let scrollView = self.scrollView {
            self.updateScrollViewInset(scrollView, 0, true, true, false, false)
        }
        
        // Setup NYSegmentedControl
        if let segmentedControl = self.ctlGender {
            segmentedControl.backgroundColor = UIColor.white
//            segmentedControl.titleFont = UIFont.systemFont(ofSize: 15)
            segmentedControl.titleTextColor = UIColor.lightGray
//            segmentedControl.selectedTitleFont = UIFont.systemFont(ofSize: 15)
            segmentedControl.selectedTitleTextColor = UIColor.white
            segmentedControl.cornerRadius = 5.0
            segmentedControl.borderColor = UIColor(white: 0.75, alpha: 1)
            segmentedControl.borderWidth = 1 / 2.0//(self.view.window?.screen.scale ?? 1)
            segmentedControl.segmentIndicatorInset = CGFloat(segmentedControl.borderWidth + 1)
            segmentedControl.drawsSegmentIndicatorGradientBackground = true
            segmentedControl.segmentIndicatorGradientTopColor = UIColor(white: 0.8, alpha: 1)
            segmentedControl.segmentIndicatorGradientBottomColor = UIColor(white: 0.8, alpha: 1)
            segmentedControl.segmentIndicatorBorderColor = UIColor.clear
            segmentedControl.segmentIndicatorBorderWidth = 0
            segmentedControl.usesSpringAnimations = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        
        self.keyboardControlInstall()
        
        if #available(iOS 11.0, *) {
            self.scrollView?.setContentOffset(CGPoint(x: 0, y: -(self.scrollView?.adjustedContentInset.top ?? 0)), animated: true)
        } else {
            self.scrollView?.setContentOffset(CGPoint(x: 0, y: -(self.scrollView?.contentInset.top ?? 0)), animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Observing token to aotumatically dismiss
        UserManager.shared.addObserver(self, forKeyPath: "token", options: .new, context: &KVOContextLoginViewController)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.keyboardControlUninstall()
        MBProgressHUD.hide(self.view)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Stop observing
        UserManager.shared.removeObserver(self, forKeyPath: "token")
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if let scrollView = self.scrollView {
            self.updateScrollViewInset(scrollView, 0, true, true, false, false)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.keyboardControlRotateWithTransitionCoordinator(coordinator)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &KVOContextLoginViewController {
            if UserManager.shared.isLoggedIn {
                self.dismissSelf()
            }
        }
    }
}

// MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextFirstResponder = (textField as? NextResponderTextField)!.nextFirstResponder {
            nextFirstResponder.becomeFirstResponder()
        }
        
        switch self.type {
        case .login:
            if textField == tfPassword {
                self.login(nil)
            }
        case .register:
            if textField == tfPasswordConfirm {
                self.register(nil)
            }
        case .resetPassword:
            if textField == tfPasswordConfirm {
                self.resetPassword(nil)
            }
        }
        return true
    }
    
}

// MARK: Common
extension LoginViewController {
    
    fileprivate func validateActionButton() {
        self.btnAction?.isEnabled = false
        switch self.type {
        case .login:
            if let strEmail = tfEmail?.text,
                let strPassword = tfPassword?.text {
                self.btnAction?.isEnabled = (strEmail.isEmail() && !strPassword.isEmpty)
            }
        case .register:
            if let strEmail = tfEmail?.text,
                let strPassword = tfPassword?.text,
                let strPasswordConfirm = tfPasswordConfirm?.text {
                self.btnAction?.isEnabled = (strEmail.isEmail() && !strPassword.isEmpty && strPassword == strPasswordConfirm)
            }
            break
        case .resetPassword:
            let isEmail = (tfEmail?.text ?? "" ).isEmail()
            self.btnGetCode?.isEnabled = isEmail && !self.hasSentVerificationCode
            if let strVerificationCode = tfVerificationCode?.text,
                let strPassword = tfPassword?.text,
                let strPasswordConfirm = tfPasswordConfirm?.text {
                self.btnAction?.isEnabled = (isEmail && !strVerificationCode.isEmpty && !strPassword.isEmpty && strPassword == strPasswordConfirm)
            }
        }
    }
    
    @IBAction func textFieldDidChange(_ textField: UITextField?) {
        validateActionButton()
    }
}

// MARK: Login
extension LoginViewController {
    
    @IBAction func login(_ sender: UIButton?) {
        self.dismissKeyboard()
        
        if let strEmail = tfEmail?.text,
            let strPassword = tfPassword?.text {
            // Strat indicator
            MBProgressHUD.show(self.view)
            
            DataManager.shared.login(strEmail, strPassword) { responseObject, error in
                DispatchQueue.main.async {
                    MBProgressHUD.hide(self.view)
                    if let error = error {
                        DataManager.showRequestFailedAlert(error)
                    } else {
                        self.dismissSelf()
                    }
                }
            }
        }
    }
    
    func startLoadingInfoFromThirdLogin() {
        MBProgressHUD.show()
    }
    
    func stopLoadingInfoFromThirdLogin(_ error: Error?) {
        MBProgressHUD.hide()
        if let error = error {
            DataManager.showRequestFailedAlert(error)
        } else {
            DispatchQueue.main.async {
                self.dismissSelf()
            }
        }
    }
    
    @IBAction func loginSinaWeibo(_ sender: UIButton?) {
        DDSocialAuthHandler.sharedInstance().auth(with: .sina, controller: self) { (platform, state, result, error) in
            if state == .success {
                self.startLoadingInfoFromThirdLogin()
                let thirdId = result?.thirdId ?? ""
                let accessToken = result?.thirdToken ?? ""
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
                    
                    DataManager.shared.loginThird("sinaweibo", accessToken, thirdId, username, avatar, gender, { (responseObject, error, profileURL) in
                        if error == nil {
                            UserManager.shared.avatar = profileURL ?? avatar
                        }
                        self.stopLoadingInfoFromThirdLogin(error)
                    })
                }, { (error) in
                    self.stopLoadingInfoFromThirdLogin(error)
                })
            }
        }
    }
    
    @IBAction func loginWechat(_ sender: UIButton?) {
        DDSocialAuthHandler.sharedInstance().auth(with: .weChat, controller: self) { (platform, state, result, error) in
            if state == .success {
                self.startLoadingInfoFromThirdLogin()
                let code = result?.thirdToken ?? ""
                let tokenURL = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=wxe3346afe30577009&secret=485df03e708c879eea75686ce3432ab0&code=\(code)&grant_type=authorization_code"
                RequestManager.shared.getAsyncExternal(tokenURL, { (responseObject) in
                    guard let responseDict = responseObject as? [String: AnyObject] else {
                        self.stopLoadingInfoFromThirdLogin(FmtError(1, NSLocalizedString("login_vc_login_failed")))
                        return
                    }
                    
//                    let refresh_token = (responseDict["refresh_token"] as? String) ?? ""
                    let unionId = (responseDict["unionid"] as? String) ?? ""
                    let access_token = (responseDict["access_token"] as? String) ?? ""
                    let openId = (responseDict["openid"] as? String) ?? ""
                    
                    let userinfoURL = "https://api.weixin.qq.com/sns/userinfo?access_token=\(access_token)&openid=\(openId)"
                    RequestManager.shared.getAsyncExternal(userinfoURL, { (responseObject) in
                        guard let responseDict = responseObject as? [String: AnyObject] else {
                            self.stopLoadingInfoFromThirdLogin(FmtError(1, NSLocalizedString("login_vc_login_failed")))
                            return
                        }
                        
                        let username = (responseDict["nickname"] as? String) ?? ""
                        let sex = (responseDict["sex"] as? Int) ?? 0
                        let gender = "\((sex == 1) ? Cons.Usr.genderMale : ((sex == 2) ? Cons.Usr.genderFemale : Cons.Usr.genderSecret))"
                        let avatar = (responseDict["headimgurl"] as? String) ?? ""
                        let thirdId = "\(openId)|\(unionId)"
                        DataManager.shared.loginThird("wx", access_token, thirdId, username, avatar, gender, { (responseObject, error, profileURL) in
                            if error == nil {
                                UserManager.shared.avatar = profileURL ?? avatar
                            }
                            self.stopLoadingInfoFromThirdLogin(error)
                        })
                    }, { (error) in
                        self.stopLoadingInfoFromThirdLogin(error)
                    })
                }, { (error) in
                    self.stopLoadingInfoFromThirdLogin(error)
                })
            }
        }
    }
    
    @IBAction func loginQQ(_ sender: UIButton?) {
        DDSocialAuthHandler.sharedInstance().auth(with: .QQ, controller: self) { (platform, state, result, error) in
            if state == .success {
                if let tencentOAuth = result?.userInfo as? TencentOAuth {
                    self.startLoadingInfoFromThirdLogin()
                    tencentOAuth.sessionDelegate = self
                    tencentOAuth.getUserInfo()
                    self.lastLoginThirdId = result?.thirdId
                    self.lastLoginThirdToken = result?.thirdToken
                }
            }
        }
    }
    
    @IBAction func loginFacebook(_ sender: UIButton?) {
        DDSocialAuthHandler.sharedInstance().auth(with: .facebook, controller: self) { (platform, state, result, error) in
            if state == .success {
                self.startLoadingInfoFromThirdLogin()
                let thirdId = result?.thirdId ?? ""
                let accessToken = result?.thirdToken ?? ""
                FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "email,name,gender,picture.type(large)"]).start(completionHandler: { (connection, result, error) in
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
                    
                    DataManager.shared.loginThird("facebook", accessToken, thirdId, username, avatar, gender, { (responseObject, error, profileURL) in
                        if error == nil {
                            UserManager.shared.avatar = profileURL ?? avatar
                        }
                        self.stopLoadingInfoFromThirdLogin(error)
                    })
                })
            }
        }
    }
    
    @IBAction func loginTwitter(_ sender: UIButton?) {
        DDSocialAuthHandler.sharedInstance().auth(with: .twitter, controller: self) { (platform, state, result, error) in
            if state == .success {
                if let session = result?.userInfo as? TWTRSession {
                    self.startLoadingInfoFromThirdLogin()
                    let thirdId = result?.thirdId ?? ""
                    let accessToken = result?.thirdToken ?? ""
                    let authTokenSecret = session.authTokenSecret
                    let username = session.userName
                    TWTRAPIClient.withCurrentUser().loadUser(withID: thirdId, completion: { (user: TWTRUser?, error) in
                        if error != nil {
                            self.stopLoadingInfoFromThirdLogin(error as Error?)
                        } else {
                            var avatar: String?
                            if let value = user?.profileImageLargeURL {
                                avatar = value
                            }
                            
                            DataManager.shared.loginThird("twitter", accessToken+"|"+authTokenSecret, thirdId, username, avatar, nil, { (responseObject, error, profileURL) in
                                if error == nil {
                                    UserManager.shared.avatar = profileURL ?? avatar
                                }
                                self.stopLoadingInfoFromThirdLogin(error)
                            })
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func loginGoogle(_ sender: UIButton?) {
        DDSocialAuthHandler.sharedInstance().auth(with: .google, controller: self) { (platform, state, result, error) in
            if state == .success {
                if let googleUser = result?.userInfo as? GIDGoogleUser {
                    self.startLoadingInfoFromThirdLogin()
                    let thirdId = result?.thirdId ?? ""
                    let accessToken = result?.thirdToken ?? ""
                    let username = googleUser.profile.name ?? ""
                    let detailRequestURL = "https://www.googleapis.com/oauth2/v2/userinfo?access_token="+accessToken
                    RequestManager.shared.getAsyncExternal(detailRequestURL, { (responseObject) in
                        guard let responseObject = responseObject as? [String: AnyObject] else {
                            self.stopLoadingInfoFromThirdLogin(FmtError(1, NSLocalizedString("login_vc_login_failed")))
                            return
                        }
                        DLog(responseObject)
//                        let email = responseObject["email"]
                        let avatar = responseObject["picture"] as? String
                        var gender: String?
                        if let genderString = responseObject["gender"] as? String {
                            gender = "\((genderString == "male") ? Cons.Usr.genderMale : ((genderString == "female") ? Cons.Usr.genderFemale : Cons.Usr.genderSecret))"
                        }
                        DataManager.shared.loginThird("google", accessToken, thirdId, username, avatar, gender, { (responseObject, error, profileURL) in
                            if error == nil {
                                UserManager.shared.avatar = profileURL ?? avatar
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
    
    func tencentDidNotLogin(_ cancelled: Bool) {}
    
    func tencentDidNotNetWork() {}
    
    func getUserInfoResponse(_ response: APIResponse) {
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
        
        DataManager.shared.loginThird("qq", accessToken, thirdId, username, avatar, gender, { (responseObject, error, profileURL) in
            if error == nil {
                UserManager.shared.avatar = profileURL ?? avatar
            }
            self.stopLoadingInfoFromThirdLogin(error)
        })
    }
}

// MARK: Register
extension LoginViewController {
    
    @IBAction func register(_ sender: UIButton?) {
        self.dismissKeyboard()
        
        if let strEmail = tfEmail?.text,
            let strPassword = tfPassword?.text {
            // Strat indicator
            MBProgressHUD.show(self.view)
            
            // Request
            DataManager.shared.register(strEmail, strPassword, self.selectedGender) { responseObject, error in
                MBProgressHUD.hide(self.view)
                if let error = error {
                    DataManager.showRequestFailedAlert(error)
                } else {
                    UIAlertController.presentAlert(from: self,
                                                   title: NSLocalizedString("alert_title_success"),
                                                   message: NSLocalizedString("login_vc_register_alert_message"),
                                                   UIAlertAction(title: NSLocalizedString("login_vc_register_alert_button"),
                                                                 style: UIAlertActionStyle.default,
                                                                 handler: { (action: UIAlertAction) -> Void in
                                                                    self.navigationController?.popViewController(animated: true)
                                                   }),
                                                   UIAlertAction(title: NSLocalizedString("alert_button_close"),
                                                                 style: UIAlertActionStyle.cancel,
                                                                 handler: nil))
                }
            }
        }
    }
    
    @IBAction func selectGender(_ sender: NYSegmentedControl?) {
        if let segmentedControl = sender {
            self.selectedGender = "\(segmentedControl.selectedSegmentIndex + 1)"
        }
    }
}

// MARK: Reset Password
extension LoginViewController {
    
    @IBAction func getCode(_ sender: UIButton?) {
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
                    self.btnGetCode?.isEnabled = !self.hasSentVerificationCode
                    UIAlertController.presentAlert(from: self,
                                                   message: NSLocalizedString("login_vc_reset_password_get_code_alert_message"),
                                                   UIAlertAction(title: NSLocalizedString("alert_button_close"),
                                                                 style: UIAlertActionStyle.cancel,
                                                                 handler: nil))
                }
            }
        }
    }
    
    @IBAction func resetPassword(_ sender: UIButton?) {
        self.dismissKeyboard()
        
        if let strVerificationCode = tfVerificationCode?.text,
            let strPassword = tfPassword?.text {
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
                        UIAlertController.presentAlert(from: self,
                                                       title: NSLocalizedString("alert_title_success"),
                                                       message: NSLocalizedString("login_vc_reset_password_alert_message"),
                                                       UIAlertAction(title: NSLocalizedString("alert_button_ok"),
                                                                     style: UIAlertActionStyle.cancel,
                                                                     handler: nil))
                    })
                }
            }
        }
    }
}

// MARK: KeyboardControl
extension LoginViewController {
    
    override func adjustViewsForKeyboardFrame(_ keyboardFrame: CGRect, _ isAnimated: Bool, _ duration: TimeInterval, _ options: UIViewAnimationOptions) {
        super.adjustViewsForKeyboardFrame(keyboardFrame, isAnimated, duration, options)
        if let scrollView = self.scrollView {
            self.updateScrollViewInset(scrollView, 0, true, true, false, false)
        }
    }
}

// MARK: NYSegmentedControlDataSource
extension LoginViewController: NYSegmentedControlDataSource {
    
    func number(ofSegments control: NYSegmentedControl) -> UInt {
        return 3
    }
    
    func segmentedControl(_ control: NYSegmentedControl, titleForSegmentAt index: UInt) -> String {
        let indexInt = Int(index)
        if indexInt == Cons.Usr.genderSecretIndex {
            return NSLocalizedString("user_info_gender_secret")
        } else if indexInt == Cons.Usr.genderMaleIndex {
            return NSLocalizedString("user_info_gender_male")
        } else if indexInt == Cons.Usr.genderFemaleIndex {
            return NSLocalizedString("user_info_gender_female")
        }
        return ""
    }
}

// MARK: 1Password
extension LoginViewController {
    
    func addOnePasswordButton() {
        if OnePasswordExtension.shared().isAppExtensionAvailable() {
            let opImage = UIImage(named: "onepassword-navbar")
            switch self.type {
            case .login:
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: opImage, style: .plain, target: self, action: #selector(LoginViewController.findLoginFrom1Password(_:)))
            case .register:
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: opImage, style: .plain, target: self, action: #selector(LoginViewController.saveLoginTo1Password(_:)))
            case .resetPassword:
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: opImage, style: .plain, target: self, action: #selector(LoginViewController.changePasswordIn1Password(_:)))
            }
        }
    }
    
    @objc func findLoginFrom1Password(_ sender: AnyObject?) {
        OnePasswordExtension.shared().findLogin(forURLString: "soyou.io", for: self, sender: sender) { loginDictionary, error in
            self.tfEmail?.text = loginDictionary?[AppExtensionUsernameKey] as? String
            self.tfPassword?.text = loginDictionary?[AppExtensionPasswordKey] as? String
            self.validateActionButton()
            if self.btnAction?.isEnabled ?? false {
                self.login(self.btnAction)
            }
        }
    }
    
    @objc func saveLoginTo1Password(_ sender: AnyObject?) {
        OnePasswordExtension.shared().storeLogin(forURLString: "soyou.io", loginDetails: nil, passwordGenerationOptions: nil, for: self, sender: sender) { loginDictionary, error in
            self.tfEmail?.text = loginDictionary?[AppExtensionUsernameKey] as? String
            self.tfPassword?.text = loginDictionary?[AppExtensionPasswordKey] as? String
            self.tfPasswordConfirm?.text = loginDictionary?[AppExtensionPasswordKey] as? String
            self.validateActionButton()
        }
    }
    
    @objc func changePasswordIn1Password(_ sender: AnyObject?) {
        OnePasswordExtension.shared().changePasswordForLogin(forURLString: "soyou.io", loginDetails: nil, passwordGenerationOptions: nil, for: self, sender: sender) { loginDictionary, error in
            self.tfEmail?.text = loginDictionary?[AppExtensionUsernameKey] as? String
            self.tfPassword?.text = loginDictionary?[AppExtensionPasswordKey] as? String
            self.tfPasswordConfirm?.text = loginDictionary?[AppExtensionPasswordKey] as? String
            self.validateActionButton()
        }
    }
}

// MARK: ZFModalTransitionAnimator
extension LoginViewController {
    
    func setupTransitionAnimator(modalVC: UIViewController) {
        // Setup ZFModalTransitionAnimator
        self.transitionAnimator = ZFModalTransitionAnimator(modalViewController: modalVC)
        self.transitionAnimator?.direction = ZFModalTransitonDirection.bottom
        self.transitionAnimator?.setContentScrollView(self.scrollView)
        self.transitionAnimator?.bounces = false
        self.transitionAnimator?.transitionDuration = 0.3
        self.transitionAnimator?.dismissVelocity = 1000
        self.transitionAnimator?.dismissDistance = modalVC.view.frame.height / 3.0
    }
}
