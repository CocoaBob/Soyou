//
//  UIToolbar+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 09/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

private var needsPushAnimationKey: UInt8 = 0
extension UIToolbar {
    
    var needsPushAnimation: Bool {
        get {
            return (objc_getAssociatedObject(self, &needsPushAnimationKey) as? NSNumber)?.boolValue ?? false
        }
        set {
            objc_setAssociatedObject(self, &needsPushAnimationKey, NSNumber(value: newValue), .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    override open func action(for layer: CALayer, forKey event: String) -> CAAction? {
        if "position" == event && self.needsPushAnimation {
            let transition = CATransition()
            
            transition.duration = 0.25
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromTop
            
            return transition
        }
        return super.action(for: layer, forKey: event)
    }
}
