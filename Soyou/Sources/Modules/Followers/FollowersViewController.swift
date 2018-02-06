//
//  FollowersViewController.swift
//  Soyou
//
//  Created by CocoaBob on 2018-02-04.
//  Copyright © 2018 Soyou. All rights reserved.
//

class FollowersViewController: UIViewController {
    
    // Properties
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    var userID: Int?
    var isShowingFollowers = true {// If false, it's followings
        didSet {
            if self.isViewLoaded {
                // Update segmented control
                self.segmentedControl.selectedSegmentIndex = isShowingFollowers ? 1 : 0
                // Reload table
                self.tableView.reloadData()
            }
        }
    }
    var followers: [Follower]?
    var followings: [Follower]?
    var searchedUsers: [Follower]?
    var isLoadingData = false {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // Search
    var searchController: UISearchController?
    var isSearchResultsViewController: Bool = false
    var searchKeyword: String?
    weak var searchFromViewController: UIViewController?
    
    // Class methods
    class func instantiate() -> FollowersViewController {
        return  UIStoryboard(name: "FollowersViewController", bundle: nil).instantiateViewController(withIdentifier: "FollowersViewController") as! FollowersViewController
    }
    
    // Life Cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Titles
        self.segmentedControl.setTitle(NSLocalizedString("followers_vc_title_followings"), forSegmentAt: 0)
        self.segmentedControl.setTitle(NSLocalizedString("followers_vc_title_followers"), forSegmentAt: 1)
        self.segmentedControl.selectedSegmentIndex = isShowingFollowers ? 1 : 0
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.tableView, 0, true, true, false, false)
        
        // Setup refresh controls
        self.setupRefreshControls()
        
        // Setup Table
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorColor = UIColor.clear
        
        // Load data
        self.loadData()
        
        // Setup Search Controller
        self.setupSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Nav bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        // For navigation bar search bar
        self.definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Workaround to make sure navigation bar is updated even the slide-back gesture is cancelled.
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // For navigation bar search bar
        self.definesPresentationContext = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
}

// MARK: - Table View DataSource & Delegate
extension FollowersViewController: UITableViewDataSource, UITableViewDelegate {
    
