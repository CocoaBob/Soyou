//
//  CirclesViewController.swift
//  Soyou
//
//  Created by CocoaBob on 2018-01-02.
//  Copyright © 2018 Soyou. All rights reserved.
//

class CirclesViewController: SyncedFetchedResultsViewController {
    
    // Properties
    @IBOutlet var _tableView: UITableView!
    // Nav Buttons
    @IBOutlet var btnScan: UIButton!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnCompose: UIButton!
    @IBOutlet var btnMore: UIButton!
    // User Info
    @IBOutlet var parallaxHeaderView: UIView!
    @IBOutlet var imgUserAvatar: UIImageView!
    @IBOutlet var imgUserBadge: UIImageView!
    @IBOutlet var btnMessage: UIButton!
    @IBOutlet var lblMessageStatus: UILabel!
    @IBOutlet var btnFollow: UIButton!
    @IBOutlet var lblFollowStatus: UILabel!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var imgGender: UIImageView!
    @IBOutlet var imgBadge: UIImageView!
    @IBOutlet var lblBadge: UILabel!
    @IBOutlet var followingFollowerContainer: UIView!
    @IBOutlet var btnFollowing: UIButton!
    @IBOutlet var btnFollower: UIButton!
    
    var userID: Int? {
        didSet {
            self.isSingleUserMode = userID != nil // Update UI
        }
    }
    var avatar: String? // If it's isSingleUserMode
    var username: String? // If it's isSingleUserMode
    // If isSingleUserMode is true, it shows circles of a particular user,
    // and the loaded circles are stored in the memory context
    var isSingleUserMode: Bool = false {
        didSet {
            self.hidesBottomBarWhenPushed = self.isSingleUserMode
            self.setupViews()
        }
    }
    var _singleUserMemCtx: NSManagedObjectContext?
    func singleUserMemCtx() -> NSManagedObjectContext {
        if let ctx = _singleUserMemCtx {
            return ctx
        } else {
            let inMemoryStoreCoordinator = NSPersistentStoreCoordinator.mr_coordinatorWithInMemoryStore()
            let ctx = NSManagedObjectContext.mr_context(with: inMemoryStoreCoordinator)
            _singleUserMemCtx = ctx
            return ctx
        }
    }
    
    // User Settings
    var isInvisibleToHim = false
    var isInvisibleToMe = false
    
    // Recommendations
    @IBOutlet var recommendationsCollectionView: UICollectionView!
    var recommendations: [Member]? {
        didSet {
            self.updateRecommendations()
        }
    }
    
    // KVO Context
    fileprivate var KVOContextCirclesViewController = 0
    
    // Pull and reload
    var isLoadingData = false
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var loadingIndicatorBottom: NSLayoutConstraint!
    
    // Status Bar Cover
    var isStatusBarCoverVisible = false
    let statusBarCover = UIView(frame:
        CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: Cons.UI.statusBarHeight)
    )
    
    // Class methods
    class func instantiate(_ userID: Int?, _ avatar: String?, _ username: String?) -> CirclesViewController {
        let vc = UIStoryboard(name: "CirclesViewController", bundle: nil).instantiateViewController(withIdentifier: "CirclesViewController") as! CirclesViewController
        vc.userID = userID
        vc.avatar = avatar
        vc.username = username
        return vc
    }
    
    class func pushNewInstance(_ userID: Int?, _ avatar: String?, _ username: String?, from navC: UINavigationController?) {
        navC?.pushViewController(CirclesViewController.instantiate(userID, avatar, username), animated: true)
    }
    
    deinit {
        self.stopObservingUserManager()
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UITabBarItem
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("circles_vc_tab_title"),
                                       image: UIImage(named: "img_tab_images"),
                                       selectedImage: UIImage(named: "img_tab_images_selected"))
        
        // Observe UserManager.shared.token & avatar
        self.startObservingUserManager()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Clear old data
        if self.isSingleUserMode {
            self.clearAllCirclesOfCurrentUser()
        }
        
        // Setup views
        self.setupViews()
        
        // Load data from server
        self.loadData(nil, completion: nil)
        
        // Create FetchedResultsController and load data
        self.reloadDataWithoutCompletion()
        
        // Observe UIApplicationDidBecomeActive to update circles
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CirclesViewController.checkNewCircles),
                                               name: Notification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Nav bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        super.viewWillAppear(animated)
        
        // Hide tool bar
        self.hideToolbar(false)
        
        // Update User Info
        self.updateUserInfo(false)
        
        // Don't show again after dismissing login view
        if self.presentedViewController == nil {
            // If not logged in, show login view
            UserManager.shared.loginOrDo(nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Workaround to make sure navigation bar is updated even the slide-back gesture is cancelled.
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
        // Update Status Bar Cover
        self.updateStatusBarCover(self.tableView().contentOffset.y)
        
        // Check if there's newer data
        self.checkNewCircles()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Update Status Bar Cover
        self.removeStatusBarCover()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if UIDevice.isX() {
            return UIStatusBarStyle.default
        } else {
            return isStatusBarCoverVisible ? UIStatusBarStyle.default : UIStatusBarStyle.lightContent
        }
    }
}

