//
//  MBProgressHUD+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 20/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

// Helpers
extension MBProgressHUD {
    
    @discardableResult class func show(_ view: UIView? = nil) -> MBProgressHUD? {
        var progressHUD: MBProgressHUD?
        let closure = {
            progressHUD = MBProgressHUD.showAdded(to: view ?? UIApplication.shared.keyWindow!, animated: true)
            progressHUD?.contentColor = UIColor.white
            progressHUD?.bezelView.style = MBProgressHUDBackgroundStyle.solidColor
            progressHUD?.bezelView.color = UIColor(white: 0, alpha: 0.667)
        }
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.sync(execute: { () -> Void in
                closure()
            })
        }
        return progressHUD
    }
    
    class func hide(_ view: UIView? = nil) {
        let closure = {
            MBProgressHUD.hide(for: view ?? UIApplication.shared.keyWindow!, animated: true)
        }
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.sync(execute: { () -> Void in
                closure()
            })
        }
    }
}