    fileprivate func numberOfRows() -> Int {
        if self.isSearchResultsViewController {
            return self.searchedUsers?.count ?? 0
        } else {
            return self.isShowingFollowers ? (self.followers?.count ?? 0) : (self.followings?.count ?? 0)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let returnValue = numberOfRows()
        return returnValue == 0 ? 1 : returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let count = self.numberOfRows()
        if count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatusMessageTableViewCell", for: indexPath)
            if let cell = cell as? StatusMessageTableViewCell {
                if self.isSearchResultsViewController && self.searchKeywordIsEmpty() {
                    cell.lblTitle.text = NSLocalizedString(self.isLoadingData ? "followers_vc_loading" : "followers_vc_tap_search")
                } else {
                    cell.lblTitle.text = NSLocalizedString(
                        self.isLoadingData ?
                            ((self.tableView.mj_header != nil && self.tableView.mj_header.isRefreshing) ? "" : "followers_vc_loading") :
                            (self.isSearchResultsViewController ? "followers_vc_no_result" : "followers_vc_no_data"))
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersTableViewCell", for: indexPath)
            if let cell = cell as? FollowersTableViewCell {
                if self.isSearchResultsViewController {
                    cell.follower = self.searchedUsers?[indexPath.row]
                } else {
                    cell.follower = self.isShowingFollowers ? self.followers?[indexPath.row] : self.followings?[indexPath.row]
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.numberOfRows() == 0 {
            return 64
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var user: Follower?
        if self.isSearchResultsViewController {
            user = self.searchedUsers?[indexPath.row]
        } else {
            user = self.isShowingFollowers ? self.followers?[indexPath.row] : self.followings?[indexPath.row]
        }
        if let follower = user {
            let circlesVC = CirclesViewController.instantiate(follower.id, follower.profileUrl, follower.username)
            if self.isSearchResultsViewController {
                self.presentingViewController?.navigationController?.pushViewController(circlesVC, animated: true)
            } else {
                self.navigationController?.pushViewController(circlesVC, animated: true)
            }
        }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}

// MARK: - Load data
extension FollowersViewController {
    
    func loadData() {
        if self.isLoadingData {
            return
        }
        self.isLoadingData = true
        // Load data
        if self.isSearchResultsViewController {
            if let keyword = self.searchKeyword {
                DataManager.shared.searchUsers(keyword) { responseObject, error in
                    if let responseObject = responseObject as? Dictionary<String, AnyObject>,
                        let data = responseObject["data"] as? [NSDictionary] {
                        self.searchedUsers = Follower.newList(dicts: data)
                    }
                    self.endRefreshing()
                    self.isLoadingData = false // Will refresh the table
                }
            } else {
                self.isLoadingData = false
            }
        } else {
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            DataManager.shared.allFollowers()  { responseObject, error in
                if let responseObject = responseObject as? Dictionary<String, AnyObject>,
                    let data = responseObject["data"] as? [NSDictionary] {
                    self.followers = Follower.newList(dicts: data)
                }
                dispatchGroup.leave()
            }
            dispatchGroup.enter()
            DataManager.shared.allFollowings()  { responseObject, error in
                if let responseObject = responseObject as? Dictionary<String, AnyObject>,
                    let data = responseObject["data"] as? [NSDictionary] {
                    self.followings = Follower.newList(dicts: data)
                }
                dispatchGroup.leave()
            }
            dispatchGroup.notify(queue: .main) {
                self.endRefreshing()
                self.isLoadingData = false // Will refresh the table
            }
        }
    }
}

// MARK: - Refreshing
extension FollowersViewController {
    
    func setupRefreshControls() {
        if self.isSearchResultsViewController {
            return
        }
        guard let header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadData()
        }) else { return }
        header.setTitle(NSLocalizedString("pull_to_refresh_header_idle"), for: .idle)
        header.setTitle(NSLocalizedString("pull_to_refresh_header_pulling"), for: .pulling)
        header.setTitle(NSLocalizedString("pull_to_refresh_header_refreshing"), for: .refreshing)
        header.setTitle(NSLocalizedString("pull_to_refresh_no_more_data"), for: .noMoreData)
        header.lastUpdatedTimeLabel?.isHidden = true
        self.tableView.mj_header = header
    }
    
    func beginRefreshing() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        DispatchQueue.main.async {
            if !self.isSearchResultsViewController {
                self.tableView.mj_header.beginRefreshing()
            }
        }
    }
    
    func endRefreshing() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        DispatchQueue.main.async {
            if !self.isSearchResultsViewController {
                self.tableView.mj_header.endRefreshing()
            }
        }
    }
}

// MARK: - SearchControler
extension FollowersViewController: UISearchControllerDelegate {
    
    func setupRightBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(FollowersViewController.showSearchController))
    }
    
    @objc func showSearchController() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setRightBarButton(nil, animated: false)
        let searchBar = self.searchController!.searchBar
        if #available(iOS 11.0, *) {
            let searchBarContainer = SearchBarContainerView(searchBar: searchBar)
            searchBarContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
            self.navigationItem.titleView = searchBarContainer
        } else {
            self.navigationItem.titleView = searchBar
        }
        self.searchController!.searchBar.becomeFirstResponder()
    }
    
    func hideSearchController() {
        self.setupRightBarButtonItem()
        self.navigationItem.titleView = self.segmentedControl
    }
    
    func setupSearchController() {
        let searchResultsController = FollowersViewController.instantiate()
        searchResultsController.isSearchResultsViewController = true
        searchResultsController.searchFromViewController = self
        self.searchController = UISearchController(searchResultsController: searchResultsController)
        self.searchController!.delegate = self
        self.searchController!.searchResultsUpdater = searchResultsController
        self.searchController!.searchBar.delegate = searchResultsController
        self.searchController!.searchBar.placeholder = NSLocalizedString("followers_vc_search_bar_placeholder")
        self.searchController!.searchBar.showsCancelButton = false
        self.searchController!.hidesNavigationBarDuringPresentation = false
        
        self.setupRightBarButtonItem()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.navigationItem.setHidesBackButton(false, animated: false)
        self.hideSearchController()
    }
}

// MARK: UISearchBarDelegate
extension FollowersViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchKeyword = searchBar.text
        self.loadData()
    }
}

// MARK: UISearchResultsUpdating
extension FollowersViewController: UISearchResultsUpdating {
    
    func searchKeywordIsEmpty() -> Bool {
        return self.searchKeyword?.count ?? 0 == 0
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // Avoid hiding the searchResultsController if search text field is empty
        if searchKeywordIsEmpty() {
            self.searchedUsers?.removeAll()
            self.tableView.reloadData()
            searchController.searchResultsController?.view.isHidden = false
        }
        
        var newSearchKeyword: String?
        if searchController.isActive {
            newSearchKeyword = searchController.searchBar.text
        } else {
            newSearchKeyword = nil
        }
        
        let oldSearchKeyword = self.searchKeyword
        self.searchKeyword = newSearchKeyword
        
        if newSearchKeyword == nil && oldSearchKeyword == nil {
            // Same, no need to search
            return
        } else if let newSearchKeyword = newSearchKeyword, let oldSearchKeyword = oldSearchKeyword {
            if newSearchKeyword == oldSearchKeyword {
                // Same, no need to search
                return
            }
        }
        
        if newSearchKeyword == nil {
            self.loadData()
        }
    }
}

// MARK: - Actions
extension FollowersViewController {
    
    @IBAction func toggleFollowingFollower(_ sender: UISegmentedControl) {
        self.isShowingFollowers = sender.selectedSegmentIndex == 1
    }
}
