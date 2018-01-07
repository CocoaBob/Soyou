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
        
        self.edgesForExtendedLayout = UIRectEdge.all
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = false
        
        // UIViewController
        self.title = NSLocalizedString("circles_vc_title")
        
        // UITabBarItem
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("circles_vc_tab_title"),
                                       image: UIImage(named: "img_tab_images"),
                                       selectedImage: UIImage(named: "img_tab_images_selected"))
        
        // Bars
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "img_camera_selected"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(CirclesViewController.createCircle))
        
        // Setup table
        self.tableView().rowHeight = UITableViewAutomaticDimension
        self.tableView().estimatedRowHeight = UITableViewAutomaticDimension
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CirclesTableViewCell", for: indexPath) as? CirclesTableViewCell else {
            return UITableViewCell()
        }
        
        if let circle = self.fetchedResultsController?.object(at: indexPath) as? Circle {
            if let str = circle.userProfileUrl, let url = URL(string: str) {
                cell.imgUser.sd_setImage(with: url,
                                         placeholderImage: UIImage(named: "img_placeholder_1_1_s"),
                                         options: [.continueInBackground, .allowInvalidSSLCertificates, .highPriority],
                                         completed: { (image, error, type, url) -> Void in
                                            // Update the image with an animation
                                            if let image = image {
                                                UIView.transition(with: cell.imgUser,
                                                                  duration: 0.3,
                                                                  options: UIViewAnimationOptions.transitionCrossDissolve,
                                                                  animations: { cell.imgUser.image = image },
                                                                  completion: nil)
                                            }
                })
            } else {
                cell.imgUser.image = UIImage(named: "img_placeholder_1_1_s")
            }
            cell.lblName.text = circle.username ?? ""
            cell.lblContent.text = circle.text
            cell.lblContent.bottomInset = ((circle.images?.count ?? 0) > 0) ? 8 : 0
            cell.imgURLs = circle.images as? [String]
            if let date = circle.createdDate {
                cell.lblDate.text = DateFormatter.localizedString(from: date,
                                                                  dateStyle: DateFormatter.Style.short,
                                                                  timeStyle: DateFormatter.Style.short)
            } else {
                cell.lblDate.text = nil
            }
            cell.btnDelete.isHidden = UserManager.shared.userID != (circle.userId as? Int)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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

// Actions
extension CirclesViewController {
    
    @IBAction func createCircle() {
        
    }
    
    @objc func avatarAction() {
        
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
                                            // Update the image with an animation
                                            if let image = image {
                                                UIView.transition(with: self.imgViewAvatar,
                                                                  duration: 0.3,
                                                                  options: UIViewAnimationOptions.transitionCrossDissolve,
                                                                  animations: { self.imgViewAvatar.image = image },
                                                                  completion: nil)
                                            }
            })
        } else {
            self.imgViewAvatar.image = UserManager.shared.defaultAvatarImage()
        }
        self.lblUsername.text = UserManager.shared.username ?? NSLocalizedString("user_vc_username_unknown")
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
    
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var lblName: MarginLabel!
    @IBOutlet var lblContent: MarginLabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnDelete: UIButton!
    
    @IBOutlet var imagesCollectionView: UICollectionView!
    @IBOutlet var imagesCollectionViewWidth1: NSLayoutConstraint!
    @IBOutlet var imagesCollectionViewWidth2: NSLayoutConstraint!
    @IBOutlet var imagesCollectionViewWidth3: NSLayoutConstraint!
    
    var imgURLs: [String]? {
        didSet {
            let columns = (imgURLs?.count == 1 ? 1 : (imgURLs?.count == 4 ? 2 : 3))
            self.imagesCollectionViewWidth1.isActive = columns == 1
            self.imagesCollectionViewWidth2.isActive = columns == 2
            self.imagesCollectionViewWidth3.isActive = columns == 3
            self.imagesCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCollectionView()
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgUser.image = nil
        self.lblName.text = nil
        self.lblContent.text = nil
        self.imgURLs = nil
    }
    
    @IBAction func delete() {
        
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
            if let str = self.imgURLs?[indexPath.row], let url = URL(string: str) {
                cell.imageView.sd_setImage(with: url,
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
        
    }
}

// MARK: - CollectionView Waterfall Layout
extension CirclesTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func setupCollectionView() {
        // Create a flow layout
        let layout = UICollectionViewFlowLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        
        // Add the waterfall layout to your collection view
        self.imagesCollectionView.collectionViewLayout = layout
        
        // Load data
        self.imagesCollectionView.reloadData()
    }
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var columns = CGFloat(3.0)
        if self.imgURLs?.count == 1 {
            columns = CGFloat(1.0)
        } else if self.imgURLs?.count == 4 {
            columns = CGFloat(2.0)
        }
        let size = floor((collectionView.bounds.width - 1) / columns) - 1
        return CGSize(width: size, height: size)
    }
}

class CircleImagesCollectionView: UICollectionView {
    
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return super.contentSize
    }
    
    override func reloadData() {
        super.reloadData()
        self.layoutIfNeeded()
        self.invalidateIntrinsicContentSize()
    }
}

class CircleImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(named: "img_placeholder_1_1_s")
    }
}
