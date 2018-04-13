//
//  SubscriptionCell.swift
//  Rocket.Chat
//
//  Created by Rafael K. Streit on 8/4/16.
//  Copyright © 2016 Rocket.Chat. All rights reserved.
//

import UIKit

final class SubscriptionCell: UITableViewCell {

    static let identifier = "CellSubscription"

    internal let labelSelectedTextColor = UIColor(rgb: 0x000000, alphaVal: 1)
    internal let labelReadTextColor = UIColor(rgb: 0x585b5c, alphaVal: 1)
    internal let labelUnreadTextColor = UIColor(rgb: 0x000000, alphaVal: 1)

    internal let defaultBackgroundColor = UIColor.clear
    internal let selectedBackgroundColor = UIColor(rgb: 0x0, alphaVal: 0.18)
    internal let highlightedBackgroundColor = UIColor(rgb: 0x0, alphaVal: 0.27)

    var subscription: Subscription? {
        didSet {
            updateSubscriptionInformatin()
        }
    }

    @IBOutlet weak var imageViewAvatar: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelUnread: UILabel! {
        didSet {
            labelUnread.layer.cornerRadius = 2
        }
    }
    @IBOutlet weak var labelUnreadWidth: NSLayoutConstraint!

    func updateSubscriptionInformatin() {
        guard let subscription = self.subscription else { return }

        imageViewAvatar.sd_setImage(with: subscription.directMessageUser?.avatarURL(),
                                    placeholderImage: nil,
                                    options: [.allowInvalidSSLCertificates],
                                    completed: nil)

        labelName.text = subscription.displayName()

        if subscription.unread > 0 || subscription.alert {
            labelName.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
            labelName.textColor = labelUnreadTextColor
        } else {
            labelName.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
            labelName.textColor = labelReadTextColor
        }

        labelUnread.alpha = subscription.unread > 0 ? 1 : 0
        labelUnreadWidth.constant = subscription.unread > 0 ? 28 : 0
        labelUnread.text = "\(subscription.unread)"
    }
}

extension SubscriptionCell {

    override func setSelected(_ selected: Bool, animated: Bool) {
        let transition = {
            switch selected {
            case true:
                self.backgroundColor = self.selectedBackgroundColor
            case false:
                self.backgroundColor = self.defaultBackgroundColor
            }
        }

        if animated {
            UIView.animate(withDuration: 0.18, animations: transition)
        } else {
            transition()
        }
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let transition = {
            switch highlighted {
            case true:
                self.backgroundColor = self.highlightedBackgroundColor
            case false:
                self.backgroundColor = self.defaultBackgroundColor
            }
        }

        if animated {
            UIView.animate(withDuration: 0.18, animations: transition)
        } else {
            transition()
        }
    }
}
