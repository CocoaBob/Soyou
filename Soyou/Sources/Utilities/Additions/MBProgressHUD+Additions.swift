//
//  MBProgressHUD+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 20/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

// Helpers
extension MBProgressHUD {
    
    class func showLoader(view: UIView?) -> MBProgressHUD? {
        var progressHUD: MBProgressHUD?
        let hideClosure = {
            progressHUD = MBProgressHUD.showHUDAddedTo(view ?? UIApplication.sharedApplication().delegate?.window!, animated: true)
        }
        if NSThread.isMainThread() {
            hideClosure()
        } else {
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                hideClosure()
            })
        }
        return progressHUD
    }
    
    class func hideLoader(view: UIView?) {
        let hideClosure = {
            MBProgressHUD.hideAllHUDsForView(view ?? UIApplication.sharedApplication().delegate?.window!, animated: true)
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
