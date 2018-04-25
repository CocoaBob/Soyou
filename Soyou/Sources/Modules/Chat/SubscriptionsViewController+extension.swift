//
//  SubscriptionsViewController+extension.swift
//  Soyou
//
//  Created by CocoaBob on 2018-04-25.
//  Copyright © 2018 Soyou. All rights reserved.
//

extension SubscriptionsViewController {
    
    static func setup() {
        guard let rocketChatVC = SubscriptionsViewController.shared else { return }
        rocketChatVC.title = NSLocalizedString("chats_vc_title")
        rocketChatVC.tabBarItem = UITabBarItem(title: NSLocalizedString("chats_vc_tab_title"),
                                               image: UIImage(named: "img_tab_chat"),
                                               selectedImage: UIImage(named: "img_tab_chat_selected"))
        
        rocketChatVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                         target: rocketChatVC,
                                                                         action: #selector(SubscriptionsViewController.createChat))
    }
    
    @objc func createChat() {
        let membersVC = MembersViewController.instantiate()
        membersVC.userID = UserManager.shared.userID
        membersVC.isSelectionMode = true
        membersVC.singleSelectionHandler = { member in
            membersVC.dismiss(animated: false, completion: nil)
            let userID = member.id
            MBProgressHUD.show(self.view)
            RocketChatManager.openDirectMessage(username: "\(userID)") {
                MBProgressHUD.hide(self.view)
                if let chatVC = ChatViewController.shared {
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    self.navigationController?.pushViewController(chatVC, animated: true)
                }
            }
        }
        let _ = membersVC.view
        membersVC.navigationItem.rightBarButtonItem = nil
        let navC = UINavigationController(rootViewController: membersVC)
        self.present(navC, animated: true, completion: nil)
    }
}