// MARK: - Override SyncedFetchedResultsViewController
extension CirclesViewController {
    
    override func createFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult>? {
        if self.isSingleUserMode {
            return Circle.mr_fetchAllGrouped(by: nil, with: nil, sortedBy: "createdDate", ascending: false, in: self.singleUserMemCtx())
        } else {
            return Circle.mr_fetchAllGrouped(by: nil, with: nil, sortedBy: "createdDate", ascending: false)
        }
    }
    
    override func tableView() -> UITableView {
        return _tableView
    }
    
    override func tableViewRowIsAnimated() -> Bool {
        return false
    }
}

// MARK: - User Info Update
extension CirclesViewController {
    
    // Observe UserManager.shared.token & avatar
    fileprivate func startObservingUserManager() {
        UserManager.shared.addObserver(self, forKeyPath: "isLoggedIn", options: .new, context: &KVOContextCirclesViewController)
        UserManager.shared.addObserver(self, forKeyPath: "avatar", options: .new, context: &KVOContextCirclesViewController)
        UserManager.shared.addObserver(self, forKeyPath: "username", options: .new, context: &KVOContextCirclesViewController)
    }
    
    fileprivate func stopObservingUserManager() {
        UserManager.shared.removeObserver(self, forKeyPath: "isLoggedIn", context: &KVOContextCirclesViewController)
        UserManager.shared.removeObserver(self, forKeyPath: "avatar", context: &KVOContextCirclesViewController)
        UserManager.shared.removeObserver(self, forKeyPath: "username", context: &KVOContextCirclesViewController)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &KVOContextCirclesViewController {
            guard self.isViewLoaded else { return }
            // Update user info
            self.updateUserInfo(true)
            // Show/Hide all user related controls
            if keyPath == "isLoggedIn" {
                if UserManager.shared.isLoggedIn {
                    self.loadData(nil, completion: nil)
                } else {
                    self.hideUserInfoRelatedControls()
                    self.recommendations = nil
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

// MARK: - Load data
extension CirclesViewController {
    
    // MARK: Data
    func loadData(_ timestamp: String?, completion: (() -> Void)?) {
        guard UserManager.shared.isLoggedIn else {
            return
        }
        self.showLoadingMessage()
        let isRefresh = timestamp == nil
        let timestamp = timestamp ?? Cons.utcDateFormatter.string(from: Date())
        self.beginRefreshing()
        DataManager.shared.requestPreviousCicles(timestamp, isRefresh, self.userID, self.isSingleUserMode ? self.singleUserMemCtx() : nil) { responseObject, error in
            if let responseObject = responseObject as? Dictionary<String, AnyObject>,
                let data = responseObject["data"] as? [NSDictionary] {
                if isRefresh {
                    self.hideRedDot()
                }
                self.endRefreshing(data.count)
                if data.count == 0 {
                    self.showNoDataMessage()
                } else {
                    self.resetFooterMessage()
                }
            } else {
                self.endRefreshing(0)
                self.showNoDataMessage()
            }
            completion?()
        }
        if isSingleUserMode {
            self.recommendations = nil
            self.updateUserInfo(false)
        } else {
            DataManager.shared.getRecommendation { (response, error) in
                if let response = response,
                    let data = DataManager.getResponseData(response) as? [NSDictionary] {
                    self.recommendations = Member.newList(dicts: data)
                }
            }
        }
    }
    
    func loadNextData() {
        if let lastCircle = self.fetchedResultsController?.fetchedObjects?.last as? Circle,
            let date = lastCircle.createdDate {
            // We need to avoid scrolling during the loading of new data
            // to make is smooth, otherwise the scroll view may jump the contentOffset position
            // 1. Stop scrolling
            self.tableView().setContentOffset(self.tableView().contentOffset, animated: false)
            // 2. Stop pan gesture
            self.tableView().panGestureRecognizer.isEnabled = false
            // 3. Load data
            self.loadData(Cons.utcDateFormatter.string(from: date)) {
                // 4. Enable pan gesture
                self.tableView().panGestureRecognizer.isEnabled = true
            }
        }
    }
}

// MARK: - Views
extension CirclesViewController {
    
    fileprivate func setupViews() {
        // Make sure all IBOutlets aren't nil
        guard self.isViewLoaded else {
            return
        }
        
        // UIViewController
        self.title = NSLocalizedString("circles_vc_title")
        
        // Nav buttons
        self.btnScan.isHidden = self.isSingleUserMode
        self.btnBack.isHidden = !self.isSingleUserMode
        self.btnCompose.isHidden = self.isSingleUserMode
        let isMyself = userID == UserManager.shared.userID ?? 0
        self.btnMore.isHidden = !self.isSingleUserMode || isMyself
        
        // Setup table
        self.tableView().rowHeight = UITableViewAutomaticDimension
        self.tableView().estimatedRowHeight = 75
        self.tableView().allowsSelection = false
        self.tableView().tableFooterView = UIView(frame: CGRect.zero)
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.tableView(), 0, false, false, false, !self.isSingleUserMode)
        
        // Yield for the edge swipe gesture
        if let popGestureRecognizer = self.navigationController?.interactivePopGestureRecognizer {
            self.tableView().panGestureRecognizer.require(toFail: popGestureRecognizer)
        }
        
        // Avoid adjustedContentInset
        if #available(iOS 11.0, *) {
            self.recommendationsCollectionView.contentInsetAdjustmentBehavior = .never
        }
        
        // Hide recommendations when there's no data at beginning
        self.updateRecommendations()
        
        // Status Bar Cover
        self.setupStatusBarCover()
        
        // Parallax Header
        self.setupParallaxHeader()
        
        // Setup refresh controls
        self.setupRefreshControls()
        
        // Loading Indicator
        self.hideRefreshIndicator()
        
        // Setup avatar action
        self.imgUserAvatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CirclesViewController.avatarAction)))
        self.lblUsername.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CirclesViewController.avatarAction)))
        
        // User Info related
        self.btnMessage.layer.cornerRadius = 4
        self.btnMessage.clipsToBounds = true
        self.btnMessage.setTitle(NSLocalizedString("circles_vc_user_btn_message"), for: .normal)
        self.lblMessageStatus.backgroundColor = UIColor(white: 0, alpha: 0.1)
        self.lblMessageStatus.layer.cornerRadius = 4
        self.lblMessageStatus.clipsToBounds = true
        self.btnFollow.layer.cornerRadius = 4
        self.btnFollow.clipsToBounds = true
        self.lblFollowStatus.layer.cornerRadius = 4
        self.lblFollowStatus.clipsToBounds = true
        self.lblUsername.layer.shadowColor = UIColor(white: 0, alpha: 0.5).cgColor
        self.lblUsername.layer.shadowOpacity = 1
        self.lblUsername.layer.shadowRadius = 2
        self.lblUsername.layer.shadowOffset = CGSize.zero
        self.lblBadge.layer.shadowColor = UIColor(white: 0, alpha: 0.5).cgColor
        self.lblBadge.layer.shadowOpacity = 1
        self.lblBadge.layer.shadowRadius = 2
        self.lblBadge.layer.shadowOffset = CGSize.zero
        self.followingFollowerContainer.layer.shadowColor = UIColor(white: 0, alpha: 0.5).cgColor
        self.followingFollowerContainer.layer.shadowOpacity = 1
        self.followingFollowerContainer.layer.shadowRadius = 2
        self.followingFollowerContainer.layer.shadowOffset = CGSize.zero
        self.btnFollowing.backgroundColor = UIColor(white: 0, alpha: 0.1)
        self.btnFollowing.clipsToBounds = true
        self.btnFollowing.layer.cornerRadius = 4
        self.btnFollower.backgroundColor = UIColor(white: 0, alpha: 0.1)
        self.btnFollower.clipsToBounds = true
        self.btnFollower.layer.cornerRadius = 4
        self.hideUserInfoRelatedControls()
    }
    
    func hideUserInfoRelatedControls() {
        self.imgUserBadge.isHidden = true
        self.btnMessage.isHidden = true
        self.lblMessageStatus.isHidden = true
        self.btnFollow.isHidden = true
        self.lblFollowStatus.isHidden = true
        self.imgGender.isHidden = true
        self.imgBadge.isHidden = true
        self.lblBadge.isHidden = true
        self.followingFollowerContainer.isHidden = true
        self.tableView().mj_footer.isHidden = true
    }
}

