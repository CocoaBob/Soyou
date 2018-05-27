//
//  AlertController+Additions.swift
//  Soyou
//
//  Created by CocoaBob on 2018-02-17.
//  Copyright © 2018 Soyou. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    class func presentAlert(from vc: UIViewController? = nil,
                            title: String? = nil,
                            message: String? = nil,
                            _ actions: UIAlertAction...) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let _  = actions.map { alertController.addAction($0) }
        var presentingVC = vc
        if presentingVC == nil {
            #if !NS_EXTENSION_UNAVAILABLE
            presentingVC = UIApplication.shared.keyWindow?.rootViewController
            #endif
        }
        if let presentedVC = presentingVC?.presentedViewController {
            presentingVC = presentedVC
        }
        presentingVC?.present(alertController, animated: true, completion: nil)
    }
    
    class func presentActionSheet(from vc: UIViewController? = nil,
                                  title: String? = nil,
                                  message: String? = nil,
                                  actions: [UIAlertAction]) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let _  = actions.map { alertController.addAction($0) }
        var presentingVC = vc
        if presentingVC == nil {
            #if !NS_EXTENSION_UNAVAILABLE
            presentingVC = UIApplication.shared.keyWindow?.rootViewController
            #endif
        }
        if let presentedVC = presentingVC?.presentedViewController {
            presentingVC = presentedVC
        }
        presentingVC?.present(alertController, animated: true, completion: nil)
    }
}
