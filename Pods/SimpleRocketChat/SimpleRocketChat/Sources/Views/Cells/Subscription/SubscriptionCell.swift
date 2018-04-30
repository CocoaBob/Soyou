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
    @IBOutlet weak var labelUnread: UILabel!
    @IBOutlet weak var labelUnreadWidth: NSLayoutConstraint!
    @IBOutlet weak var statusView: UIView!

    func updateSubscriptionInformatin() {
        guard let subscription = self.subscription else { return }

        imageViewAvatar.sd_setImage(with: subscription.directMessageUser?.avatarURL(),
                                    placeholderImage: UIImage(namedInBundle: "SoyouImagePlaceholder"),
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
        labelUnreadWidth.constant = subscription.unread > 99 ? 30 : (subscription.unread > 9 ? 23 : (subscription.unread > 0 ? 16 : 0))
        labelUnread.text = "\(subscription.unread)"
        
        updateStatus()
    }
    
    func updateStatus() {
        if let user = self.subscription?.directMessageUser {
            switch user.status {
            case .online:
                statusView.backgroundColor = UIColor(rgb: 0x2DE0A5, alphaVal: 1)
            case .offline:
                statusView.backgroundColor = UIColor(rgb: 0xCBCED1, alphaVal: 1)
            case .away:
                statusView.backgroundColor = UIColor(rgb: 0xFFD21F, alphaVal: 1)
            case .busy:
                statusView.backgroundColor = UIColor(rgb: 0xF5455C, alphaVal: 1)
            }
        } else {
            statusView.backgroundColor = UIColor(rgb: 0xCBCED1, alphaVal: 1)
        }
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