// MARK: - Table View DataSource & Delegate
extension CirclesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CirclesTableViewCell", for: indexPath)
        if let cell = cell as? CirclesTableViewCell {
            cell.parentViewController = self
            cell.circle = self.fetchedResultsController?.object(at: indexPath) as? Circle
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView != self.tableView() {
            return
        }
        // Update Status Bar Cover
        self.updateStatusBarCover(scrollView.contentOffset.y)
        // Update Pull Down Refresh Indicator
        self.updateRefreshIndicator(scrollView.contentOffset.y)
    }
}

// MARK: - Create a circle
extension CirclesViewController: CircleComposeViewControllerDelegate {
    
    @IBAction fileprivate func createCircle() {
        let vc = CircleComposeViewController.instantiate()
        vc.delegate = self
        vc.isPublicDisabled = false
        let navC = UINavigationController(rootViewController: vc)
        // Present
        self.present(navC, animated: true, completion: nil)
    }
    
    func didPostNewCircle() {
        self.showRedDot()
    }
    
    func didDismiss(text: String?, images: [UIImage]?, needsToShare: Bool) {
        if needsToShare {
            Utils.copyTextAndShareImages(from: self, text: text, images: images)
        }
    }
}

// MARK: - Actions
extension CirclesViewController {
    
    @objc fileprivate func avatarAction() {
        UserManager.shared.loginOrDo() { () -> () in
            if self.userID == nil {
                CirclesViewController.pushNewInstance(UserManager.shared.userID, UserManager.shared.avatar, UserManager.shared.username, from: self.navigationController)
            } else {
                if self.avatar != nil, let image = self.imgUserAvatar.image {
                    IDMPhotoBrowser.present([IDMPhoto(image: image)], index: 0, view: self.imgUserAvatar, scaleImage: image, viewVC: self)
                }
            }
        }
    }
    
