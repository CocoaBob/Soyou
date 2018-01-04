//
//  CirclesViewController.swift
//  Soyou
//
//  Created by CocoaBob on 2018-01-02.
//  Copyright © 2018 Soyou. All rights reserved.
//

class CirclesViewController: SyncedFetchedResultsViewController {
    
    // Override SyncedFetchedResultsViewController
    override func tableView() -> UITableView {
        return _tableView
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult>? {
        return Circle.mr_fetchAllGrouped(by: nil, with: nil, sortedBy: "createdDate", ascending: false)
    }
    
    // Class methods
    class func instantiate() -> CirclesViewController {
        return UIStoryboard(name: "CirclesViewController", bundle: nil).instantiateViewController(withIdentifier: "CirclesViewController") as! CirclesViewController
    }
    
    // Properties
    @IBOutlet var _tableView: UITableView!
    @IBOutlet var _emptyView: UIView!
    @IBOutlet var _emptyViewLabel: UILabel!
    @IBOutlet var viewUserInfo: UIView!
    var isEmptyViewVisible: Bool = true {
        didSet {
            self._emptyView.isHidden = !isEmptyViewVisible
        }
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
                                       image: UIImage(named: "img_tab_globe"),
                                       selectedImage: UIImage(named: "img_tab_globe_selected"))
        
        // Bars
        self.hidesBottomBarWhenPushed = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self._emptyView.isHidden = true
        
        // Title
        _emptyViewLabel.text = NSLocalizedString("circles_vc_empty_label")
        
        // Parallax Header
//        self.setupParallaxHeader()
        
        // Setup table
        self.tableView().rowHeight = UITableViewAutomaticDimension
        self.tableView().estimatedRowHeight = UITableViewAutomaticDimension
        self.tableView().allowsSelection = false
        self.tableView().tableFooterView = UIView(frame: CGRect.zero)
        
        // Background Color
        self.tableView().backgroundColor = Cons.UI.colorBG
        
        // Setup refresh controls
        self.setupRefreshControls()
        
        // Load Data
        self.loadData(nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        
        self.hideToolbar(false)
        
        // Reload data
        self.reloadData {
            self.tableView().reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Workaround to make sure navigation bar is visible even the slide-back gesture is cancelled.
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Make sure interactive gesture's delegate is nil before disappearing
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}

// MARK: - Load data
extension CirclesViewController {
    
    // MARK: Data
    func loadData(_ timestamp: String?) {
        let timestamp = timestamp ?? Cons.utcDateFormatter.string(from: Date())
        self.beginRefreshing()
        DataManager.shared.requestPreviousCicles(timestamp, nil) { responseObject, error in
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
        let count = self.fetchedResultsController?.sections?.count ?? 0
        self.isEmptyViewVisible = count == 0
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.fetchedResultsController?.sections?[section].numberOfObjects ?? 0
        self.isEmptyViewVisible = count == 0
        return count
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
                cell.imgUser.image = nil
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
            if let userID = circle.userId {
                cell.btnDelete.isHidden = UserManager.shared.matricule != "\(userID)"
            } else {
                cell.btnDelete.isHidden = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

// MARK: - Refreshing
extension CirclesViewController {
    
    func setupRefreshControls() {
        guard let header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadData(nil)
            self.beginRefreshing()
        }) else { return }
        header.setTitle(NSLocalizedString("pull_to_refresh_header_idle"), for: .idle)
        header.setTitle(NSLocalizedString("pull_to_refresh_header_pulling"), for: .pulling)
        header.setTitle(NSLocalizedString("pull_to_refresh_header_refreshing"), for: .refreshing)
        header.setTitle(NSLocalizedString("pull_to_refresh_no_more_data"), for: .noMoreData)
        header.lastUpdatedTimeLabel?.isHidden = true
        self.tableView().mj_header = header
        
        guard let footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            self.loadNextData()
        }) else { return }
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_idle"), for: .idle)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_pulling"), for: .pulling)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_refreshing"), for: .refreshing)
        footer.setTitle(NSLocalizedString("pull_to_refresh_no_more_data"), for: .noMoreData)
        footer.isAutomaticallyHidden = false
        self.tableView().mj_footer = footer
    }
    
    func beginRefreshing() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func endRefreshing(_ resultCount: Int) {
        DispatchQueue.main.async {
            self.tableView().mj_header.endRefreshing()
            if resultCount > 0 {
                self.tableView().mj_footer.endRefreshing()
            } else {
                self.tableView().mj_footer.endRefreshingWithNoMoreData()
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

//// MARK: Parallax Header
//extension CirclesViewController {
//
//    fileprivate func setupParallaxHeader() {
//        // Parallax View
//        self.tableView().parallaxHeader.height = self.viewUserInfo.frame.height
//        self.tableView().parallaxHeader.view = self.viewUserInfo
//        self.tableView().parallaxHeader.mode = .fill
//    }
//}

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
