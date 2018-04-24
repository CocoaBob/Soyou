//
//  ChatTextCell.swift
//  Rocket.Chat
//
//  Created by Rafael K. Streit on 7/25/16.
//  Copyright © 2016 Rocket.Chat. All rights reserved.
//

import UIKit

protocol ChatMessageCellProtocol: ChatMessageURLViewProtocol, ChatMessageVideoViewProtocol, ChatMessageImageViewProtocol, ChatMessageTextViewProtocol {
    func openURL(url: URL)
    func handleLongPressMessageCell(_ message: Message, view: UIView, recognizer: UIGestureRecognizer)
    func handleUsernameTapMessageCell(_ message: Message, view: UIView, recognizer: UIGestureRecognizer)
}

final class ChatMessageCell: UICollectionViewCell {
    
    static let minimumHeight = CGFloat(55)
    static let identifier = "ChatMessageCell"

    weak var longPressGesture: UILongPressGestureRecognizer?
    weak var usernameTapGesture: UITapGestureRecognizer?
    weak var avatarTapGesture: UITapGestureRecognizer?
    weak var delegate: ChatMessageCellProtocol? {
        didSet {
            labelText.delegate = delegate
        }
    }

    var message: Message! {
        didSet {
            if oldValue != nil && oldValue.identifier == message?.identifier {
                if oldValue.updatedAt?.timeIntervalSince1970 == message.updatedAt?.timeIntervalSince1970 {
                    Log.debug("message is cached")
                    return
                }
            }

            updateMessage()
        }
    }

    @IBOutlet weak var avatarViewContainer: UIView! {
        didSet {
            avatarViewContainer.layer.cornerRadius = 18
            if let avatarView = AvatarView.instantiateFromNib() {
                avatarView.frame = avatarViewContainer.bounds
                avatarViewContainer.addSubview(avatarView)
                self.avatarView = avatarView
            }
        }
    }

    weak var avatarView: AvatarView! {
        didSet {
            avatarView.layer.cornerRadius = 18
            avatarView.layer.masksToBounds = true
        }
    }

    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelUsername: UILabel!
    @IBOutlet weak var labelText: RCTextView!

    @IBOutlet weak var statusView: UIImageView!
    @IBOutlet weak var messageBackgroundView: UIImageView!

    @IBOutlet weak var mediaViews: UIStackView!
    @IBOutlet weak var mediaViewsHeightConstraint: NSLayoutConstraint!

    private func isAddingReaction(emoji tappedEmoji: String) -> Bool {
        guard let currentUser = AuthManager.currentUser()?.username else {
            return false
        }

        if message.reactions.first(where: { $0.emoji == tappedEmoji && $0.usernames.contains(currentUser) }) != nil {
            return false
        }

        return true
    }