    @IBAction func messageAction(_ sender: UIButton) {
        guard let userID = self.userID else { return }
        RocketChatManager.openDirectMessage(from: self, userID: userID)
    }
    
    @IBAction func followAction(_ sender: UIButton) {
        guard let userID = self.userID else { return }
        sender.isEnabled = false
        MBProgressHUD.show(self.view)
        if sender.tag == 1 {
            DataManager.shared.unfollowFriend(userID) { responseObject, error in
                MBProgressHUD.hide(self.view)
                self.updateUserInfo(false)
                sender.isEnabled = true
            }
        } else {
            DataManager.shared.followFriend(userID) { responseObject, error in
                MBProgressHUD.hide(self.view)
                self.updateUserInfo(false)
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func moreAction() {
        guard let userID = self.userID else { return }
        let vc = CircleSettingsViewController.instantiate()
        vc.userID = userID
        vc.isInvisibleToHim = self.isInvisibleToHim
        vc.isInvisibleToMe = self.isInvisibleToMe
        vc.completionHandler = { isInvisibleToHim, isInvisibleToMe in
            if isInvisibleToMe { // Hide all circles
                self.clearAllCirclesOfCurrentUser()
            } else if self.isInvisibleToMe { // All circles were invisible, now load them to show
                self.loadData(nil, completion: nil)
            }
            self.isInvisibleToHim = isInvisibleToHim
            self.isInvisibleToMe = isInvisibleToMe
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func followingFollowerAction(_ sender: UIButton) {
        let vc = MembersViewController.instantiate()
        vc.userID = self.isSingleUserMode ? self.userID : UserManager.shared.userID
        vc.isShowingFollowers = sender.tag == 1
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func scanQRCode() {
        Utils.shared.showScanViewController(self)
    }
}

// MARK: - User Info
extension CirclesViewController {
    
    fileprivate func addAvatarBorder() {
        self.imgUserAvatar.layer.borderWidth = 1
        self.imgUserAvatar.layer.borderColor = UIColor.white.cgColor
    }
    
    fileprivate func removeAvatarBorder() {
        self.imgUserAvatar.layer.borderWidth = 0
    }
    
    fileprivate func updateUserInfo(_ reloadAvatar: Bool) {
        let isLoggedIn = UserManager.shared.isLoggedIn
        
        // Tableview's footer
        self.tableView().mj_footer.isHidden = !isLoggedIn
        
        // Avatar
        self.removeAvatarBorder()
        let avatarURLString = (self.isSingleUserMode ? self.avatar : UserManager.shared.avatar) ?? ""
        if isLoggedIn, let url = URL(string: avatarURLString) {
            var options: SDWebImageOptions = [.continueInBackground, .allowInvalidSSLCertificates, .highPriority]
            if reloadAvatar {
                options = [.refreshCached, .continueInBackground, .allowInvalidSSLCertificates, .highPriority]
            }
            self.imgUserAvatar.sd_setImage(with: url,
                                           placeholderImage: UserManager.shared.defaultAvatarImage(),
                                           options: options,
                                           completed: { (image, error, type, url) -> Void in
                                            if error == nil {
                                                self.addAvatarBorder()
                                            }
            })
        } else {
            self.imgUserAvatar.image = UserManager.shared.defaultAvatarImage()
        }
        
        // User name
        let currUsername = self.isSingleUserMode ? self.username : (UserManager.shared.username ?? NSLocalizedString("user_vc_username_unknown"))
        self.lblUsername.text = currUsername
        
        // Buttons
        self.btnCompose.isEnabled = isLoggedIn
        
        if isLoggedIn, let userID = self.userID ?? UserManager.shared.userID {
            // Check if it's the user self
            let isMyself = userID == UserManager.shared.userID ?? 0
            // Load User Info
            DataManager.shared.getUserInfo(userID) { response, error in
                if let response = response as? Dictionary<String, AnyObject>, let data = response["data"] as? [String: AnyObject] {
                    var isFollowing = false
                    var isFollower = false
                    // Update Follow/Unfollow button
                    if !isMyself, let friendStatus = data["friendStatus"] as? Int {
                        if let chatVC = ChatViewController.shared,
                            let navVCs = self.navigationController?.viewControllers,
                            navVCs.contains(chatVC) {
                            self.btnMessage.isHidden = true
                            self.lblMessageStatus.isHidden = true
                        } else {
                            self.btnMessage.isHidden = false
                            self.lblMessageStatus.isHidden = false
                        }
                        self.btnFollow.isHidden = false
                        self.lblFollowStatus.isHidden = false
                        // 0: no friend status specified
                        // 1: current user is following userId
                        // 2: userId is following current user
                        // 3: both are following each other
                        isFollowing = friendStatus & 1 == 1
                        if isFollowing {
                            self.btnFollow.backgroundColor = UIColor(hex8: 0xD4514CFF)
                            self.btnFollow.layer.borderColor = UIColor.clear.cgColor
                            self.btnFollow.layer.borderWidth = 0
                            self.btnFollow.setTitleColor(UIColor.white, for: .normal)
                            self.btnFollow.setTitle(NSLocalizedString("circles_vc_user_unfollow"), for: .normal)
                            self.btnFollow.tag = 1
                        } else {
                            self.btnFollow.backgroundColor = UIColor(white: 0, alpha: 0.05)
                            self.btnFollow.layer.borderColor = UIColor(hex8: 0xA3C8FAFF).cgColor
                            self.btnFollow.layer.borderWidth = 1
                            self.btnFollow.setTitleColor(UIColor(hex8: 0xA3C8FAFF), for: .normal)
                            self.btnFollow.setTitle(NSLocalizedString("circles_vc_user_follow"), for: .normal)
                            self.btnFollow.tag = 0
                        }
                        isFollower = friendStatus & 2 == 2
                        if isFollower {
                            self.lblFollowStatus.text = NSLocalizedString("circles_vc_user_follows_you")
                            self.lblFollowStatus.backgroundColor = UIColor(hex8: 0x829FC8FF)
                        } else {
                            self.lblFollowStatus.text = NSLocalizedString("circles_vc_user_not_follow_you")
                            self.lblFollowStatus.backgroundColor = UIColor(white: 0, alpha: 0.1)
                        }
                    } else {
                        self.btnMessage.isHidden = true
                        self.lblMessageStatus.isHidden = true
                        self.btnFollow.isHidden = true
                        self.lblFollowStatus.isHidden = true
                    }
                    
                    // Update Message button based on the following/follower status
                    let isMessageButtonEnabled = isFollowing || isFollower
                    if isMessageButtonEnabled {
                        self.btnMessage.isEnabled = true
                        self.btnMessage.backgroundColor = UIColor(hex8: 0x19AD19FF)
                        self.btnMessage.setTitleColor(UIColor.white, for: .normal)
                        self.lblMessageStatus.text = NSLocalizedString("circles_vc_user_tap_to_message")
                    } else {
                        self.btnMessage.isEnabled = false
                        self.btnMessage.backgroundColor = UIColor(white: 0, alpha: 0.05)
                        self.btnMessage.setTitleColor(UIColor(white: 0, alpha: 0.33), for: .normal)
                        self.lblMessageStatus.text = NSLocalizedString("circles_vc_user_follow_to_message")
                    }
                    
                    // Update certifications
                    UserManager.shared.hasCurrentUserBadges = false
                    if let badges = data["badges"] as? [NSDictionary] {
                        var badgeString = ""
                        for badge in badges {
                            if let content = badge["content"] as? String {
                                if badgeString.count > 0 {
                                    badgeString.append(NSLocalizedString("circles_vc_user_badge_separator"))
                                }
                                badgeString.append(content)
                            }
                        }
                        let badgeContent = FmtString(NSLocalizedString("circles_vc_user_certified"), badgeString)
                        if badgeString.isEmpty {
                            self.imgBadge.isHidden = true
                            self.lblBadge.isHidden = true
                        } else {
                            self.imgBadge.isHidden = false
                            self.lblBadge.isHidden = false
                            self.lblBadge.text = badgeContent
                        }
                        if let badge = badges.first {
                            UserManager.shared.hasCurrentUserBadges = true
                            self.imgUserBadge.isHidden = false
                            self.imgUserBadge.image = Member.badgeImage(badge["id"] as? Int, "l")
                            self.imgBadge.image = Member.badgeImage(badge["id"] as? Int, "s")
                        } else {
                            self.imgUserBadge.isHidden = true
                        }
                    } else {
                        self.imgUserBadge.isHidden = true
                    }
                    
                    // Update Following/Follower numbers
                    if (isMyself || !self.isSingleUserMode),
                        let followingCount = data["followingCount"] as? Int,
                        let followerCount = data["followerCount"] as? Int {
                        self.btnFollowing.setTitle(FmtString(NSLocalizedString("circles_vc_user_following"), followingCount), for: .normal)
                        self.btnFollower.setTitle(FmtString(NSLocalizedString("circles_vc_user_follower"), followerCount), for: .normal)
                        self.followingFollowerContainer.isHidden = false
                    } else {
                        self.followingFollowerContainer.isHidden = true
                    }
                    
                    // Update Gender
                    if let gender = data["gender"] as? String {
                        if gender == "\(Cons.Usr.genderMale)" {
                            self.imgGender.isHidden = false
                            self.imgGender.image = UIImage(named: "img_gender_male")
                        } else if gender == "\(Cons.Usr.genderFemale)" {
                            self.imgGender.isHidden = false
                            self.imgGender.image = UIImage(named: "img_gender_female")
                        } else {
                            self.imgGender.isHidden = true
                        }
                    } else {
                        self.imgGender.isHidden = true
                    }
                    
                    // Get block info
                    if !isMyself, let blockStatus = data["blockStatus"] as? Int {
                        // 0: no blockStatus is specified
                        // 1: current user won't see target user's circle
                        // 2: current user want target user to see its circle
                        // 3: both 1 and 2
                        self.isInvisibleToHim = blockStatus == 2 || blockStatus == 3
                        self.isInvisibleToMe = blockStatus == 1 || blockStatus == 3
                    }
                }
            }
        }
    }
}
