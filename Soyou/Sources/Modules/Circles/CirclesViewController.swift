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
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnCompose: UIButton!
    @IBOutlet var btnMore: UIButton!
    // User Info
    @IBOutlet var parallaxHeaderView: UIView!
    @IBOutlet var imgUserAvatar: UIImageView!
    @IBOutlet var imgUserBadge: UIImageView!
    @IBOutlet var btnFollow: UIButton!
    @IBOutlet var lblFollowStatus: UILabel!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var imgBadge1: UIImageView!
    @IBOutlet var lblBadge1: UILabel!
    @IBOutlet var imgBadge2: UIImageView!
    @IBOutlet var lblBadge2: UILabel!
    @IBOutlet var followingFollowerContainer: UIView!
    @IBOutlet var btnFollowing: UIButton!
    @IBOutlet var btnFollower: UIButton!
    
    var userID: Int? {
        didSet {
            self.observeUserManager() // Start/Stop observing the app user's info
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
    
    // KVO
    fileprivate var KVOContextCirclesViewController = 0
    fileprivate var needsToRemoveObserver = false
    
    // Pull and reload
    var isLoadingData = false
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var loadingIndicatorBottom: NSLayoutConstraint!
    @IBOutlet var loadingIndicatorLeading: NSLayoutConstraint!
    
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
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UITabBarItem
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("circles_vc_tab_title"),
                                       image: UIImage(named: "img_tab_images"),
                                       selectedImage: UIImage(named: "img_tab_images_selected"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.all
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Clear old data
        if self.isSingleUserMode {
            DataManager.shared.memoryContext().save(blockAndWait: { (localContext: NSManagedObjectContext!) in
                Circle.mr_deleteAll(matching: FmtPredicate("1==1"), in: localContext)
            })
        }
        
        // Setup views
        self.setupViews()
        
        // Load Data
        self.loadData(nil)
        
        // Prepare FetchedResultsController
        self.reloadDataWithoutCompletion()
        
        // Observe UserManager.shared.token & avatar
        self.observeUserManager()
    }
    
    deinit {
        self.stopObservingUserManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Nav bar
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
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
            return Circle.mr_fetchAllGrouped(by: nil, with: nil, sortedBy: "createdDate", ascending: false, in: DataManager.shared.memoryContext())
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
    fileprivate func observeUserManager() {
        if self.userID == nil {
            UserManager.shared.addObserver(self, forKeyPath: "token", options: .new, context: &KVOContextCirclesViewController)
            UserManager.shared.addObserver(self, forKeyPath: "avatar", options: .new, context: &KVOContextCirclesViewController)
            self.needsToRemoveObserver = true
        } else {
            self.stopObservingUserManager()
        }
    }
    
    fileprivate func stopObservingUserManager() {
        if self.needsToRemoveObserver {
            self.needsToRemoveObserver = false
            UserManager.shared.removeObserver(self, forKeyPath: "token")
            UserManager.shared.removeObserver(self, forKeyPath: "avatar")
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &KVOContextCirclesViewController {
            // Update login status
            self.updateUserInfo(true)
            if keyPath == "token" && UserManager.shared.isLoggedIn {
                self.loadData(nil)
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

// MARK: - Load data
extension CirclesViewController {
    
    // MARK: Data
    func loadData(_ timestamp: String?) {
        guard UserManager.shared.isLoggedIn else {
            return
        }
        self.showLoadingMessage()
        let deleteAll = timestamp == nil
        let timestamp = timestamp ?? Cons.utcDateFormatter.string(from: Date())
        self.beginRefreshing()
        DataManager.shared.requestPreviousCicles(timestamp, deleteAll, self.userID, self.isSingleUserMode) { responseObject, error in
            if let responseObject = responseObject as? Dictionary<String, AnyObject>,
                let data = responseObject["data"] as? [NSDictionary] {
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
        }
    }
    
    func loadNextData() {
        if let lastCircle = self.fetchedResultsController?.fetchedObjects?.last as? Circle,
            let date = lastCircle.createdDate {
            self.loadData(Cons.utcDateFormatter.string(from: date))
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
        self.btnBack.isHidden = !self.isSingleUserMode
        self.btnCompose.isHidden = self.isSingleUserMode
        self.btnMore.isHidden = true//!self.isSingleUserMode
        self.loadingIndicatorLeading.constant = self.isSingleUserMode ? 64 : 24
        
        // Setup table
        self.tableView().rowHeight = UITableViewAutomaticDimension
        self.tableView().estimatedRowHeight = 75
        self.tableView().allowsSelection = false
        self.tableView().tableFooterView = UIView(frame: CGRect.zero)
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.tableView(), 0, false, false, false, !self.isSingleUserMode)
        
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
        self.btnFollow.isHidden = true
        self.btnFollow.layer.cornerRadius = 4
        self.btnFollow.clipsToBounds = true
        self.lblUsername.layer.shadowColor = UIColor(white: 0, alpha: 0.5).cgColor
        self.lblUsername.layer.shadowOpacity = 1
        self.lblUsername.layer.shadowRadius = 2
        self.lblUsername.layer.shadowOffset = CGSize.zero
        self.lblBadge1.layer.shadowColor = UIColor(white: 0, alpha: 0.5).cgColor
        self.lblBadge1.layer.shadowOpacity = 1
        self.lblBadge1.layer.shadowRadius = 2
        self.lblBadge1.layer.shadowOffset = CGSize.zero
        self.lblBadge2.layer.shadowColor = UIColor(white: 0, alpha: 0.5).cgColor
        self.lblBadge2.layer.shadowOpacity = 1
        self.lblBadge2.layer.shadowRadius = 2
        self.lblBadge2.layer.shadowOffset = CGSize.zero
        self.lblFollowStatus.layer.cornerRadius = 4
        self.lblFollowStatus.clipsToBounds = true
        self.followingFollowerContainer.isHidden = true
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
        // Update Status Bar Cover
        self.updateStatusBarCover(scrollView.contentOffset.y)
        // Update Pull Down Refresh Indicator
        self.updateRefreshIndicator(scrollView.contentOffset.y)
    }
}

// MARK: - Status Bar Cover
extension CirclesViewController {
    
    fileprivate func setupStatusBarCover() {
        // Status Bar Cover
        self.statusBarCover.backgroundColor = UIColor.white
    }
    
    fileprivate func updateStatusBarCover(_ offsetY: CGFloat) {
        if isStatusBarCoverVisible && offsetY < 0 {
            self.removeStatusBarCover()
        } else if !isStatusBarCoverVisible && offsetY >= 0 {
            self.addStatusBarCover()
        }
    }
    
    fileprivate func addStatusBarCover() {
        self.isStatusBarCoverVisible = true
        self.tabBarController?.view.addSubview(self.statusBarCover)
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
            self.statusBarCover.alpha = 1
        })
    }
    
    fileprivate func removeStatusBarCover() {
        self.isStatusBarCoverVisible = false
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
            self.statusBarCover.alpha = 0
        }, completion: { (finished) -> Void in
            self.statusBarCover.removeFromSuperview()
        })
    }
}

// MARK: - Pull Down Refresh
extension CirclesViewController {
    
    fileprivate func updateRefreshIndicator(_ offsetY: CGFloat) {
        struct Constant {
            static let headerHeight = CGFloat(240)
            static let triggerY = CGFloat(-40)
        }
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let offsetY = offsetY + statusBarHeight + Constant.headerHeight
        self.showRefreshIndicator(offsetY)
        
        if !self.isLoadingData && !self.tableView().isDragging && offsetY <= Constant.triggerY {
            self.loadData(nil)
        }
    }
    
    fileprivate func showRefreshIndicator(_ offsetY: CGFloat) {
        struct Constant {
            static let triggerY = CGFloat(-38)
        }
        UIView.animate(withDuration: 0.3) {
            if self.isLoadingData {
                self.loadingIndicatorBottom.constant = Constant.triggerY
            } else {
                self.loadingIndicatorBottom.constant = max(offsetY, Constant.triggerY)
                self.loadingIndicator.transform = CGAffineTransform(rotationAngle: offsetY / 20.0)
            }
        }
    }
    
    fileprivate func hideRefreshIndicator() {
        UIView.animate(withDuration: 0.3) {
            self.loadingIndicatorBottom.constant = UIApplication.shared.statusBarFrame.height
        }
    }
}

// MARK: - Refreshing
extension CirclesViewController {
    
    fileprivate func setupRefreshControls() {
        guard let footer = MJRefreshAutoStateFooter(refreshingBlock: { () -> Void in
            self.loadNextData()
        }) else { return }
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_idle"), for: .idle)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_pulling"), for: .pulling)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_refreshing"), for: .refreshing)
        footer.setTitle(NSLocalizedString("pull_to_refresh_no_more_data"), for: .noMoreData)
        self.tableView().mj_footer = footer
    }
    
    fileprivate func beginRefreshing() {
        self.isLoadingData = true
        self.loadingIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    fileprivate func endRefreshing(_ resultCount: Int) {
        self.hideRefreshIndicator()
        DispatchQueue.main.async {
            resultCount > 0 ? self.tableView().mj_footer.endRefreshing() : self.tableView().mj_footer.endRefreshingWithNoMoreData()
        }
        self.isLoadingData = false
        self.loadingIndicator.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func showNoDataMessage() {
        (self.tableView().mj_footer as? MJRefreshAutoStateFooter)?.setTitle(NSLocalizedString("circles_vc_no_data"), for: .noMoreData)
    }
    
    func showLoadingMessage() {
        (self.tableView().mj_footer as? MJRefreshAutoStateFooter)?.setTitle(NSLocalizedString("circles_vc_loading"), for: .idle)
        (self.tableView().mj_footer as? MJRefreshAutoStateFooter)?.setTitle(NSLocalizedString("circles_vc_loading"), for: .noMoreData)
    }
    
    func resetFooterMessage() {
        (self.tableView().mj_footer as? MJRefreshAutoStateFooter)?.setTitle(NSLocalizedString("pull_to_refresh_footer_idle"), for: .idle)
        (self.tableView().mj_footer as? MJRefreshAutoStateFooter)?.setTitle(NSLocalizedString("pull_to_refresh_no_more_data"), for: .noMoreData)
    }
}

// MARK: - Create a circle
extension CirclesViewController: CircleComposeViewControllerDelegate {
    
    @IBAction fileprivate func createCircle() {
        let vc = CircleComposeViewController.instantiate()
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        // Present
        self.tabBarController?.present(nav, animated: true, completion: nil)
    }
    
    func didPostNewCircle() {
        self.loadData(nil)
    }
    
    func didDismiss(text: String?, images: [UIImage]?, needsToShare: Bool) {
        if needsToShare {
            Utils.shareTextAndImagesToWeChat(from: self, text: text, images: images)
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
        
    }
    
    @IBAction func followingFollowerAction(_ sender: UIButton) {
        let vc = FollowersViewController.instantiate()
        vc.userID = self.isSingleUserMode ? self.userID : UserManager.shared.userID
        vc.isShowingFollowers = sender.tag == 1
        self.navigationController?.pushViewController(vc, animated: true)
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
        
        // Avatar
        self.removeAvatarBorder()
        let avatarURLString = (self.isSingleUserMode ? self.avatar : UserManager.shared.avatar) ?? ""
        if let url = URL(string: avatarURLString) {
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
        self.imgUserBadge.isHidden = true
        
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
                    // Update Follow/Unfollow button
                    if !isMyself, let friendStatus = data["friendStatus"] as? Int {
                        self.btnFollow.isHidden = false
                        // 1: current user is following userId
                        // 2: userId is following current user
                        // 3: both are following each other
                        let isFollowing = friendStatus & 1 == 1
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
                        let isFollower = friendStatus & 2 == 2
                        if isFollower {
                            self.lblFollowStatus.text = NSLocalizedString("circles_vc_user_follows_you")
                            self.lblFollowStatus.backgroundColor = UIColor(hex8: 0x829FC8FF)
                        } else {
                            self.lblFollowStatus.text = NSLocalizedString("circles_vc_user_not_follow_you")
                            self.lblFollowStatus.backgroundColor = UIColor(white: 0, alpha: 0.1)
                        }
                    } else {
                        self.btnFollow.isHidden = true
                    }
                    
                    // Update certifications
                    if let badges = data["badges"] as? [NSDictionary] {
                        for (i, badge) in badges.enumerated() {
                            let lblBadge = i == 0 ? self.lblBadge1 : self.lblBadge2
                            let imgBadge = i == 0 ? self.imgBadge1 : self.imgBadge2
                            guard let content = badge["content"] as? String, let type = badge["type"] as? String else {
                                continue
                            }
                            let stringFormat = type == "Sales" ? "circles_vc_user_certified_sales" : type == "Buyer" ? "circles_vc_user_certified_buyer" : ""
                            let badgeContent = FmtString(NSLocalizedString(stringFormat), content)
                            if badgeContent.isEmpty {
                                imgBadge?.isHidden = true
                                lblBadge?.isHidden = true
                            } else {
                                imgBadge?.isHidden = false
                                lblBadge?.isHidden = false
                                lblBadge?.text = badgeContent
                            }
                        }
                        self.imgUserBadge.isHidden = badges.count == 0
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
                }
            }
        }
    }
}

// MARK: - Parallax Header
extension CirclesViewController {

    fileprivate func setupParallaxHeader() {
        // Parallax View
        self.tableView().parallaxHeader.height = self.parallaxHeaderView.frame.height
        self.tableView().parallaxHeader.view = self.parallaxHeaderView
        self.tableView().parallaxHeader.mode = .fill
    }
}
