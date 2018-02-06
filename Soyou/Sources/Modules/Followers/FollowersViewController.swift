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
    
    // Loading Indicator
    @IBOutlet fileprivate var _loadingView: UIView!
    @IBOutlet fileprivate var _loadingViewLabel: UILabel!
    var isLoadingViewVisible: Bool = true {
        didSet {
            self._loadingView.isHidden = !isLoadingViewVisible
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Titles
        self.segmentedControl.setTitle(NSLocalizedString("followers_vc_title_followings"), forSegmentAt: 0)
        self.segmentedControl.setTitle(NSLocalizedString("followers_vc_title_followers"), forSegmentAt: 1)
        self.segmentedControl.selectedSegmentIndex = isShowingFollowers ? 1 : 0
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.tableView, 0, true, true, false, false)
        
        // Setup Table
        self.tableView.rowHeight = 80
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorColor = UIColor.clear
        
        // Setup refresh controls
        self.setupRefreshControls()
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        if self.isSearchResultsViewController {
            returnValue = self.searchedUsers?.count ?? 0
        } else {
            returnValue = self.isShowingFollowers ? (self.followers?.count ?? 0) : (self.followings?.count ?? 0)
        }
        if returnValue == 0 {
            if self.isSearchResultsViewController && self.searchKeywordIsEmpty() {
                self.showTapToSearchMessage()
            } else {
                self.showNoDataMessage()
            }
        }
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        // Show indicator
        if self.isSearchResultsViewController && self.searchKeywordIsEmpty() {
            self.showTapToSearchMessage()
        } else {
            self.showLoadingMessage()
        }
        
        // Load data
        if self.isSearchResultsViewController {
            if let keyword = self.searchKeyword {
                DataManager.shared.searchUsers(keyword) { responseObject, error in
                    if let responseObject = responseObject as? Dictionary<String, AnyObject>,
                        let data = responseObject["data"] as? [NSDictionary] {
                        self.searchedUsers = Follower.newList(dicts: data)
                    }
                    self.endRefreshing()
                    self.tableView.reloadData()
                    self.isLoadingViewVisible = false
                }
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
                self.tableView.reloadData()
                self.isLoadingViewVisible = false
            }
        }
    }
}

// MARK: - Refreshing
extension FollowersViewController {
    
    func setupRefreshControls() {
        guard let header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadData()
            self.beginRefreshing()
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
    }
    
    func endRefreshing() {
        DispatchQueue.main.async {
            self.tableView.mj_header.endRefreshing()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
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
    
    func showTapToSearchMessage() {
        _loadingViewLabel.text = NSLocalizedString("followers_vc_tap_search")
        self.isLoadingViewVisible = true
    }
    
    func showNoDataMessage() {
        _loadingViewLabel.text = NSLocalizedString("followers_vc_no_data")
        self.isLoadingViewVisible = true
    }
    
    func showLoadingMessage() {
        _loadingViewLabel.text = NSLocalizedString("followers_vc_loading")
        self.isLoadingViewVisible = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // Avoid hiding the searchResultsController if search text field is empty
        if searchKeywordIsEmpty() {
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
