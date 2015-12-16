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
    
    @IBOutlet var tfEmail: UITextField?
    @IBOutlet var tfPassword: UITextField?
    @IBOutlet var tfPasswordConfirm: UITextField?
    @IBOutlet var tfVerificationCode: UITextField?
    
}

// MARK: UITextFieldDelegate
extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        return true
    }
    
}

// MARK: Actions
extension LoginViewController {
    
    @IBAction func login(sender: UIButton) {
        
    }
    
    @IBAction func register(sender: UIButton) {
        
    }
    
    @IBAction func forgetPassword(sender: UIButton) {
        
    }
    
    @IBAction func resetPassword(sender: UIButton) {
        
    }
}