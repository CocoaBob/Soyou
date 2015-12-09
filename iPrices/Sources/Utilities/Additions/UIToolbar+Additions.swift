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
            // No animation
            let transition = CATransition()
            transition.duration = 0
            transition.type = kCATransitionFade
            return transition
        }
        return nil
    }
}
