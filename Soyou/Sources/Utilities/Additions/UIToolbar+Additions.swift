//
//  UIToolbar+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 09/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

extension UIToolbar {
    
    override public func actionForLayer(layer: CALayer, forKey event: String) -> CAAction? {
        if "position" == event {
            let transition = CATransition()
            transition.duration = 0.25
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromTop
            
            return transition
        }
        return nil
    }
}