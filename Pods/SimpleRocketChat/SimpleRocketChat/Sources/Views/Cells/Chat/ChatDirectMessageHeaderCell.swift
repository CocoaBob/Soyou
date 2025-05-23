//
//  ChatDirectMessageHeaderCell.swift
//  Rocket.Chat
//
//  Created by Rafael Kellermann Streit on 24/08/17.
//  Copyright © 2017 Rocket.Chat. All rights reserved.
//

import UIKit

class ChatDirectMessageHeaderCell: UICollectionViewCell {

    static let minimumHeight = CGFloat(240)
    static let identifier = "ChatDirectMessageHeaderCell"

    var subscription: Subscription? {
        didSet {
            guard let user = subscription?.directMessageUser else {
                return fetchUser()
            }

            labelUser.text = user.displayName()
            avatarView.user = user

            let startText = localized("chat.dm.start_conversation")
            labelStartConversation.text = String(format: startText, user.displayName())
        }
    }

    @IBOutlet weak var avatarViewContainer: UIView! {
        didSet {
            if let avatarView = AvatarView.instantiateFromNib() {
                avatarView.frame = avatarViewContainer.bounds
                avatarViewContainer.addSubview(avatarView)
                self.avatarView = avatarView
            }
        }
    }

    weak var avatarView: AvatarView! {
        didSet {
            avatarView.layer.cornerRadius = 48
            avatarView.layer.masksToBounds = true
        }
    }

    @IBOutlet weak var labelUser: UILabel!
    @IBOutlet weak var labelStartConversation: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()

        avatarView.user = nil
        labelUser.text = ""
        labelStartConversation.text = ""
    }

    func fetchUser() {
        guard let userId = subscription?.otherUserId else { return }

        User.fetch(by: .userId(userId), completion: { _ in
            DispatchQueue.main.async { [weak self] in
                self?.subscription = self?.subscription
            }
        })
    }

}
