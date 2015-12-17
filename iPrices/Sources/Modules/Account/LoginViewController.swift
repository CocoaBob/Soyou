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
        }
    }
    
    @IBOutlet var tfEmail: NextResponderTextField?
    @IBOutlet var tfPassword: NextResponderTextField?
    @IBOutlet var tfPasswordConfirm: NextResponderTextField?
    @IBOutlet var tfVerificationCode: NextResponderTextField?
    @IBOutlet var btnAction: UIButton?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.keyboardControlInstall()
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
            break
        case .ForgetPassword:
            break
        case .ResetPassword:
            break
        }
        return true
    }
    
}

// MARK: Routines
extension LoginViewController {
    
    func validateActionButton() {
        
        switch self.type {
        case .Login:
            if let strEmail = tfEmail?.text, let strPassword = tfPassword?.text {
                self.btnAction?.enabled = (strEmail.isEmail() && !strPassword.isEmpty)
            } else {
                self.btnAction?.enabled = false
            }
        case .Register:
            break
        case .ForgetPassword:
            break
        case .ResetPassword:
            break
        }
    }
}

// MARK: Actions
extension LoginViewController {
    
    @IBAction func textFieldDidChange(textField: UITextField?) {
        validateActionButton()
    }
    
    @IBAction func login(sender: UIButton?) {
        
    }
    
    @IBAction func register(sender: UIButton?) {
        
    }
    
    @IBAction func forgetPassword(sender: UIButton?) {
        
    }
    
    @IBAction func resetPassword(sender: UIButton) {
        
    }
}