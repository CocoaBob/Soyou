//
//  UIView+Additions.swift
//  iPrices
//
//  Created by CocoaBob on 17/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

// MARK: Expose CALayer properties to Interface Builder
extension UIView {
    
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)
        }
        set {
            self.layer.cornerRadius = CGFloat(newValue)
            self.layer.masksToBounds = self.layer.cornerRadius > 0
        }
    }
    
    @IBInspectable var borderWidth: Double {
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = self.layer.borderColor {
                return UIColor(CGColor: color)
            } else {
                return nil
            }
        }
        set {
            self.layer.borderColor = newValue?.CGColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = self.layer.shadowColor {
                return UIColor(CGColor: color)
            } else {
                return nil
            }
        }
        set {
            self.layer.shadowColor = newValue?.CGColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowRadius: Double {
        get {
            return Double(self.layer.shadowRadius)
        }
        set {
            self.layer.shadowRadius = CGFloat(newValue)
        }
    }
}