//
//  ChatViewController.swift
//  Rocket.Chat
//
//  Created by Rafael K. Streit on 7/21/16.
//  Copyright © 2016 Rocket.Chat. All rights reserved.
//

import RealmSwift
import SlackTextViewController
import SimpleImageViewer

// swiftlint:disable file_length type_body_length
public final class ChatViewController: SLKTextViewController {
    
    // Class methods
    public static let shared = UIStoryboard(name: "Chat", bundle: Bundle(for: ChatViewController.self)).instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController

    var activityIndicator: LoaderView!
    @IBOutlet weak var activityIndicatorContainer: UIView! {
        didSet {
            let width = activityIndicatorContainer.bounds.width
            let height = activityIndicatorContainer.bounds.height
            let frame = CGRect(x: 0, y: 0, width: width, height: height)
            let activityIndicator = LoaderView(frame: frame)
            activityIndicatorContainer.addSubview(activityIndicator)
            self.activityIndicator = activityIndicator
        }
    }

    @IBOutlet weak var buttonScrollToBottom: UIButton!
    var buttonScrollToBottomMarginConstraint: NSLayoutConstraint?

    var scrollToBottomButtonIsVisible: Bool = false {
        didSet {
            self.buttonScrollToBottom.superview?.layoutIfNeeded()

            if self.scrollToBottomButtonIsVisible {
                guard let collectionView = collectionView else {
                    scrollToBottomButtonIsVisible = false
                    return
                }
                let collectionViewBottom = collectionView.frame.origin.y + collectionView.frame.height
                self.buttonScrollToBottomMarginConstraint?.constant = (collectionViewBottom - view.frame.height) - 40
            } else {
                self.buttonScrollToBottomMarginConstraint?.constant = 50
            }

            if scrollToBottomButtonIsVisible != oldValue {
                UIView.animate(withDuration: 0.5) {
                    self.buttonScrollToBottom.superview?.layoutIfNeeded()
                }
            }
        }
    }

    weak var chatPreviewModeView: ChatPreviewModeView?
    weak var chatHeaderViewStatus: ChatHeaderViewStatus?
    var documentController: UIDocumentInteractionController?

    var replyView: ReplyView!
    var replyString: String = ""
    var messageToEdit: Message?

    var dataController = ChatDataController()

    var searchResult: [(String, Any)] = []
    var searchWord: String = ""

    var isRequestingHistory = false
    var isAppendingMessages = false
    var isVisible = false

    var subscriptionToken: NotificationToken?

    let socketHandlerToken = String.random(5)
    var messagesToken: NotificationToken!
    var messagesQuery: Results<Message>!
    var messages: [Message] = []

    var subscription: Subscription? {
        didSet {
            // clean up
            subscriptionToken?.invalidate()
            didCancelTextEditing(self)

            guard
                let subscription = subscription,
                !subscription.isInvalidated
            else {
                return
            }

            if !SocketManager.isConnected() {
                socketDidDisconnect(socket: SocketManager.sharedInstance)
                reconnect()
            }

            subscription.setTemporaryMessagesFailed()

            subscriptionToken = subscription.observe { [weak self] changes in
                switch changes {
                case .change(let propertyChanges):
                    propertyChanges.forEach {
                        if $0.name == "roomReadOnly" || $0.name == "roomMuted" {
                            self?.updateMessageSendingPermission()
                        }
                    }
                default:
                    break
                }
            }

            if let oldValue = oldValue {
                if oldValue.identifier != subscription.identifier {
                    emptySubscriptionState()
                }
            } else {
                emptySubscriptionState()
            }
            
            resetUnreadSeparator()

            updateSubscriptionInfo()
            typingIndicatorView?.dismissIndicator()

            if let oldValue = oldValue, oldValue.identifier != subscription.identifier {
                unsubscribe(for: oldValue)
            }

            textView.text = DraftMessageManager.draftMessage(for: subscription)
        }
    }
    
    public var username: String? {
        return self.subscription?.name
    }

    // MARK: View Life Cycle

