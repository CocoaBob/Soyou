//
//  MBProgressHUD+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 20/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

// Helpers
extension MBProgressHUD {
    
    class func show(view: UIView? = nil) -> MBProgressHUD? {
        var progressHUD: MBProgressHUD?
        let closure = {
            progressHUD = MBProgressHUD.showHUDAddedTo(view ?? UIApplication.sharedApplication().keyWindow!, animated: true)
            progressHUD?.contentColor = UIColor.whiteColor()
            progressHUD?.bezelView.style = MBProgressHUDBackgroundStyle.SolidColor
            progressHUD?.bezelView.color = UIColor(white: 0, alpha: 0.667)
        }
        if NSThread.isMainThread() {
            closure()
        } else {
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                closure()
            })
        }
        return progressHUD
    }
    
    class func hide(view: UIView? = nil) {
        let closure = {
            MBProgressHUD.hideHUDForView(view ?? UIApplication.sharedApplication().keyWindow!, animated: true)
        }
        if NSThread.isMainThread() {
            closure()
        } else {
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                closure()
            })
        }
    }
}
