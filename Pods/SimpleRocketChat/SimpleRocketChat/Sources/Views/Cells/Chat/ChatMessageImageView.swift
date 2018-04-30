//
//  ChatMessageImageView.swift
//  Rocket.Chat
//
//  Created by Rafael K. Streit on 03/10/16.
//  Copyright © 2016 Rocket.Chat. All rights reserved.
//

import UIKit
import SDWebImage
import FLAnimatedImage

protocol ChatMessageImageViewProtocol: class {
    func openImageFromCell(attachment: Attachment, thumbnail: FLAnimatedImageView)
}

final class ChatMessageImageView: ChatMessageAttachmentView {
    override static var defaultHeight: CGFloat {
        return 155
    }
    var isLoadable = true

    weak var delegate: ChatMessageImageViewProtocol?
    var attachment: Attachment! {
        didSet {
            if oldValue != nil && oldValue.identifier == attachment.identifier {
                Log.debug("attachment is cached")
                return
            }

            updateMessageInformation()
        }
    }

    @IBOutlet weak var detailText: UILabel!
    @IBOutlet weak var detailTextIndicator: UILabel!
    @IBOutlet weak var detailTextHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var fullHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicatorImageView: UIActivityIndicatorView!
    @IBOutlet weak var imageView: FLAnimatedImageView! {
        didSet {
            imageView.layer.cornerRadius = 3
            imageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.1).cgColor
            imageView.layer.borderWidth = 1
        }
    }
    @IBOutlet var imageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet var imageViewHeightConstraint: NSLayoutConstraint!

    private lazy var tapGesture: UITapGestureRecognizer = {
        return UITapGestureRecognizer(target: self, action: #selector(ChatMessageImageView.didTapView))
    }()

    private func getImage() -> URL? {
        guard let imageURL = attachment.fullImageURL() else {
            return nil
        }
        if imageURL.absoluteString.starts(with: "http://") {
            isLoadable = false
            detailText.text = ""
            imageView.contentMode = UIViewContentMode.center
            imageView.sd_setImage(with: nil, placeholderImage: UIImage(namedInBundle: "SoyouImagePlaceholder"))
            return nil
        }
        detailText.text = attachment.descriptionText
        detailTextIndicator.isHidden = attachment.descriptionText?.isEmpty ?? true
        let fullHeight = ChatMessageImageView.heightFor(withText: attachment.descriptionText)
        fullHeightConstraint.constant = fullHeight
        detailTextHeightConstraint.constant = fullHeight - ChatMessageImageView.defaultHeight
        return imageURL
    }

    fileprivate func updateMessageInformation() {
        let containsGesture = gestureRecognizers?.contains(tapGesture) ?? false
        if !containsGesture {
            addGestureRecognizer(tapGesture)
        }

        guard let imageURL = getImage() else {
            return
        }

        activityIndicatorImageView.startAnimating()

        let options: SDWebImageOptions = [.retryFailed, .scaleDownLargeImages]
        imageView.sd_setImage(with: imageURL, placeholderImage: UIImage(namedInBundle: "SoyouImagePlaceholder"), options: options, completed: { [weak self] image, _, _, _ in
            self?.activityIndicatorImageView.stopAnimating()
            guard let image = image else { return }
            guard image.size.width > 0, image.size.height > 0 else { return }
            let screenWidth = UIScreen.main.bounds.width
            let ratio = image.size.width / image.size.height
            let height = ChatMessageImageView.defaultHeight
            var width = height * ratio
            if width > screenWidth - 32 { // 32 is margin
                width = screenWidth - 32
            }
            self?.imageViewWidthConstraint.constant = width
            self?.imageViewHeightConstraint.constant = height
            self?.imageViewWidthConstraint.isActive = true
            self?.imageViewHeightConstraint.isActive = true
        })
    }

    @objc func didTapView() {
        if isLoadable {
            delegate?.openImageFromCell(attachment: attachment, thumbnail: imageView)
        } else {
            guard let imageURL = attachment.fullImageURL() else {
                return
            }
            Ask(key: "alert.insecure_image", buttonB: localized("chat.message.open_browser"), handlerB: { _ in
                ChatViewController.shared?.openURL(url: imageURL)
            }).present()
        }
    }
}