    deinit {
        NotificationCenter.default.removeObserver(self)
        SocketManager.removeConnectionHandler(token: socketHandlerToken)
        messagesToken?.invalidate()
        subscriptionToken?.invalidate()
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
        registerCells()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.backgroundColor = .clear
        self.buttonScrollToBottom.setImage(UIImage(namedInBundle: "Arrow Down"), for: .normal)
        
        self.hidesBottomBarWhenPushed = true

        collectionView?.isPrefetchingEnabled = true
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.alwaysBounceVertical = true
        enableInteractiveKeyboardDismissal()

        isInverted = false
        bounces = true
        shakeToClearEnabled = true
        isKeyboardPanningEnabled = true
        shouldScrollToBottomAfterKeyboardShows = false

        leftButton.setImage(UIImage(namedInBundle: "Upload"), for: .normal)

        setupTextViewSettings()
        setupScrollToBottomButton()

        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.reconnect), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        SocketManager.addConnectionHandler(token: socketHandlerToken, handler: self)

        if !SocketManager.isConnected() {
            socketDidDisconnect(socket: SocketManager.sharedInstance)
            reconnect()
        } else {
            subscription = nil
        }

        view.bringSubview(toFront: activityIndicatorContainer)
        view.bringSubview(toFront: buttonScrollToBottom)
        view.bringSubview(toFront: textInputbar)

