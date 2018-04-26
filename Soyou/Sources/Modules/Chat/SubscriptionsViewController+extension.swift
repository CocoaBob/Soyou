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
        membersVC.isShowingFollowers = false
        membersVC.isSelectionMode = true
        membersVC.singleSelectionHandler = { member in
            membersVC.dismiss(animated: false, completion: nil)
            let userID = member.id
            RocketChatManager.openDirectMessage(from: self, userID: userID)
        }
        let _ = membersVC.view
        membersVC.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done,
                                                                      target: membersVC,
                                                                      action: #selector(MembersViewController.dismissSelf))
        let navC = UINavigationController(rootViewController: membersVC)
        self.present(navC, animated: true, completion: nil)
    }
}
