//
//  ChatTitleView.swift
//  Rocket.Chat
//
//  Created by Rafael K. Streit on 10/10/16.
//  Copyright © 2016 Rocket.Chat. All rights reserved.
//

import UIKit

final class ChatTitleView: UIView {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel! {
        didSet {
            labelTitle.textColor = .RCDarkGray()
        }
    }

    @IBOutlet weak var imageArrowDown: UIImageView! {
        didSet {
            imageArrowDown.image = UIImage(namedInBundle: "Arrow Down")?.withRenderingMode(.alwaysTemplate)
            imageArrowDown.tintColor = .RCGray()
        }
    }

    override var intrinsicContentSize: CGSize {
        return UILayoutFittingExpandedSize
    }

    let viewModel = ChatTitleViewModel()

    var subscription: Subscription? {
        didSet {
            guard let subscription = subscription, !subscription.isInvalidated else { return }

            viewModel.subscription = subscription
            labelTitle.text = viewModel.title
            icon.image = UIImage(namedInBundle: viewModel.imageName)?.withRenderingMode(.alwaysTemplate)
            icon.tintColor = viewModel.iconColor
        }
    }

}