        if buttonScrollToBottomMarginConstraint == nil {
            buttonScrollToBottomMarginConstraint = buttonScrollToBottom.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 50)
            buttonScrollToBottomMarginConstraint?.isActive = true
        }

        setupReplyView()
        
        self.textInputbar.textView.keyboardType = .default
        self.textInputbar.textView.enablesReturnKeyAutomatically = false
    }

    override public func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        keyboardFrame?.updateFrame()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isVisible = true
        if subscription?.unread ?? 0 > 0 {
            markAsRead()
        }
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        isVisible = false
    }

    @objc internal func reconnect() {
        chatHeaderViewStatus?.labelTitle.text = localized("connection.connecting.banner.message")
        chatHeaderViewStatus?.activityIndicator.startAnimating()
        chatHeaderViewStatus?.buttonRefresh.isHidden = true

        if !SocketManager.isConnected() {
            SocketManager.reconnect()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            if !SocketManager.isConnected() {
                self.chatHeaderViewStatus?.labelTitle.text = localized("connection.offline.banner.message")
                self.chatHeaderViewStatus?.activityIndicator.stopAnimating()
                self.chatHeaderViewStatus?.buttonRefresh.isHidden = false
            }
        }
    }

    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        updateChatPreviewModeViewConstraints()
    }

    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: nil, completion: { _ in
            self.collectionView?.collectionViewLayout.invalidateLayout()
        })
    }

    fileprivate func setupTextViewSettings() {
        textView.registerMarkdownFormattingSymbol("*", withTitle: "Bold")
        textView.registerMarkdownFormattingSymbol("_", withTitle: "Italic")
        textView.registerMarkdownFormattingSymbol("~", withTitle: "Strike")
        textView.registerMarkdownFormattingSymbol("`", withTitle: "Code")
        textView.registerMarkdownFormattingSymbol("```", withTitle: "Preformatted")
        textView.registerMarkdownFormattingSymbol(">", withTitle: "Quote")

//        registerPrefixes(forAutoCompletion: ["@", "#", "/", ":"])
    }

    fileprivate func setupScrollToBottomButton() {
        buttonScrollToBottom.layer.cornerRadius = 25
        buttonScrollToBottom.layer.borderColor = UIColor.lightGray.cgColor
        buttonScrollToBottom.layer.borderWidth = 1
    }

    override public class func collectionViewLayout(for decoder: NSCoder) -> UICollectionViewLayout {
        return ChatCollectionViewFlowLayout()
    }

    fileprivate func registerCells() {
        typealias NibCellIndentifier = (nibName: String, cellIdentifier: String)

        let collectionViewCells: [NibCellIndentifier] = [
            (nibName: "ChatLoaderCell", cellIdentifier: ChatLoaderCell.identifier),
            (nibName: "ChatMessageCell", cellIdentifier: ChatMessageCell.identifier),
            (nibName: "ChatMessageDaySeparator", cellIdentifier: ChatMessageDaySeparator.identifier),
            (nibName: "ChatMessageUnreadSeparator", cellIdentifier: ChatMessageUnreadSeparator.identifier),
            (nibName: "ChatChannelHeaderCell", cellIdentifier: ChatChannelHeaderCell.identifier)//,
            //(nibName: "ChatDirectMessageHeaderCell", cellIdentifier: ChatDirectMessageHeaderCell.identifier)
        ]

        collectionViewCells.forEach {
            collectionView?.register(UINib(
                nibName: $0.nibName,
                bundle: Bundle(for: type(of: self))
            ), forCellWithReuseIdentifier: $0.cellIdentifier)
        }

        let autoCompletionViewCells: [NibCellIndentifier] = [
            (nibName: "AutocompleteCell", cellIdentifier: AutocompleteCell.identifier)
        ]

        autoCompletionViewCells.forEach {
            autoCompletionView.register(UINib(
                nibName: $0.nibName,
                bundle: Bundle(for: type(of: self))
            ), forCellReuseIdentifier: $0.cellIdentifier)
        }
    }

    internal func scrollToBottom(_ animated: Bool = false) {
        let boundsHeight = collectionView?.bounds.size.height ?? 0
        let sizeHeight = collectionView?.contentSize.height ?? 0
        let offset = CGPoint(x: 0, y: max(sizeHeight - boundsHeight, 0))
        collectionView?.setContentOffset(offset, animated: animated)
        scrollToBottomButtonIsVisible = false
    }

    internal func resetScrollToBottomButtonPosition() {
        scrollToBottomButtonIsVisible = !chatLogIsAtBottom()
    }

    func resetMessageSending() {
        textView.text = ""

        if let subscription = subscription {
            DraftMessageManager.update(draftMessage: "", for: subscription)
            SubscriptionManager.sendTypingStatus(subscription, isTyping: false)
        }
    }

    func resetUnreadSeparator() {
        dataController.dismissUnreadSeparator = true
        syncCollectionView()
        dataController.unreadSeparator = false
        dataController.dismissUnreadSeparator = false
        dataController.lastSeen = subscription?.lastSeen ?? Date()
    }

    // MARK: Handling Keyboard

    // keyboardHeightConstraint is the same as keyboardHC in SLKTextViewController
    weak var keyboardHeightConstraint: NSLayoutConstraint?
    weak var textInputbarBackgroundHeightConstraint: NSLayoutConstraint?

    var keyboardFrame: KeyboardFrameView?
    let textInputbarBackground = UIToolbar()
    var oldTextInputbarBgIsTransparent = false

    private func enableInteractiveKeyboardDismissal() {
        keyboardFrame = KeyboardFrameView(withDelegate: self)
    }

    // Enables for the interactive keyboard dismissal.
    // Gets called updateKeyboardConstraints(frame:) which is a
    // required method of the KeyboardFrameViewDelegate
    private func updateKeyboardConstraints(frame: CGRect) {
        if keyboardHeightConstraint == nil {
            keyboardHeightConstraint = self.view.constraints.first {
                ($0.firstItem as? UIView) == self.view &&
                    ($0.secondItem as? SLKTextInputbar) == self.textInputbar
            }
        }

        // Adding textInputBar background so that the app can support devices with safe area insets.
        // The tool bar (textInputBar) background sometimes dissapears on keyboard slide outs,
        // with no real fix for it provided by Apple in UIKit.
        updateTextInputbarBackground()

        var keyboardHeight = frame.height

        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardHeight > view.safeAreaInsets.bottom ? keyboardHeight : view.safeAreaInsets.bottom
        }

        keyboardHeightConstraint?.constant = keyboardHeight
    }

    private func updateTextInputbarBackground() {
        if #available(iOS 11.0, *) {
            if !textInputbar.subviews.contains(textInputbarBackground) {
                insertTextInputbarBackground()
            }

            // Making the old background for textInputView, transparent
            // after the safeAreaInsets are set. (Initially zero)
            // This helps improve the translucency effect of the bar.
            if !oldTextInputbarBgIsTransparent, view.safeAreaInsets.bottom > 0 {
                textInputbar.setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
                textInputbar.backgroundColor = UIColor.clear
                oldTextInputbarBgIsTransparent = true
            }

            if let textInputbarHC = textInputbarBackgroundHeightConstraint, textInputbarHC.constant != view.safeAreaInsets.bottom {
                textInputbarHC.constant = view.safeAreaInsets.bottom
            }
        }
    }

    private func insertTextInputbarBackground() {
        if #available(iOS 11.0, *) {
            textInputbar.insertSubview(textInputbarBackground, at: 0)
            textInputbarBackground.translatesAutoresizingMaskIntoConstraints = false

            textInputbarBackgroundHeightConstraint = textInputbarBackground.heightAnchor.constraint(equalTo: textInputbar.heightAnchor, multiplier: 1, constant: view.safeAreaInsets.bottom)
            textInputbarBackgroundHeightConstraint?.isActive = true

            textInputbarBackground.widthAnchor.constraint(equalTo: textInputbar.widthAnchor).isActive = true
            textInputbarBackground.topAnchor.constraint(equalTo: textInputbar.topAnchor).isActive = true
            textInputbarBackground.centerXAnchor.constraint(equalTo: textInputbar.centerXAnchor).isActive = true
        }
    }

    // MARK: SlackTextViewController

    override public func didPressRightButton(_ sender: Any?) {
        guard let messageText = textView.text else { return }

        CensorshipManager.censorThenDo(messageText) {
            self.resetMessageSending()
            self.scrollToBottom()
            
            let replyString = self.replyString
            self.stopReplying()
            
            self.dataController.dismissUnreadSeparator = true
            self.dataController.lastSeen = self.subscription?.lastSeen ?? Date()
            self.syncCollectionView()
            
            let text = "\(messageText)\(replyString)"
            
            if let (command, params) = text.commandAndParams() {
                self.sendCommand(command: command, params: params)
                return
            }
            
            self.sendTextMessage(text: text)
        }
    }

    override public func didCommitTextEditing(_ sender: Any) {
        if let messageToEdit = messageToEdit {
            editTextMessage(message: messageToEdit, text: textView.text)
        }

        resetMessageSending()
        messageToEdit = nil

        super.didCommitTextEditing(sender)
    }

    override public func didCancelTextEditing(_ sender: Any) {
        messageToEdit = nil
        super.didCancelTextEditing(sender)
    }

    override public func didPressLeftButton(_ sender: Any?) {
        buttonUploadDidPressed()
    }

    override public func didPressReturnKey(_ keyCommand: UIKeyCommand?) {
        if messageToEdit != nil {
            didCommitTextEditing(self)
        } else {
            didPressRightButton(self)
        }
    }

    override public func textViewDidChange(_ textView: UITextView) {
        guard let subscription = self.subscription else { return }

        DraftMessageManager.update(draftMessage: textView.text, for: subscription)

        if textView.text?.isEmpty ?? true {
            SubscriptionManager.sendTypingStatus(subscription, isTyping: false)
        } else {
            SubscriptionManager.sendTypingStatus(subscription, isTyping: true)
        }
    }

    @objc override public func keyboardWillShow(_ notification: Notification) {
        // Scroll to the bottom when the collectionView has scrolled more
        // than scrollToBottomHeightMultiplier times the view's height.
        let scrollToBottomHeightMultiplier: CGFloat = 1.2

        let contentHeight = collectionView?.contentSize.height ?? 0
        let contentOffset = collectionView?.contentOffset.y ?? 0
        if contentHeight - contentOffset < self.view.frame.height * scrollToBottomHeightMultiplier {
            scrollToBottom()
        }
    }

    // MARK: Message
    func sendCommand(command: String, params: String) {
        guard let subscription = subscription else { return }

        let client = API.current()?.client(CommandsClient.self)
        client?.runCommand(command: command, params: params, roomId: subscription.rid, errored: alertAPIError)
    }

    fileprivate func sendTextMessage(text: String) {
        guard
            let subscription = subscription,
            text.count > 0
        else {
            return
        }

        guard let client = API.current()?.client(MessagesClient.self) else { return Alert.defaultError.present() }
        client.sendMessage(text: text, subscription: subscription)
    }

    fileprivate func editTextMessage(message: Message, text: String) {
        guard let client = API.current()?.client(MessagesClient.self) else { return Alert.defaultError.present() }
        client.updateMessage(message, text: text)
    }

    fileprivate func updateCellForMessage(identifier: String) {
        guard let indexPath = self.dataController.indexPathOfMessage(identifier: identifier) else { return }

        UIView.performWithoutAnimation {
            collectionView?.reloadItems(at: [indexPath])
        }
    }

    fileprivate func chatLogIsAtBottom() -> Bool {
        guard let collectionView = collectionView else { return false }

        let height = collectionView.bounds.height
        let bottomInset = collectionView.contentInset.bottom
        let scrollContentSizeHeight = collectionView.contentSize.height
        let verticalOffsetForBottom = scrollContentSizeHeight + bottomInset - height

        return collectionView.contentOffset.y >= (verticalOffsetForBottom - 1)
    }

    // MARK: Subscription

    fileprivate func markAsRead() {
        guard let subscription = subscription else { return }
        if isVisible {
            SubscriptionManager.markAsRead(subscription) { _ in
                // Nothing, for now
            }
        }
    }

    internal func subscribe(for subscription: Subscription) {
        MessageManager.changes(subscription)
        MessageManager.subscribeDeleteMessage(subscription) { [weak self] msgId in
            self?.deleteMessage(msgId: msgId)
        }
        registerTypingEvent(subscription)
    }

    internal func unsubscribe(for subscription: Subscription) {
        SocketManager.unsubscribe(eventName: subscription.rid)
        SocketManager.unsubscribe(eventName: "\(subscription.rid)/typing")
        SocketManager.unsubscribe(eventName: "\(subscription.rid)/deleteMessage")
    }

    internal func emptySubscriptionState() {
        clearListData()
        updateJoinedView()

        activityIndicator?.startAnimating()
        textView.resignFirstResponder()
    }

    internal func updateJoinedView() {
        guard let subscription = subscription else { return }

        if subscription.isJoined() {
            setTextInputbarHidden(false, animated: false)
            chatPreviewModeView?.removeFromSuperview()
        } else {
            setTextInputbarHidden(true, animated: false)
            showChatPreviewModeView()
        }
    }

    internal func clearListData() {
        collectionView?.performBatchUpdates({
            let indexPaths = self.dataController.clear()
            self.collectionView?.deleteItems(at: indexPaths)
        }, completion: { _ in
            CATransaction.commit()
        })
    }

    internal func deleteMessage(msgId: String) {
        guard let collectionView = collectionView else { return }
        dataController.delete(msgId: msgId)
        collectionView.performBatchUpdates({
            collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
        })
        Realm.execute({ _ in
            Message.delete(withIdentifier: msgId)
        })
    }

    internal func updateSubscriptionInfo() {
        guard let subscription = subscription else { return }

        messagesToken?.invalidate()

        title = subscription.displayName().censored()

        if subscription.isValid() {
            updateSubscriptionMessages()
        } else {
            subscription.fetchRoomIdentifier({ [weak self] response in
                self?.subscription = response
            })
        }

        updateMessageSendingPermission()
    }

    internal func updateSubscriptionMessages() {
        guard let subscription = subscription else { return }

        messagesQuery = subscription.fetchMessagesQueryResults()

        dataController.loadedAllMessages = false
        isRequestingHistory = false

        updateMessagesQueryNotificationBlock()
        loadMoreMessagesFrom(date: nil)
        subscribe(for: subscription)
    }

    func registerTypingEvent(_ subscription: Subscription) {
        typingIndicatorView?.interval = 0
        guard let user = AuthManager.currentUser() else { return Log.debug("Could not register TypingEvent") }
        
        SubscriptionManager.subscribeTypingEvent(subscription) { [weak self] username, flag in
            // Make sure username (aka, uuid) isn't the same
            guard let username = username, username != user.username else { return }
            // Get display name
            let typingUser = Realm.shared?.objects(User.self).filter("username = %@", username).first
            let displayMame = typingUser?.displayName()
            
            let isAtBottom = self?.chatLogIsAtBottom()
            
            if flag {
                self?.typingIndicatorView?.insertUsername(displayMame)
            } else {
                self?.typingIndicatorView?.removeUsername(displayMame)
            }
            
            if let isAtBottom = isAtBottom,
                isAtBottom == true {
                self?.scrollToBottom(true)
            }
        }
    }

    fileprivate func updateMessagesQueryNotificationBlock() {
        messagesToken?.invalidate()
        messagesToken = messagesQuery.observe { [unowned self] changes in
            guard case .update(_, _, let insertions, let modifications) = changes else {
                return
            }

            if insertions.count > 0 {
                var newMessages: [Message] = []
                for insertion in insertions {
                    guard insertion < self.messagesQuery.count else { continue }
                    let newMessage = Message(value: self.messagesQuery[insertion])
                    newMessages.append(newMessage)
                }

                self.messages.append(contentsOf: newMessages)
                self.appendMessages(messages: newMessages, completion: {
                    self.markAsRead()
                })
            }

            if modifications.count > 0 {
                let isAtBottom = self.chatLogIsAtBottom()

                var indexPathModifications: [Int] = []

                for modified in modifications {
                    guard modified < self.messagesQuery.count else { continue }

                    let message = Message(value: self.messagesQuery[modified])
                    let index = self.dataController.update(message)

                    if index >= 0 && !indexPathModifications.contains(index) {
                        indexPathModifications.append(index)
                    }
                }

                if indexPathModifications.count > 0 {
                    guard let collectionView = self.collectionView else {
                        return
                    }
                    UIView.performWithoutAnimation {
                        collectionView.performBatchUpdates({
                            collectionView.reloadItems(at: indexPathModifications.map { IndexPath(row: $0, section: 0) })
                            collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
                        }, completion: { _ in
                            if isAtBottom {
                                self.scrollToBottom()
                            }
                        })
                    }
                }
            }
        }
    }

    func syncCollectionView() {
        collectionView?.performBatchUpdates({
            let (indexPaths, removedIndexPaths) = dataController.insert([])
            collectionView?.insertItems(at: indexPaths)
            collectionView?.deleteItems(at: removedIndexPaths)
        }, completion: nil)
    }

    func loadHistoryFromRemote(date: Date?) {
        guard let subscription = subscription else { return }

        let tempSubscription = Subscription(value: subscription)

        if date == nil {
            showLoadingMessagesHeaderStatusView()
        }

        MessageManager.getHistory(tempSubscription, lastMessageDate: date) { [weak self] messages in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()

                if date == nil {
                    self?.hideHeaderStatusView()
                }

                self?.isRequestingHistory = false
                self?.loadMoreMessagesFrom(date: date, loadRemoteHistory: false)

                if messages.count == 0 {
                    self?.dataController.loadedAllMessages = true
                    self?.syncCollectionView()
                } else {
                    self?.dataController.loadedAllMessages = false
                }
            }
        }
    }

    fileprivate func loadMoreMessagesFrom(date: Date?, loadRemoteHistory: Bool = true) {
        guard let subscription = subscription else { return }

        if isRequestingHistory || dataController.loadedAllMessages {
            return
        }

        isRequestingHistory = true

        let newMessages = subscription.fetchMessages(lastMessageDate: date).map({ Message(value: $0) })
        if newMessages.count > 0 {
            messages.append(contentsOf: newMessages)
            appendMessages(messages: newMessages, completion: { [weak self] in
                self?.activityIndicator.stopAnimating()

                if SocketManager.isConnected() {
                    if !loadRemoteHistory {
                        self?.isRequestingHistory = false
                    } else {
                        self?.loadHistoryFromRemote(date: date)
                    }
                } else {
                    self?.isRequestingHistory = false
                }
            })
        } else {
            if SocketManager.isConnected() {
                if loadRemoteHistory {
                    loadHistoryFromRemote(date: date)
                } else {
                    isRequestingHistory = false
                }
            } else {
                isRequestingHistory = false
            }
        }
    }

    fileprivate func appendMessages(messages: [Message], completion: VoidCompletion?) {
        guard
            let subscription = subscription,
            let collectionView = collectionView,
            !subscription.isInvalidated
        else {
            return
        }

        guard !isAppendingMessages else {
            Log.debug("[APPEND MESSAGES] Blocked trying to append \(messages.count) messages")

            // This message can be called many times during the app execution and we need
            // to call them one per time, to avoid adding the same message multiple times
            // to the list. Also, we keep the subscription identifier in order to make sure
            // we're updating the same subscription, because this view controller is reused
            // for all the chats.
            let oldSubscriptionIdentifier = subscription.identifier
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: { [weak self] in
                guard oldSubscriptionIdentifier == self?.subscription?.identifier else { return }
                self?.appendMessages(messages: messages, completion: completion)
            })

            return
        }

        isAppendingMessages = true

        var tempMessages: [Message] = []
        for message in messages {
            tempMessages.append(Message(value: message))
        }

        DispatchQueue.global(qos: .background).async {
            var objs: [ChatData] = []
            var newMessages: [Message] = []

            // Do not add duplicated messages
            for message in tempMessages {
                var insert = true

                for obj in self.dataController.data where message.identifier == obj.message?.identifier {
                    insert = false
                }

                if insert {
                    newMessages.append(message)
                }
            }

            // Normalize data into ChatData object
            for message in newMessages {
                guard let createdAt = message.createdAt else { continue }
                var obj = ChatData(type: .message, timestamp: createdAt)
                obj.message = message
                objs.append(obj)
            }

            // No new data? Don't update it then
            if objs.count == 0 {
                DispatchQueue.main.async {
                    self.isAppendingMessages = false
                    completion?()
                }

                return
            }

            DispatchQueue.main.async {
                collectionView.performBatchUpdates({
                    let (indexPaths, removedIndexPaths) = self.dataController.insert(objs)
                    collectionView.insertItems(at: indexPaths)
                    collectionView.deleteItems(at: removedIndexPaths)
                }, completion: { _ in
                    self.isAppendingMessages = false
                    completion?()
                })
            }
        }
    }

    fileprivate func showChatPreviewModeView() {
        chatPreviewModeView?.removeFromSuperview()

        if let previewView = ChatPreviewModeView.instantiateFromNib() {
            previewView.delegate = self
            previewView.subscription = subscription
            previewView.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(previewView)

            NSLayoutConstraint.activate([
                previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])

            collectionView?.bottomAnchor.constraint(equalTo: previewView.topAnchor).isActive = true

            chatPreviewModeView = previewView
            updateChatPreviewModeViewConstraints()
        }
    }

    private func updateChatPreviewModeViewConstraints() {
        if #available(iOS 11.0, *) {
            chatPreviewModeView?.bottomInset = view.safeAreaInsets.bottom
        }
    }

    fileprivate func isContentBiggerThanContainerHeight() -> Bool {
        if let contentHeight = self.collectionView?.contentSize.height {
            if let collectionViewHeight = self.collectionView?.frame.height {
                if contentHeight < collectionViewHeight {
                    return false
                }
            }
        }

        return true
    }

    // MARK: IBAction

    @IBAction func buttonScrollToBottomPressed(_ sender: UIButton) {
        scrollToBottom(true)
    }
}

