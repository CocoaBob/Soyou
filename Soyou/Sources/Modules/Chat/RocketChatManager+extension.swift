//
//  RocketChatManager+extension.swift
//  Soyou
//
//  Created by CocoaBob on 2018-04-26.
//  Copyright © 2018 Soyou. All rights reserved.
//

extension RocketChatManager {
    
    static func openDirectMessage(from fromVC: UIViewController, userID: Int) {
        MBProgressHUD.show(fromVC.view)
        DataManager.shared.getUserInfo(userID) { response, error in
            if let _ = error {
                MBProgressHUD.hide(fromVC.view)
            } else {
                RocketChatManager.openDirectMessage(username: "\(userID)") {
                    MBProgressHUD.hide(fromVC.view)
                    if let chatVC = ChatViewController.shared {
                        fromVC.navigationController?.setNavigationBarHidden(false, animated: true)
                        fromVC.navigationController?.pushViewController(chatVC, animated: true)
                    }
                }
            }
        }
    }
}
