//
//  MBProgressHUD+Additions.swift
//  iPrices
//
//  Created by CocoaBob on 20/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

// Helpers
extension MBProgressHUD {
    
    class func showLoader() {
        let hideClosure = {
            MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().delegate?.window!, animated: true)
        }
        if NSThread.isMainThread() {
            hideClosure()
        } else {
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                hideClosure()
            })
        }
    }
    
    class func hideLoader() {
        let hideClosure = {
            MBProgressHUD.hideAllHUDsForView(UIApplication.sharedApplication().delegate?.window!, animated: true)
        }
        if NSThread.isMainThread() {
            hideClosure()
        } else {
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                hideClosure()
            })
        }
    }
}