// MARK: UICollectionViewDataSource

extension ChatViewController {

    override public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row < 4 {
            if let message = dataController.oldestMessage() {
                loadMoreMessagesFrom(date: message.createdAt)
            }
        }
    }

    override public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataController.data.count
    }

    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            dataController.data.count > indexPath.row,
            let subscription = subscription,
            let obj = dataController.itemAt(indexPath),
            !(obj.message?.isInvalidated ?? false)
        else {
            return UICollectionViewCell()
        }

        if obj.type == .message {
            return cellForMessage(obj, at: indexPath)
        }

//        if obj.type == .daySeparator {
//            return cellForDaySeparator(obj, at: indexPath)
//        }

        if obj.type == .unreadSeparator {
            return cellForUnreadSeparator(obj, at: indexPath)
        }

        if obj.type == .loader {
            return cellForLoader(obj, at: indexPath)
        }

//        if obj.type == .header {
//            if subscription.type == .directMessage {
//                return cellForDMHeader(obj, at: indexPath)
//            } else {
//                return cellForChannelHeader(obj, at: indexPath)
//            }
//        }

        return UICollectionViewCell()
    }

    // MARK: Cells

    func cellForMessage(_ obj: ChatData, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView?.dequeueReusableCell(
            withReuseIdentifier: ChatMessageCell.identifier,
            for: indexPath
        ) as? ChatMessageCell else {
            return UICollectionViewCell()
        }

        cell.delegate = self

        if let message = obj.message {
            cell.message = message
        }

        cell.sequential = obj.message?.isSequential ?? false
        cell.needsToShowDate = dataController.needsToShowDateAt(indexPath)
        
        return cell
    }

    func cellForDaySeparator(_ obj: ChatData, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView?.dequeueReusableCell(
            withReuseIdentifier: ChatMessageDaySeparator.identifier,
            for: indexPath
        ) as? ChatMessageDaySeparator else {
            return UICollectionViewCell()
        }

        cell.labelTitle.text = RCDateFormatter.date(obj.timestamp)
        return cell
    }

    func cellForUnreadSeparator(_ obj: ChatData, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView?.dequeueReusableCell(
            withReuseIdentifier: ChatMessageUnreadSeparator.identifier,
            for: indexPath
        ) as? ChatMessageUnreadSeparator else {
            return UICollectionViewCell()
        }

        cell.labelTitle.text = localized("chat.unread_separator")
        return cell
    }

    func cellForChannelHeader(_ obj: ChatData, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView?.dequeueReusableCell(
            withReuseIdentifier: ChatChannelHeaderCell.identifier,
            for: indexPath
        ) as? ChatChannelHeaderCell else {
            return UICollectionViewCell()
        }

        cell.subscription = subscription
        return cell
    }

