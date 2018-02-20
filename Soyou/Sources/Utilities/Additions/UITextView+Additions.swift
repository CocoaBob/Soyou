//
//  UITextView+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 2018-02-19.
//  Copyright © 2018 Soyou. All rights reserved.
//

extension UITextView {
    
    @IBInspectable var textContainerInsetTop: Double {
        get {
            return Double(self.textContainerInset.top)
        }
        set {
            self.textContainerInset.top = CGFloat(newValue)
        }
    }
    
    @IBInspectable var textContainerInsetLeft: Double {
        get {
            return Double(self.textContainerInset.left)
        }
        set {
            self.textContainerInset.left = CGFloat(newValue)
        }
    }
    
    @IBInspectable var textContainerInsetBottom: Double {
        get {
            return Double(self.textContainerInset.bottom)
        }
        set {
            self.textContainerInset.bottom = CGFloat(newValue)
        }
    }
    
    @IBInspectable var textContainerInsetRight: Double {
        get {
            return Double(self.textContainerInset.right)
        }
        set {
            self.textContainerInset.right = CGFloat(newValue)
        }
    }
}
