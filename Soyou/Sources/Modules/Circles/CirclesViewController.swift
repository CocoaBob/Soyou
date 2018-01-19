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
    @IBOutlet var imgViewAvatar: UIImageView!
    @IBOutlet var parallaxHeaderView: UIView!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var btnCompose: UIButton!
    
    // Pull and reload
    var isLoadingData = false
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var loadingIndicatorBottom: NSLayoutConstraint!
    
    // Status Bar Cover
    var isStatusBarCoverVisible = false
    let statusBarCover = UIView(frame:
        CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: Cons.UI.statusBarHeight)
    )
    
    // Notification Context
    fileprivate var KVOContextCirclesViewController = 0
    
    // Class methods
    class func instantiate() -> CirclesViewController {
        return UIStoryboard(name: "CirclesViewController", bundle: nil).instantiateViewController(withIdentifier: "CirclesViewController") as! CirclesViewController
    }
    
    // Override SyncedFetchedResultsViewController
    override func createFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult>? {
        return Circle.mr_fetchAllGrouped(by: nil, with: nil, sortedBy: "createdDate", ascending: false)
    }
    
    override func tableView() -> UITableView {
        return _tableView
    }
    
    override func tableViewRowIsAnimated() -> Bool {
        return false
    }
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UITabBarItem
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("circles_vc_tab_title"),
                                       image: UIImage(named: "img_tab_images"),
                                       selectedImage: UIImage(named: "img_tab_images_selected"))
        
        // Bars
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = UIRectEdge.all
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = false
        
        // UIViewController
        self.title = NSLocalizedString("circles_vc_title")
        
        // Navigation Bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "img_camera_selected"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(CirclesViewController.createCircle))
        
        // Setup table
        self.tableView().rowHeight = UITableViewAutomaticDimension
        self.tableView().estimatedRowHeight = 75
        self.tableView().allowsSelection = false
        self.tableView().tableFooterView = UIView(frame: CGRect.zero)
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.tableView(), 0, false, false, false, true)
        
        // Status Bar Cover
        self.setupStatusBarCover()
        
        // Parallax Header
        self.setupParallaxHeader()
        
        // Setup refresh controls
        self.setupRefreshControls()
        
        // Loading Indicator
        self.hideRefreshIndicator()
        
        // Setup avatar action
        self.imgViewAvatar.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CirclesViewController.avatarAction)))
        self.lblUsername.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UserViewController.avatarAction)))

        // Username shadow
        self.lblUsername.layer.shadowColor = UIColor(white: 0, alpha: 0.5).cgColor
        self.lblUsername.layer.shadowOpacity = 1
        self.lblUsername.layer.shadowRadius = 2
        self.lblUsername.layer.shadowOffset = CGSize.zero
        
        // Load Data
        self.loadData(nil)
        
        // Prepare FetchedResultsController
        self.reloadDataWithoutCompletion()
        
        // Observe UserManager.shared.token
        UserManager.shared.addObserver(self, forKeyPath: "token", options: .new, context: &KVOContextCirclesViewController)
        UserManager.shared.addObserver(self, forKeyPath: "avatar", options: .new, context: &KVOContextCirclesViewController)
    }
    
    deinit {
        UserManager.shared.removeObserver(self, forKeyPath: "token")
        UserManager.shared.removeObserver(self, forKeyPath: "avatar")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        
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
        
        // Workaround to make sure navigation bar is visible even the slide-back gesture is cancelled.
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        
        // Update Status Bar Cover
        self.updateStatusBarCover(self._tableView.contentOffset.y)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Update Status Bar Cover
        self.removeStatusBarCover()
        // Make sure interactive gesture's delegate is nil before disappearing
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if UIDevice.isX() {
            return UIStatusBarStyle.default
        } else {
            return isStatusBarCoverVisible ? UIStatusBarStyle.default : UIStatusBarStyle.lightContent
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
        let deleteAll = timestamp == nil
        let timestamp = timestamp ?? Cons.utcDateFormatter.string(from: Date())
        self.beginRefreshing()
        DataManager.shared.requestPreviousCicles(timestamp, deleteAll, nil) { responseObject, error in
            if let responseObject = responseObject as? Dictionary<String, AnyObject>,
                let data = responseObject["data"] as? [NSDictionary] {
                self.endRefreshing(data.count)
            } else {
                self.endRefreshing(0)
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

// MARK: Table View
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
            cell.viewController = self
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

// MARK: Status Bar Cover
extension CirclesViewController {
    
    fileprivate func setupStatusBarCover() {
        // Status Bar Cover
        self.statusBarCover.backgroundColor = UIColor.white
    }
    
    fileprivate func updateStatusBarCover(_ offsetY: CGFloat) {
        if !isStatusBarCoverVisible && offsetY >= 0 {
            self.addStatusBarCover()
        } else if isStatusBarCoverVisible && offsetY < 0 {
            self.removeStatusBarCover()
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

// MARK: Pull Down Refresh
extension CirclesViewController {
    
    func updateRefreshIndicator(_ offsetY: CGFloat) {
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
    
    func showRefreshIndicator(_ offsetY: CGFloat) {
        struct Constant {
            static let triggerY = CGFloat(-40)
        }
        UIView.animate(withDuration: 0.3) {
            if self.isLoadingData {
                self.loadingIndicatorBottom.constant = Constant.triggerY
            } else {
                self.loadingIndicatorBottom.constant = max(offsetY, Constant.triggerY)
            }
        }
    }
    
    func hideRefreshIndicator() {
        UIView.animate(withDuration: 0.3) {
            self.loadingIndicatorBottom.constant = UIApplication.shared.statusBarFrame.height
        }
    }
}

// MARK: - Refreshing
extension CirclesViewController {
    
    func setupRefreshControls() {
        guard let footer = MJRefreshAutoStateFooter(refreshingBlock: { () -> Void in
            self.loadNextData()
        }) else { return }
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_idle"), for: .idle)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_pulling"), for: .pulling)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_refreshing"), for: .refreshing)
        footer.setTitle(NSLocalizedString("pull_to_refresh_no_more_data"), for: .noMoreData)
        self.tableView().mj_footer = footer
    }
    
    func beginRefreshing() {
        self.isLoadingData = true
        self.loadingIndicator.startAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func endRefreshing(_ resultCount: Int) {
        self.hideRefreshIndicator()
        DispatchQueue.main.async {
            resultCount > 0 ? self.tableView().mj_footer.endRefreshing() : self.tableView().mj_footer.endRefreshingWithNoMoreData()
        }
        self.isLoadingData = false
        self.loadingIndicator.stopAnimating()
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

// Create a circle
extension CirclesViewController: CircleComposeViewControllerDelegate {
    
    @IBAction func createCircle() {
        let vc = CircleComposeViewController.instantiate()
        vc.delegate = self
        let navController = UINavigationController(rootViewController: vc)
        self.tabBarController?.present(navController, animated: true, completion: nil)
    }
    
    func didPostNewCircle() {
        self.loadData(nil)
    }
    
    func didDismiss(text: String?, images: [UIImage]?, needsToShare: Bool) {
        if needsToShare {
            self.shareTextAndImages(text: text, images: images)
        }
    }
}

// MARK: Share to WeChat
extension CirclesViewController {
    
    func shareTextAndImages(text: String?, images: [UIImage]?) {
        if text?.count ?? 0 > 0 || images?.count ?? 0 > 0 {
            MBProgressHUD.show(self.view)
            Utils.shareToWeChat(from: self, images: images, completion: { (succeed) -> Void in
                MBProgressHUD.hide(self.view)
                if succeed {
                    if let text = text, text.count > 0 {
                        UIPasteboard.general.string = text
                        if let window = UIApplication.shared.keyWindow  {
                            let hud = MBProgressHUD.showAdded(to: window, animated: true)
                            hud.isUserInteractionEnabled = false
                            hud.mode = .text
                            hud.label.text = NSLocalizedString("circle_compose_share_to_wechat_copied")
                            hud.hide(animated: true, afterDelay: 3)
                        }
                    }
                }
            })
        }
    }
}

// Actions
extension CirclesViewController {
    
    @objc func avatarAction() {
        UserManager.shared.loginOrDo() { () -> () in
            let vc = ProfileViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .custom
            // Setup Transition Animator
            vc.loadViewIfNeeded()
            vc.setupTransitionAnimator(modalVC: nav)
            nav.transitioningDelegate = vc.transitionAnimator
            // Present
            self.present(nav, animated: true, completion: nil)
        }
    }
}

// Avatar
extension CirclesViewController {
    
    func addAvatarBorder() {
        self.imgViewAvatar.layer.borderWidth = 1
        self.imgViewAvatar.layer.borderColor = UIColor.white.cgColor
    }
    
    func removeAvatarBorder() {
        self.imgViewAvatar.layer.borderWidth = 0
    }
    
    func updateUserInfo(_ reload: Bool) {
        self.removeAvatarBorder()
        if let url = URL(string: UserManager.shared.avatar ?? "") {
            var options: SDWebImageOptions = [.continueInBackground, .allowInvalidSSLCertificates, .highPriority]
            if reload {
                options = [.refreshCached, .continueInBackground, .allowInvalidSSLCertificates, .highPriority]
            }
            self.imgViewAvatar.sd_setImage(with: url,
                                           placeholderImage: UserManager.shared.defaultAvatarImage(),
                                           options: options,
                                           completed: { (image, error, type, url) -> Void in
                                            if error == nil {
                                                self.addAvatarBorder()
                                            }
            })
        } else {
            self.imgViewAvatar.image = UserManager.shared.defaultAvatarImage()
        }
        self.lblUsername.text = UserManager.shared.username ?? NSLocalizedString("user_vc_username_unknown")
        
        // Update controls
        self.btnCompose.isEnabled = UserManager.shared.isLoggedIn
        self._tableView.mj_footer.isHidden = !UserManager.shared.isLoggedIn
    }
}

// MARK: Parallax Header
extension CirclesViewController {

    fileprivate func setupParallaxHeader() {
        // Parallax View
        self.tableView().parallaxHeader.height = self.parallaxHeaderView.frame.height
        self.tableView().parallaxHeader.view = self.parallaxHeaderView
        self.tableView().parallaxHeader.mode = .fill
    }
}

// MARK: - CirclesTableViewCell
class CirclesTableViewCell: UITableViewCell {
    
    var circle: Circle? {
        didSet {
            self.imgURLs = circle?.images as? [[String:String]]
            self.configureCell()
        }
    }
    var imgURLs: [[String: String]]?
    var textToShare: String?
    var imagesToShare: [UIImage]?
    weak var viewController: CirclesViewController?
    
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var lblName: MarginLabel!
    @IBOutlet var lblContent: MarginLabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnForward: UIButton!
    
    @IBOutlet var btnMoreLess: UIButton!
    @IBOutlet var btnMoreLessHeight: NSLayoutConstraint!
    @IBOutlet var lblContentHeight: NSLayoutConstraint!
    
    @IBOutlet var imagesCollectionView: CircleImagesCollectionView!
    @IBOutlet var imagesCollectionViewWidth: NSLayoutConstraint?
    @IBOutlet var imagesCollectionViewContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupViews()
        self.setupCollectionView()
        self.prepareForReuse()
    }
    
    func setupViews() {
        self.btnDelete.setTitle(NSLocalizedString("circles_vc_delete_button"), for: .normal)
        self.btnForward.setTitle(NSLocalizedString("circles_vc_forward_button"), for: .normal)
        let wechatColor = UIColor(hex8: 0x00bb0cFF)
        self.btnForward.setTitleColor(wechatColor, for: .normal)
//        self.btnForward.layer.borderWidth = 1
//        self.btnForward.layer.borderColor = wechatColor.cgColor
//        self.btnForward.layer.cornerRadius = 4
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgURLs = nil
        self.imgUser.sd_cancelCurrentImageLoad()
        self.imgUser.image = nil
        self.lblName.text = nil
        self.lblContent.text = nil
        self.btnDelete.isHidden = true
        self.imagesCollectionView.reloadData()
        self.resetMoreLessControl()
        self.updateMoreLessControl()
    }
}

// MARK: - Configure Cell
extension CirclesTableViewCell {
    
    func configureCell() {
        guard let circle = self.circle else {
            return
        }
        self.configureProfileImage(circle)
        self.configureLabels(circle)
        self.configureImagesCollectionView(circle)
        self.btnDelete.isHidden = UserManager.shared.userID != (circle.userId as? Int)
    }
    
    func configureProfileImage(_ circle: Circle) {
        if let str = circle.userProfileUrl, let url = URL(string: str) {
            self.imgUser.sd_setImage(with: url,
                                     placeholderImage: UIImage(named: "img_placeholder_1_1_s"),
                                     options: [.continueInBackground, .allowInvalidSSLCertificates, .highPriority])
        } else {
            self.imgUser.image = UIImage(named: "img_placeholder_1_1_s")
        }
    }
    
    func configureLabels(_ circle: Circle) {
        self.lblName.text = circle.username ?? ""
        self.lblContent.text = circle.text
        self.updateMoreLessControl()
        if let date = circle.createdDate {
            self.lblDate.text = DateFormatter.localizedString(from: date,
                                                              dateStyle: DateFormatter.Style.medium,
                                                              timeStyle: DateFormatter.Style.short)
        } else {
            self.lblDate.text = nil
        }
    }
    
    func configureImagesCollectionView(_ circle: Circle) {
        guard let imgURLs = self.imgURLs else {
            return
        }
        if let constraint = self.imagesCollectionViewWidth {
            self.imagesCollectionViewContainer.removeConstraint(constraint)
        }
        var ratio = CGFloat(1)
        if imgURLs.count == 1 {
            ratio *= 0.5
        } else if imgURLs.count == 4 {
            ratio *= 2.0 / 3.0
        }
        let constraint = NSLayoutConstraint(item: self.imagesCollectionView,
                                            attribute: .width,
                                            relatedBy: .equal,
                                            toItem: self.imagesCollectionViewContainer,
                                            attribute: .width,
                                            multiplier: ratio,
                                            constant: 0)
        self.imagesCollectionViewContainer.addConstraint(constraint)
        self.imagesCollectionViewWidth = constraint
        self.imagesCollectionView.reloadData()
        self.imagesCollectionView.collectionViewLayout.invalidateLayout() // Update layout
//        if let tableView = self.viewController?.tableView() {
//            UIView.setAnimationsEnabled(false)
//            tableView.beginUpdates()
//            tableView.endUpdates()
//            UIView.setAnimationsEnabled(true)
//        }
    }
}

// MARK: - CollectionView Delegate & DataSource
extension CirclesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imgURLs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleImageCollectionViewCell",
                                                      for: indexPath)
        if let cell = cell as? CircleImageCollectionViewCell {
            if let dict = self.imgURLs?[indexPath.row] {
                var imageURL: URL?
                if let thumbnailStr = dict["thumbnail"], let thumbnailURL = URL(string: thumbnailStr) {
                    imageURL = thumbnailURL
                }
                cell.imageView.sd_setImage(with: imageURL,
                                           placeholderImage: UIImage(named: "img_placeholder_1_1_s"),
                                           options: [.continueInBackground, .allowInvalidSSLCertificates, .highPriority],
                                           completed: { (image, error, type, url) -> Void in
                                            // Update the image with an animation
                                            if (collectionView.indexPathsForVisibleItems.contains(indexPath)) {
                                                if let image = image {
                                                    UIView.transition(with: cell.imageView,
                                                                      duration: 0.3,
                                                                      options: UIViewAnimationOptions.transitionCrossDissolve,
                                                                      animations: { cell.imageView.image = image },
                                                                      completion: nil)
                                                }
                                            }
                })
            } else {
                cell.imageView.image = UIImage(named: "img_placeholder_1_1_s")
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let imageView = (collectionView.cellForItem(at: indexPath) as? CircleImageCollectionViewCell)?.imageView else {
            return
        }
        var image: UIImage?
        if let dict = self.imgURLs?[indexPath.row],
            let str = dict["original"],
            let url = URL(string: str),
            let cachedImage = SDImageCache.shared().imageFromCache(forKey: SDWebImageManager.shared().cacheKey(for: url)) {
            image = cachedImage
        } else if let dict = self.imgURLs?[indexPath.row],
            let str = dict["thumbnail"],
            let url = URL(string: str),
            let cachedImage = SDImageCache.shared().imageFromCache(forKey: SDWebImageManager.shared().cacheKey(for: url)) {
            image = cachedImage
        }
        self.browseImages(imageView, image, UInt(indexPath.row))
    }
}

// MARK: - CollectionView Waterfall Layout
extension CirclesTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        // Create a flow layout
        let layout = UICollectionViewLeftAlignedLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.sectionInset = UIEdgeInsets.zero
        
        // Add the waterfall layout to your collection view
        self.imagesCollectionView.collectionViewLayout = layout
        
        // Load data
        self.imagesCollectionView.reloadData()
    }
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let vc = self.viewController, let constraint = self.imagesCollectionViewWidth else {
            return CGSize.zero
        }
        
        let columns = CGFloat((imgURLs?.count == 1 ? 1 : (imgURLs?.count == 4 ? 2 : 3)))
        let collectionViewWidth = (vc.view.bounds.width - 73 * 2) * constraint.multiplier
        let size = floor((floor(collectionViewWidth) - (4 * (columns - 1))) / columns)
        return CGSize(width: size, height: size)
        
//        let columns = CGFloat((imgURLs?.count == 1 ? 1 : (imgURLs?.count == 4 ? 2 : 3)))
//        let size = floor((collectionView.bounds.width - 4 * (columns - 1)) / columns)
//        return CGSize(width: size, height: size)
    }
}

// MARK: More/Less control
extension CirclesTableViewCell {
    
    func resetMoreLessControl() {
        self.lblContentHeight.isActive = true
    }
    
    func contentIsMoreThanSixLines() -> Bool {
        let maxHeight = self.lblContent.sizeThatFits(CGSize(width: self.lblContent.bounds.width,
                                                            height: CGFloat.greatestFiniteMagnitude)).height
        return maxHeight > 108 // height for 6 lines
    }
    
    func updateMoreLessControl() {
        if self.contentIsMoreThanSixLines() {
            self.btnMoreLessHeight.constant = 26 // Button height
            self.btnMoreLess.isHidden = false
            let title = self.lblContentHeight.isActive ? "circles_vc_button_more" : "circles_vc_button_less"
            self.btnMoreLess.setTitle(NSLocalizedString(title), for: .normal)
            self.lblContent.bottomInset = 0 // Bottom margin
            self.lblContentHeight.constant = 108 // Height of 6 lines
        } else {
            self.btnMoreLessHeight.constant = 0
            self.btnMoreLess.isHidden = true
            self.lblContent.bottomInset = ((self.circle?.images?.count ?? 0) > 0) ? 8 : 0 // Bottom margin
            self.lblContentHeight.constant = 116 // 108 + 8 bottom margin
        }
    }
    
    @IBAction func toggleMoreLessControl() {
        self.lblContentHeight.isActive = !self.lblContentHeight.isActive
        self.updateMoreLessControl()
        if let tableView = self.viewController?.tableView() {
            UIView.setAnimationsEnabled(false)
            tableView.beginUpdates()
            tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
    }
}

// MARK: CirclesTableViewCell Actions
extension CirclesTableViewCell {
    
    @IBAction func delete() {
        guard let circle = self.circle, let circleID = circle.id else {
            return
        }
        guard let vc = self.viewController else {
            return
        }
        let alertController = UIAlertController(title: nil,
                                                message: NSLocalizedString("circles_vc_delete_alert"),
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("alert_button_delete"),
                                                style: UIAlertActionStyle.default,
                                                handler: { (action: UIAlertAction) -> Void in
                                                    MBProgressHUD.show(vc.view)
                                                    DataManager.shared.deleteCircle(circleID) { responseObject, error in
                                                        circle.delete({
                                                            MBProgressHUD.hide(vc.view)
                                                        })
                                                    }
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("alert_button_cancel"),
                                                style: UIAlertActionStyle.default,
                                                handler: { (action: UIAlertAction) -> Void in
        }))
        vc.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func forward() {
        guard let circle = self.circle else {
            return
        }
        if let imgURLs = self.imgURLs {
            var urls = [URL]()
            for dict in imgURLs {
                if let str = dict["original"], let url = URL(string: str) {
                    urls.append(url)
                }
            }
            self.shareToWeChat(text: circle.text, urls: urls)
        } else {
            self.shareToWeChat(text: circle.text, urls: nil)
        }
    }
    
    func browseImages(_ view: UIView, _ image: UIImage?, _ index: UInt) {
        guard let imgURLs = self.imgURLs else {
            return
        }
        var photos = [IDMPhoto]()
        for dict in imgURLs {
            if let originalStr = dict["original"], let originalURL = URL(string: originalStr) {
                photos.append(IDMPhoto(url: originalURL))
            }
        }
        IDMPhotoBrowser.present(photos, index: index, view: view, scaleImage: image, viewVC: self.viewController)
    }
}

// MARK: Share original images
extension CirclesTableViewCell {
    
    func shareToWeChat(text: String?, urls: [URL]?) {
        self.textToShare = text
        self.imagesToShare = ((urls?.count ?? 0) > 0) ? [UIImage]() : nil
        
        if let urls = urls {
            let dispatchGroup = DispatchGroup()
            for url in urls {
                let cacheKey = SDWebImageManager.shared().cacheKey(for: url)
                if let image = SDImageCache.shared().imageFromCache(forKey: cacheKey) {
                    self.imagesToShare?.append(image)
                } else {
                    MBProgressHUD.show(self.viewController?.view)
                    dispatchGroup.enter()
                    SDWebImageManager.shared().loadImage(
                        with: url,
                        options: [.continueInBackground, .allowInvalidSSLCertificates],
                        progress: nil,
                        completed: { (image, data, error, type, finished, url) -> Void in
                            MBProgressHUD.hide(self.viewController?.view)
                            if let image = image {
                                self.imagesToShare?.append(image)
                            }
                            dispatchGroup.leave()
                    })
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                self.viewController?.shareTextAndImages(text: self.textToShare, images: self.imagesToShare)
            }
        } else {
            self.viewController?.shareTextAndImages(text: self.textToShare, images: nil)
        }
    }
}