//    func cellForDMHeader(_ obj: ChatData, at indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView?.dequeueReusableCell(
//            withReuseIdentifier: ChatDirectMessageHeaderCell.identifier,
//            for: indexPath
//        ) as? ChatDirectMessageHeaderCell else {
//            return UICollectionViewCell()
//        }
//        cell.subscription = subscription
//        return cell
//    }

    func cellForLoader(_ obj: ChatData, at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView?.dequeueReusableCell(
            withReuseIdentifier: ChatLoaderCell.identifier,
            for: indexPath
        ) as? ChatLoaderCell else {
            return UICollectionViewCell()
        }

        return cell
    }

}

// MARK: UICollectionViewDelegateFlowLayout

extension ChatViewController: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let subscription = subscription, !subscription.isInvalidated else {
            return .zero
        }

        var fullWidth = collectionView.bounds.size.width

        if #available(iOS 11, *) {
            fullWidth -= collectionView.safeAreaInsets.right + collectionView.safeAreaInsets.left
        }

        if let obj = dataController.itemAt(indexPath) {
//            if obj.type == .header {
//                if subscription.type == .directMessage {
//                    return CGSize(width: fullWidth, height: ChatDirectMessageHeaderCell.minimumHeight)
//                } else {
//                    return CGSize(width: fullWidth, height: ChatChannelHeaderCell.minimumHeight)
//                }
//            }

            if obj.type == .loader {
                return CGSize(width: fullWidth, height: ChatLoaderCell.minimumHeight)
            }

//            if obj.type == .daySeparator {
//                return CGSize(width: fullWidth, height: ChatMessageDaySeparator.minimumHeight)
//            }

            if obj.type == .unreadSeparator {
                if dataController.dismissUnreadSeparator {
                    return CGSize(width: fullWidth, height: 0)
                } else {
                    return CGSize(width: fullWidth, height: ChatMessageUnreadSeparator.minimumHeight)
                }
            }

            if let message = obj.message {
                guard !message.markedForDeletion else { return .zero }

                message.isSequential = dataController.hasSequentialMessageAt(indexPath)
                let height = ChatMessageCell.cellHeightFor(message: message, width: fullWidth, sequential: message.isSequential)
                return CGSize(width: fullWidth, height: height)
            }
        }

        return CGSize(width: fullWidth, height: 40)
    }
}

