//
//  UIToolbar+Additions.swift
//  iPrices
//
//  Created by CocoaBob on 09/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

extension UIToolbar {
    
    override public func actionForLayer(layer: CALayer, forKey event: String) -> CAAction? {
        if "position" == event {
            let transition = CATransition()
            transition.duration = 0.25
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            transition.type = kCATransitionPush
            
            if layer.position.x < 0 || layer.position.x >= layer.bounds.size.width {
                transition.subtype = kCATransitionFromTop
            } else if layer.position.y > 0 {
                transition.subtype = kCATransitionFromTop
            } else {
                return nil;
            }
            
            return transition
        }
        return nil
    }
}
