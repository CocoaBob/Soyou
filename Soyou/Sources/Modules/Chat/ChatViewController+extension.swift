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
    }
}