// MARK: UIScrollViewDelegate

extension ChatViewController {
    override public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        super.scrollViewDidScroll(scrollView)

        if scrollView.contentOffset.y < -10 {
            if let message = dataController.oldestMessage() {
                loadMoreMessagesFrom(date: message.createdAt)
            }
        }
        resetScrollToBottomButtonPosition()
    }
}

// MARK: ChatPreviewModeViewProtocol

extension ChatViewController: ChatPreviewModeViewProtocol {

    func userDidJoinedSubscription() {
        guard let auth = AuthManager.isAuthenticated() else { return }
        guard let subscription = self.subscription else { return }

        Realm.executeOnMainThread({ realm in
            subscription.auth = auth
            realm.add(subscription, update: true)
        })

        self.subscription = subscription

        updateJoinedView()
    }

}

// MARK: Block Message Sending

extension ChatViewController {

    fileprivate func updateMessageSendingPermission() {
        guard
            let subscription = subscription,
            let currentUser = AuthManager.currentUser()
        else {
            allowMessageSending()
            return
        }
        let username = currentUser.displayName()

        if subscription.roomReadOnly && subscription.roomOwner != currentUser && !currentUser.hasPermission(.postReadOnly) {
            blockMessageSending(reason: localized("chat.read_only"))
        } else if subscription.roomMuted.contains(username) {
            blockMessageSending(reason: localized("chat.muted"))
        } else {
            allowMessageSending()
        }
    }

