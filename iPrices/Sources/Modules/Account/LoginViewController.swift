//
//  LoginViewController.swift
//  iPrices
//
//  Created by CocoaBob on 16/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

private enum LoginType: Int {
    case Login
    case Register
    case ForgetPassword
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
            case .ForgetPassword:
                self.title = NSLocalizedString("login_vc_forget_password_title")
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let scrollView = self.scrollView {
            self.updateScrollViewInset(scrollView, false, false)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.keyboardControlInstall()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.keyboardControlUninstall()
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        super.willMoveToParentViewController(parent)
        if let scrollView = self.scrollView {
            self.updateScrollViewInset(scrollView, false, false)
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
        case .ForgetPassword:
            if textField == tfEmail {
                self.forgetPassword(nil)
            }
        case .ResetPassword:
            if textField == tfPasswordConfirm{
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
            if let strEmail = tfEmail?.text, let strPassword = tfPassword?.text {
                self.btnAction?.enabled = (strEmail.isEmail() && !strPassword.isEmpty)
            }
        case .Register:
            if let strEmail = tfEmail?.text, let strPassword = tfPassword?.text, let strPasswordConfirm = tfPasswordConfirm?.text {
                self.btnAction?.enabled = (strEmail.isEmail() && !strPassword.isEmpty && strPassword == strPasswordConfirm)
            }
            break
        case .ForgetPassword:
            if let strEmail = tfEmail?.text {
                self.btnAction?.enabled = strEmail.isEmail()
            }
        case .ResetPassword:
            if let strVerificationCode = tfVerificationCode?.text, let strPassword = tfPassword?.text, let strPasswordConfirm = tfPasswordConfirm?.text {
                self.btnAction?.enabled = (!strVerificationCode.isEmpty && !strPassword.isEmpty && strPassword == strPasswordConfirm)
            }
        }
    }
    
    @IBAction func textFieldDidChange(textField: UITextField?) {
        validateActionButton()
    }
    
    func showErrorAlert(error: NSError?) {
        let responseObject = AFNetworkingGetResponseObjectFromError(error)
        print("\(responseObject)")
        // Show error
        if let responseObject = responseObject as? Dictionary<String, AnyObject>,
            data = responseObject["data"] as? [Dictionary<String, AnyObject>],
            message = data[0]["message"] as? String
        {
            SCLAlertView().showError(NSLocalizedString("alert_title_failed"), subTitle: message)
        }
    }
}

// MARK: Login
extension LoginViewController {
    
    @IBAction func login(sender: UIButton?) {
        self.dismissKeyboard()
        
        if let strEmail = tfEmail?.text, let strPassword = tfPassword?.text {
            // Strat indicator
            MBProgressHUD.showLoader()
            
            // Request
            RequestManager.shared.login(
                strEmail,
                strPassword,
                { (responseObject: AnyObject?) -> () in self.handleLoginSuccess(responseObject) },
                { (error: NSError?) -> () in self.handleLoginError(error) }
            )
        }
    }
    
    private func handleLoginSuccess(responseObject: AnyObject?) {
        // Stop indicator
        MBProgressHUD.hideLoader()
        
        // Handle data
        guard let responseObject = responseObject as? Dictionary<String, AnyObject> else { return }
        
        let userInfo = responseObject["data"] as! Dictionary<String, String>
        
        UserManager.shared.logIn(userInfo["token"]!, roleCode: userInfo["roleCode"]!)
    }
    
    private func handleLoginError(error: NSError?) {
        // Stop indicator
        MBProgressHUD.hideLoader()
        // Show alert
        self.showErrorAlert(error)
    }
}

// MARK: Register
extension LoginViewController {
    
    @IBAction func register(sender: UIButton?) {
        self.dismissKeyboard()
        
        if let strEmail = tfEmail?.text, let strPassword = tfPassword?.text {
            // Strat indicator
            MBProgressHUD.showLoader()
            
            // Request
            RequestManager.shared.register(
                strEmail,
                strPassword,
                { (responseObject: AnyObject?) -> () in self.handleRegisterSuccess(responseObject) },
                { (error: NSError?) -> () in self.handleRegisterError(error) }
            )
        }
    }
    
