//
//  ProductViewController.swift
//  iPrices
//
//  Created by CocoaBob on 03/01/16.
//  Copyright © 2016 iPrices. All rights reserved.
//

class ProductViewController: UIViewController {
    
}

// MARK: ZoomInteractiveTransition
extension ProductViewController: ZoomTransitionProtocol {
    
    func viewForZoomTransition(isSource: Bool) -> UIView? {
        return self.view
    }
    
    func animationBlockForZoomTransition() -> ZoomAnimationBlock! {
        return { (animatedSnapshot: UIImageView!, sourceView: UIView!, destinationView: UIView!) -> Void in
            animatedSnapshot.transform = CGAffineTransformMakeScale(1.02, 1.02)
        }
    }
    
    func completionBlockForZoomTransition() -> ZoomCompletionBlock! {
        return { (animatedSnapshot: UIImageView!, sourceView: UIView!, destinationView: UIView!, completion: (() -> Void)?) -> Void in
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                animatedSnapshot.transform = CGAffineTransformIdentity
                }, completion: { (Bool) -> Void in
                    if let completion = completion {
                        completion()
                    }
            })
        }
    }
}