    fileprivate func blockMessageSending(reason: String) {
        textInputbar.textView.placeholder = reason
        textInputbar.backgroundColor = .white
        textInputbar.isUserInteractionEnabled = false
        leftButton.isEnabled = false
        rightButton.isEnabled = false
    }

    fileprivate func allowMessageSending() {
        textInputbar.textView.placeholder = ""
        textInputbar.backgroundColor = .backgroundWhite
        textInputbar.isUserInteractionEnabled = true
        leftButton.isEnabled = true
        rightButton.isEnabled = true
    }

}

// MARK: Alerter
extension ChatViewController {
    func alertAPIError(_ error: APIError) {
        switch error {
        case .version(let available, let required):
            let message = String(format: localized("alert.unsupported_feature.message"), available.description, required.description)
            alert(
                title: localized("alert.unsupported_feature.title"),
                message: message
            )
        default:
            break
        }
    }
}

// MARK: KeyboardFrameViewDelegate

extension ChatViewController: KeyboardFrameViewDelegate {
    func keyboardDidChangeFrame(frame: CGRect?) {
        if let frame = frame {
            updateKeyboardConstraints(frame: frame)
        }
        resetScrollToBottomButtonPosition()
    }

    var keyboardProxyView: UIView? {
        return textInputbar.inputAccessoryView.superview
    }
}
