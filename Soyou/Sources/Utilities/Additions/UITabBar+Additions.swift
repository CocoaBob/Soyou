//
//  UITabBar+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 09/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

extension UITabBar {
    
    override public func actionForLayer(layer: CALayer, forKey event: String) -> CAAction? {
        if "position" == event {
            let transition = CATransition()
            
            if layer.position.x < 0 || layer.position.x >= layer.bounds.size.width {
                transition.subtype = kCATransitionFromTop
            } else if layer.position.y > layer.bounds.size.height {
                transition.subtype = kCATransitionFromBottom
            } else {
                return nil;
            }
            
            transition.type = kCATransitionPush
            transition.duration = 0.25
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
            
            return transition
        }
        return super.actionForLayer(layer, forKey: event)
    }
}