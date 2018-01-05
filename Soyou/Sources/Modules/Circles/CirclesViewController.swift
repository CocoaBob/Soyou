//
//  CirclesViewController.swift
//  Soyou
//
//  Created by CocoaBob on 2018-01-02.
//  Copyright © 2018 Soyou. All rights reserved.
//

class CirclesViewController: SyncedFetchedResultsViewController {
    
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
    
    // Class methods
    class func instantiate() -> CirclesViewController {
        return UIStoryboard(name: "CirclesViewController", bundle: nil).instantiateViewController(withIdentifier: "CirclesViewController") as! CirclesViewController
    }
    
    // Properties
    @IBOutlet var _tableView: UITableView!
    
    @IBOutlet var imgViewAvatar: UIImageView!
    @IBOutlet var parallaxHeaderView: UIView!
    @IBOutlet var lblUsername: UILabel!
    
    fileprivate var KVOContextCirclesViewController = 0
    
    var isLoadingData = false
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var loadingIndicatorBottom: NSLayoutConstraint!
    
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
//        self.tableView().backgroundColor = Cons.UI.colorBG
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.tableView(), 0, false, false, false, true)
        
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
        
        // Reload data
        self.reloadData {
            self.tableView().reloadData()
        }
        
        // Update User Info
        self.updateUserInfo(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Workaround to make sure navigation bar is visible even the slide-back gesture is cancelled.
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Make sure interactive gesture's delegate is nil before disappearing
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
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
            if let urlStr = circle.userProfileUrl, let url = URL(string: urlStr) {
                cell.imgUser.sd_setImage(with: url,
                                         placeholderImage: UIImage(named: "img_placeholder_1_1_s"),
                                         options: [.continueInBackground, .allowInvalidSSLCertificates, .highPriority],
                                         completed: nil)
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
}

// MARK: Pull Down Refresh
extension CirclesViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        struct Constant {
            static let headerHeight = CGFloat(240)
            static let triggerY = CGFloat(-40)
        }
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let offsetY = scrollView.contentOffset.y + statusBarHeight + Constant.headerHeight
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
            var options: SDWebImageOptions = [.continueInBackground, .allowInvalidSSLCertificates, .delayPlaceholder]
            if reload {
                options = [.refreshCached, .continueInBackground, .allowInvalidSSLCertificates, .delayPlaceholder]
            }
            self.imgViewAvatar.sd_setImage(with: url,
                                           placeholderImage: UserManager.shared.defaultAvatarImage(),
                                           options: options,
                                           completed: { (image, error, type, url) in
                                            if error == nil {
                                                self.addAvatarBorder()
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

// MARK: - Custom cells
class CirclesTableViewCell: UITableViewCell {
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var lblName: MarginLabel!
    @IBOutlet var lblContent: MarginLabel!
    @IBOutlet var imgsCollectionView: UICollectionView!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnDelete: UIButton!
    
    var imgURLs: [String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        imgUser.image = nil
        lblName.text = nil
        lblContent.text = nil
        imgURLs = nil
        imgsCollectionView.reloadData()
    }
    
    @IBAction func delete() {
        
    }
}

extension CirclesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    @objc func cellForItem(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircleImagesCollectionViewCell", for: indexPath)
        return cell
    }
    
    @objc func didSelectItemAtIndexPath(_ collectionView: UICollectionView, indexPath: IndexPath) {
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imgURLs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.cellForItem(collectionView: collectionView, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.didSelectItemAtIndexPath(collectionView, indexPath: indexPath)
    }
}
