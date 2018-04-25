//
//  ChatViewController+extension.swift
//  Soyou
//
//  Created by CocoaBob on 2018-04-25.
//  Copyright © 2018 Soyou. All rights reserved.
//

extension ChatViewController {
    
    static func setup() {
        guard let chatVC = ChatViewController.shared else { return }
        chatVC.view.backgroundColor = Cons.UI.colorBG

        chatVC.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"img_user_selected"),
                                                                   style: .plain,
                                                                   target: chatVC,
                                                                   action: #selector(ChatViewController.viewUserProfile))
    }
    
    @objc func viewUserProfile() {
        if let userIDStr = self.username, let userID = Int(userIDStr) {
            MBProgressHUD.show(self.view)
            DataManager.shared.getUserInfo(userID) { response, error in
                MBProgressHUD.hide(self.view)
                if let response = response as? Dictionary<String, AnyObject>,
                    let data = response["data"] as? [String: AnyObject],
                    let avatar = data["profileUrl"] as? String,
                    let username = data["username"] as? String {
                    let circlesVC = CirclesViewController.instantiate(userID, avatar, username)
                    self.navigationController?.pushViewController(circlesVC, animated: true)
                }
            }
        }
    }
}
