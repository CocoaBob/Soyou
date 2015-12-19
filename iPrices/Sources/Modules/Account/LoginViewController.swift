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
                self.title = NSLocalizedString("login_vc_login_title", comment: "")
            case .Register:
                self.title = NSLocalizedString("login_vc_register_title", comment: "")
            case .ForgetPassword:
                self.title = NSLocalizedString("login_vc_forget_password_title", comment: "")
            case .ResetPassword:
                self.title = NSLocalizedString("login_vc_reset_password_title", comment: "")
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
        
        // Navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "dismissSelf")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.keyboardControlInstall()
        self.updateScrollViewInset(self.scrollView!, false, false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.keyboardControlUninstall()
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
    
    private func startIndicator() {
        
    }
    
    private func stopIndicator() {
        
    }
}

// MARK: Login
extension LoginViewController {
    
    @IBAction func login(sender: UIButton?) {
        if let strEmail = tfEmail?.text, let strPassword = tfPassword?.text {
            // Strat indicator
            self.startIndicator()
            
            // Request
            ServerManager.shared.login(
                strEmail,
                strPassword,
                { (responseObject: AnyObject?) -> () in self.handleLoginSuccess(responseObject) },
                { (error: NSError?) -> () in self.handleLoginError(error) }
            )
        }
    }
    
    private func handleLoginSuccess(responseObject: AnyObject?) {
        // Stop indicator
        self.stopIndicator()
        
        // Handle data
        guard let responseObject = responseObject as? Dictionary<String, AnyObject> else { return }

    }
    
    private func handleLoginError(error: NSError?) {
        // Stop indicator
        self.stopIndicator()
        
        print("\(error)")
    }
}

// MARK: Register
extension LoginViewController {
    
    @IBAction func register(sender: UIButton?) {
        if let strEmail = tfEmail?.text, let strPassword = tfPassword?.text {
            // Strat indicator
            self.startIndicator()
            
            // Request
            ServerManager.shared.register(
                strEmail,
                strPassword,
                { (responseObject: AnyObject?) -> () in self.handleRegisterSuccess(responseObject) },
                { (error: NSError?) -> () in self.handleRegisterError(error) }
            )
        }
    }
    
    private func handleRegisterSuccess(responseObject: AnyObject?) {
        // Stop indicator
        self.stopIndicator()
        
        // Handle data
        guard let responseObject = responseObject as? Dictionary<String, AnyObject> else { return }
        
    }
    
    private func handleRegisterError(error: NSError?) {
        // Stop indicator
        self.stopIndicator()
        
        print("\(error)")
    }
}

// MARK: Forget Password
extension LoginViewController {
    
    @IBAction func forgetPassword(sender: UIButton?) {
        if let strEmail = tfEmail?.text {
            // Strat indicator
            self.startIndicator()
            
            // Request
            ServerManager.shared.requestVerifyCode(
                strEmail,
                { (responseObject: AnyObject?) -> () in self.handleForgetPasswordSuccess(responseObject) },
                { (error: NSError?) -> () in self.handleForgetPasswordError(error) }
            )
        }
    }
    
    private func handleForgetPasswordSuccess(responseObject: AnyObject?) {
        // Stop indicator
        self.stopIndicator()
        
        // Handle data
        guard let responseObject = responseObject as? Dictionary<String, AnyObject> else { return }
        
    }
    
    private func handleForgetPasswordError(error: NSError?) {
        // Stop indicator
        self.stopIndicator()
        
        print("\(error)")
    }
}

// MARK: Reset Password
extension LoginViewController {
    
    @IBAction func resetPassword(sender: UIButton?) {
        if let strVerificationCode = tfVerificationCode?.text, let strPassword = tfPassword?.text {
            // Strat indicator
            self.startIndicator()
            
            // Request
            ServerManager.shared.resetPassword(
                strVerificationCode,
                strPassword,
                { (responseObject: AnyObject?) -> () in self.handleResetPasswordSuccess(responseObject) },
                { (error: NSError?) -> () in self.handleResetPasswordError(error) }
            )
        }
    }
    
    private func handleResetPasswordSuccess(responseObject: AnyObject?) {
        // Stop indicator
        self.stopIndicator()
        
        // Handle data
        guard let responseObject = responseObject as? Dictionary<String, AnyObject> else { return }
        
    }
    
    private func handleResetPasswordError(error: NSError?) {
        // Stop indicator
        self.stopIndicator()
        
        print("\(error)")
    }
}

// MARK: KeyboardControl
extension LoginViewController {
    
    override func adjustViewsForKeyboardFrame(keyboardFrame: CGRect, _ isAnimated: Bool, _ duration: NSTimeInterval, _ options: UIViewAnimationOptions) {
        super.adjustViewsForKeyboardFrame(keyboardFrame, isAnimated, duration, options)
        self.updateScrollViewInset(self.scrollView!, false, false)
    }
}