    private func handleRegisterSuccess(responseObject: AnyObject?) {
        // Stop indicator
        MBProgressHUD.hideLoader()
        
        // Alert
        let alertView = SCLAlertView()
        alertView.addButton(NSLocalizedString("login_vc_register_alert_button")) { () -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        }
        alertView.showCloseButton = false
        alertView.showSuccess(NSLocalizedString("alert_title_success"), subTitle: NSLocalizedString("login_vc_register_alert_button"))
    }
    
    private func handleRegisterError(error: NSError?) {
        // Stop indicator
        MBProgressHUD.hideLoader()
        // Show alert
        self.showErrorAlert(error)
    }
}

// MARK: Forget Password
extension LoginViewController {
    
    @IBAction func forgetPassword(sender: UIButton?) {
        self.dismissKeyboard()
        
        if let strEmail = tfEmail?.text {
            // Strat indicator
            MBProgressHUD.showLoader()
            
            // Request
            RequestManager.shared.requestVerifyCode(
                strEmail,
                { (responseObject: AnyObject?) -> () in self.handleForgetPasswordSuccess(responseObject) },
                { (error: NSError?) -> () in self.handleForgetPasswordError(error) }
            )
        }
    }
    
    private func handleForgetPasswordSuccess(responseObject: AnyObject?) {
        // Stop indicator
        MBProgressHUD.hideLoader()
        
        // Alert
        let alertView = SCLAlertView()
        alertView.addButton(NSLocalizedString("login_vc_forget_password_alert_button")) { () -> Void in
            // Show reset password view controller
            if let resetPasswordViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ResetPasswordViewController") {
                self.navigationController?.pushViewController(resetPasswordViewController, animated: true)
            }
        }
        alertView.showCloseButton = false
        alertView.showSuccess(NSLocalizedString("alert_title_info"), subTitle: NSLocalizedString("login_vc_forget_password_alert_message"))
    }
    
    private func handleForgetPasswordError(error: NSError?) {
        // Stop indicator
        MBProgressHUD.hideLoader()
        // Show alert
        self.showErrorAlert(error)
    }
}

// MARK: Reset Password
extension LoginViewController {
    
    @IBAction func resetPassword(sender: UIButton?) {
        self.dismissKeyboard()
        
        if let strVerificationCode = tfVerificationCode?.text, let strPassword = tfPassword?.text {
            // Strat indicator
            MBProgressHUD.showLoader()
            
            // Request
            RequestManager.shared.resetPassword(
                strVerificationCode,
                strPassword,
                { (responseObject: AnyObject?) -> () in self.handleResetPasswordSuccess(responseObject) },
                { (error: NSError?) -> () in self.handleResetPasswordError(error) }
            )
        }
    }
    
    private func handleResetPasswordSuccess(responseObject: AnyObject?) {
        // Stop indicator
        MBProgressHUD.hideLoader()
        
        // Alert
        let alertView = SCLAlertView()
        alertView.addButton(NSLocalizedString("alert_button_done")) { () -> Void in
            // Handle data
            guard let responseObject = responseObject as? Dictionary<String, AnyObject> else { return }
            let userInfo = responseObject["data"] as! Dictionary<String, String>
            UserManager.shared.logIn(userInfo["token"]!, roleCode: userInfo["roleCode"]!)
        }
        alertView.showCloseButton = false
        alertView.showSuccess(NSLocalizedString("alert_title_success"), subTitle: NSLocalizedString("login_vc_reset_password_alert_message"))
    }
    
    private func handleResetPasswordError(error: NSError?) {
        // Stop indicator
        MBProgressHUD.hideLoader()
        // Show alert
        self.showErrorAlert(error)
    }
}

// MARK: KeyboardControl
extension LoginViewController {
    
    override func adjustViewsForKeyboardFrame(keyboardFrame: CGRect, _ isAnimated: Bool, _ duration: NSTimeInterval, _ options: UIViewAnimationOptions) {
        super.adjustViewsForKeyboardFrame(keyboardFrame, isAnimated, duration, options)
        if let scrollView = self.scrollView {
            self.updateScrollViewInset(scrollView, false, false)
        }
    }
}