    static func cellHeightFor(message: Message, width: CGFloat, sequential: Bool = true) -> CGFloat {
        let fullWidth = width
        let attributedString = MessageTextCacheManager.shared.message(for: message)
        var total = (CGFloat)(sequential ? 0 : 31) // Date
        total += 0 // Name
        total += message.reactions.count > 0 ? 40 : 0
        if attributedString?.string ?? "" != "" {
            let textView = UITextView()
            textView.attributedText = attributedString
            let maxWidth = fullWidth - 73 - 12 - 14
            let textViewHeight = textView.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)).height
            total += ceil(textViewHeight)
        }

        for url in message.urls {
            guard url.isValid() else { continue }
            total += ChatMessageURLView.defaultHeight
        }

        for attachment in message.attachments {
            let type = attachment.type

            if type == .textAttachment {
                total += ChatMessageTextView.heightFor(collapsed: attachment.collapsed, withText: attachment.text, isFile: attachment.isFile)
            }

            if type == .image {
                total += ChatMessageImageView.heightFor(withText: attachment.descriptionText)
            }

            if type == .video {
                total += ChatMessageVideoView.heightFor(withText: attachment.descriptionText)
            }

            if type == .audio {
                total += ChatMessageAudioView.heightFor(withText: attachment.descriptionText)
            }

            if !attachment.collapsed {
                attachment.fields.forEach {
                    total += ChatMessageTextView.heightFor(collapsed: false, withText: $0.value)
                }
            }
        }
        
        total += 14 // Bottom margin to the next cell
        
        // Make sure total height >= avatar size
        let minHeight = (CGFloat)(sequential ? 50 : 81) // AvatarSize (36+14) : AvatarSize+Date (36+14+31)
        if total < minHeight { // Avatar size
            total = minHeight
        }

        return total
    }

    // MARK: Sequential
    @IBOutlet weak var labelDateMarginTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelDateHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelDateMarginBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelUsernameHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarContainerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var messageTopMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageBottomMarginConstraint: NSLayoutConstraint!
    @IBOutlet var messageLeftMarginConstraint: NSLayoutConstraint!
    @IBOutlet var messageRightMarginConstraint: NSLayoutConstraint!
    @IBOutlet var messageLeftFixConstraint: NSLayoutConstraint!
    @IBOutlet var messageRightFixConstraint: NSLayoutConstraint!
    @IBOutlet var messageWidthConstraint: NSLayoutConstraint!
    @IBOutlet var messageHeightConstraint: NSLayoutConstraint!
    @IBOutlet var avatarLeadingConstraint: NSLayoutConstraint!
    @IBOutlet var avatarTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mediaLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var mediaTrailingConstraint: NSLayoutConstraint!

    var sequential: Bool = false {
        didSet {
            labelDateMarginTopConstraint.constant = sequential ? 0 : 5
            labelDateHeightConstraint.constant = sequential ? 0 : 21
            labelDateMarginBottomConstraint.constant = sequential ? 0 : 5
            labelUsernameHeightConstraint.constant = 0
            avatarContainerHeightConstraint.constant = 36
        }
    }
    
    var isMyMessage: Bool = false {
        didSet {
            labelUsernameHeightConstraint.constant = 0
            avatarLeadingConstraint.isActive = !isMyMessage
            avatarTrailingConstraint.isActive = isMyMessage
            mediaLeadingConstraint.constant = isMyMessage ? 8 : 48
            mediaTrailingConstraint.constant = isMyMessage ? 48 : 8
            messageLeftMarginConstraint.constant = isMyMessage ? 12 : 14
            messageRightMarginConstraint.constant = isMyMessage ? 14 : 12
            messageLeftFixConstraint.isActive = !isMyMessage
            messageRightFixConstraint.isActive = isMyMessage
        }
    }

    override func prepareForReuse() {
        labelUsername.text = ""
        labelText.message = nil
        labelDate.text = ""
        sequential = false
        message = nil
        isMyMessage = false

        avatarView.prepareForReuse()
        
        for view in mediaViews.arrangedSubviews {
            mediaViews.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateMessageConstraints()
    }

    func insertGesturesIfNeeded() {
        if longPressGesture == nil {
            let gesture = UILongPressGestureRecognizer(target: self, action: #selector(ChatMessageCell.handleLongPressMessageCell(recognizer:)))
            gesture.minimumPressDuration = 0.325
            gesture.delegate = self
            addGestureRecognizer(gesture)

            longPressGesture = gesture
        }

        if usernameTapGesture == nil {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(ChatMessageCell.handleUsernameTapGestureCell(recognizer:)))
            gesture.delegate = self
            labelUsername.addGestureRecognizer(gesture)

            usernameTapGesture = gesture
        }

        if avatarTapGesture == nil {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(ChatMessageCell.handleUsernameTapGestureCell(recognizer:)))
            gesture.delegate = self
            avatarView.addGestureRecognizer(gesture)

            avatarTapGesture = gesture
        }
    }

    func insertURLs() -> CGFloat {
        var addedHeight = CGFloat(0)
        message.urls.forEach { url in
            guard url.isValid() else { return }
            if let view = ChatMessageURLView.instantiateFromNib() {
                view.url = url
                view.delegate = delegate

                mediaViews.addArrangedSubview(view)
                addedHeight += ChatMessageURLView.defaultHeight
            }
        }
        return addedHeight
    }

    func insertAttachments() {
        var mediaViewHeight = CGFloat(0)

        mediaViewHeight += insertURLs()

        message.attachments.forEach { attachment in
            let type = attachment.type

            switch type {
            case .textAttachment:
                if let view = ChatMessageTextView.instantiateFromNib() {
                    view.viewModel = ChatMessageTextViewModel(withAttachment: attachment)
                    view.delegate = delegate
                    view.translatesAutoresizingMaskIntoConstraints = false

                    mediaViews.addArrangedSubview(view)
                    mediaViewHeight += ChatMessageTextView.heightFor(collapsed: attachment.collapsed, withText: attachment.text, isFile: attachment.isFile)

                    if !attachment.collapsed {
                        attachment.fields.forEach {
                            guard let view = ChatMessageTextView.instantiateFromNib() else { return }
                            view.viewModel = ChatMessageAttachmentFieldViewModel(withAttachment: attachment, andAttachmentField: $0)
                            mediaViews.addArrangedSubview(view)
                            mediaViewHeight += ChatMessageTextView.heightFor(collapsed: false, withText: $0.value)
                        }
                    }
                }

            case .image:
                if let view = ChatMessageImageView.instantiateFromNib() {
                    view.attachment = attachment
                    view.delegate = delegate
                    view.translatesAutoresizingMaskIntoConstraints = false

                    mediaViews.addArrangedSubview(view)
                    mediaViewHeight += ChatMessageImageView.heightFor(withText: attachment.descriptionText)
                }

            case .video:
                if let view = ChatMessageVideoView.instantiateFromNib() {
                    view.attachment = attachment
                    view.delegate = delegate
                    view.translatesAutoresizingMaskIntoConstraints = false

                    mediaViews.addArrangedSubview(view)
                    mediaViewHeight += ChatMessageVideoView.heightFor(withText: attachment.descriptionText)
                }

            case .audio:
                if let view = ChatMessageAudioView.instantiateFromNib() {
                    view.attachment = attachment
                    view.translatesAutoresizingMaskIntoConstraints = false

                    mediaViews.addArrangedSubview(view)
                    mediaViewHeight += ChatMessageAudioView.heightFor(withText: attachment.descriptionText)
                }

            default:
                return
            }
        }

        mediaViewsHeightConstraint.constant = CGFloat(mediaViewHeight)
    }

    fileprivate func updateMessageHeader() {
        if let createdAt = message.createdAt {
            labelDate.text = RCDateFormatter.time(createdAt)
        }

        avatarView.user = message.user

        if let avatar = message.avatar {
            avatarView.avatarURL = URL(string: avatar)
        }

        if message.alias.count > 0 {
            labelUsername.text = message.alias
        } else {
            labelUsername.text = message.user?.displayName() ?? "Unknown"
        }
    }

    fileprivate func updateMessageContent() {
        if let text = MessageTextCacheManager.shared.message(for: message) {
            if message.temporary {
                text.setFontColor(MessageTextFontAttributes.systemFontColor)
            }

            if message.failed {
                text.setFontColor(MessageTextFontAttributes.failedFontColor)
            }

            if text.length > 0 {
                messageTopMarginConstraint.constant = 9
                messageBottomMarginConstraint.constant = 9
            } else {
                messageTopMarginConstraint.constant = 0
                messageBottomMarginConstraint.constant = 0
            }
            labelText.message = text
            updateMessageConstraints()
        }
    }
    
    fileprivate func updateMessageConstraints() {
        // Calculate text size
        let maxWidth = self.frame.width - 73 - 12 - 14
        let textSize = labelText.sizeToFitWidth(maxWidth)
        messageWidthConstraint.constant = textSize.width
        messageHeightConstraint.constant = textSize.height
    }

    fileprivate func updateMessage() {
        guard
            delegate != nil,
            let message = message
        else {
            return
        }

        switch (message.failed, message.temporary) {
        case (true, _):
            statusView.isHidden = false
            statusView.image = UIImage(namedInBundle: "Exclamation")?.withRenderingMode(.alwaysTemplate)
            statusView.tintColor = .red
        case (false, true):
            statusView.isHidden = false
            statusView.image = UIImage(namedInBundle: "Clock")?.withRenderingMode(.alwaysTemplate)
            statusView.tintColor = .gray
        case (false, false):
            statusView.isHidden = true
        }

        if !sequential {
            updateMessageHeader()
        }
        
        isMyMessage = message.user?.identifier == AuthManager.currentUser()?.identifier
        messageBackgroundView.image = UIImage(namedInBundle: isMyMessage ? "ChatBackgroundMe" : "ChatBackgroundOther")

        updateMessageContent()
        insertGesturesIfNeeded()
        insertAttachments()
    }

    @objc func handleLongPressMessageCell(recognizer: UIGestureRecognizer) {
        delegate?.handleLongPressMessageCell(message, view: contentView, recognizer: recognizer)
    }

    @objc func handleUsernameTapGestureCell(recognizer: UIGestureRecognizer) {
        delegate?.handleUsernameTapMessageCell(message, view: contentView, recognizer: recognizer)
    }

}

extension ChatMessageCell: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

}

// MARK: Accessibility

extension ChatMessageCell {

    override func awakeFromNib() {
        super.awakeFromNib()

        isAccessibilityElement = true
    }

    override var accessibilityIdentifier: String? {
        get { return "message" }
        set { }
    }

    override var accessibilityLabel: String? {
        get { return message?.accessibilityLabel }
        set { }
    }

    override var accessibilityValue: String? {
        get { return message?.accessibilityValue }
        set { }
    }

    override var accessibilityHint: String? {
        get { return message?.accessibilityHint }
        set { }
    }

}
