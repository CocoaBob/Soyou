//
//  MembersViewController.swift
//  Soyou
//
//  Created by CocoaBob on 2018-02-04.
//  Copyright © 2018 Soyou. All rights reserved.
//

class MembersViewController: UIViewController {
    
    // Properties
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    var isSegmentedControlHidden = false {
        didSet {
            if self.isViewLoaded {
                self.segmentedControl.isHidden = isSegmentedControlHidden
            }
        }
    }
    
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
    var isLoadingData = false {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var userID: Int?
    var followers: [Member]?
    var followings: [Member]?
    var searchedUsers: [Member]?
    
    // Selection
    var completionHandler: (([Member]) -> ())?
    var selectedUsers = [Member]()
    var excludedUsers: [Member]?
    var isSelectionMode = false {
        didSet {
            if isSelectionMode {
                self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(MembersViewController.completeSelection)), animated: false)
            } else {
                self.navigationItem.setRightBarButton(nil, animated: false)
            }
        }
    }
    
    // Search
    var isSearchResultsViewController = false
    var isSearchBarHidden = false {
        didSet {
            if self.isViewLoaded {
                self.searchController?.searchBar.isHidden = isSearchBarHidden
                if let action = self.navigationItem.rightBarButtonItem?.action, action == #selector(MembersViewController.showSearchController) {
                    self.navigationItem.setRightBarButton(nil, animated: false)
                }
            }
        }
    }
    var searchController: UISearchController?
    var searchKeyword: String?
    weak var searchFromViewController: UIViewController?
    fileprivate var leftBarButtonItem: UIBarButtonItem?
    fileprivate var rightBarButtonItem: UIBarButtonItem?
    
    // Class methods
    class func instantiate() -> MembersViewController {
        return  UIStoryboard(name: "MembersViewController", bundle: nil).instantiateViewController(withIdentifier: "MembersViewController") as! MembersViewController
    }
    
    // Life Cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Titles
        self.segmentedControl.setTitle(NSLocalizedString("members_vc_title_followings"), forSegmentAt: 0)
        self.segmentedControl.setTitle(NSLocalizedString("members_vc_title_followers"), forSegmentAt: 1)
        self.segmentedControl.selectedSegmentIndex = isShowingFollowers ? 1 : 0
        self.segmentedControl.isHidden = self.isSegmentedControlHidden
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.tableView, 0, true, true, false, false)
        
        // Setup refresh controls
        self.setupRefreshControls()
        
        // Setup Table
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
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

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MembersViewController: UITableViewDataSource, UITableViewDelegate {
    
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
                if self.isSearchResultsViewController {
                    cell.lblTitle.text = NSLocalizedString(
                        self.isLoadingData ?
                            "members_vc_loading" :
                            (self.searchedUsers == nil ? "members_vc_tap_search" : "members_vc_no_result"))
                } else {
                    cell.lblTitle.text = NSLocalizedString(
                        self.isLoadingData ?
                            ((self.tableView.mj_header != nil && self.tableView.mj_header.isRefreshing) ? "" : "members_vc_loading") :
                            "members_vc_no_data")
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MembersTableViewCell", for: indexPath)
            if let cell = cell as? MembersTableViewCell {
                if self.isSearchResultsViewController {
                    cell.member = self.searchedUsers?[indexPath.row]
                } else {
                    cell.member = self.isShowingFollowers ? self.followers?[indexPath.row] : self.followings?[indexPath.row]
                }
                if let member = cell.member {
                    // Is selected or not
                    cell.isMemberSelected = self.selectedUsers.contains(member)
                    // Was already selected or not
                    cell.isMemberExcluded = self.excludedUsers?.contains(member) ?? false
                }
                cell.isSelectionMode = self.isSelectionMode
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
        var member: Member?
        if self.isSearchResultsViewController {
            member = self.searchedUsers?[indexPath.row]
        } else {
            member = self.isShowingFollowers ? self.followers?[indexPath.row] : self.followings?[indexPath.row]
        }
        if let member = member {
            if self.isSelectionMode {
                var isSelected = false
                if self.excludedUsers?.contains(member) ?? false {
                    return
                }
                if let index = self.selectedUsers.index(of: member) {
                    self.selectedUsers.remove(at: index)
                } else {
                    self.selectedUsers.append(member)
                    isSelected = true
                }
                if let cell = tableView.cellForRow(at: indexPath) as? MembersTableViewCell {
                    cell.isMemberSelected = isSelected
                }
            } else {
                let circlesVC = CirclesViewController.instantiate(member.id, member.profileUrl, member.username)
                if self.isSearchResultsViewController {
                    self.presentingViewController?.navigationController?.pushViewController(circlesVC, animated: true)
                } else {
                    self.navigationController?.pushViewController(circlesVC, animated: true)
                }
            }
        }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}

// MARK: - Load data
extension MembersViewController {
    
    func loadData() {
        if self.isLoadingData {
            return
        }
        // Clear selections before loading
        self.selectedUsers.removeAll()
        // Update status and reload table
        self.isLoadingData = true
        // Load data
        if self.isSearchResultsViewController {
            if let keyword = self.searchKeyword {
                DataManager.shared.searchUsers(keyword) { responseObject, error in
                    if let responseObject = responseObject as? Dictionary<String, AnyObject>,
                        let data = responseObject["data"] as? [NSDictionary] {
                        self.searchedUsers = Member.newList(dicts: data)
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
                    self.followers = Member.newList(dicts: data)
                }
                dispatchGroup.leave()
            }
            dispatchGroup.enter()
            DataManager.shared.allFollowings()  { responseObject, error in
                if let responseObject = responseObject as? Dictionary<String, AnyObject>,
                    let data = responseObject["data"] as? [NSDictionary] {
                    self.followings = Member.newList(dicts: data)
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
extension MembersViewController {
    
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
extension MembersViewController: UISearchControllerDelegate {
    
    func setupRightBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(MembersViewController.showSearchController))
    }
    
    @objc func showSearchController() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.leftBarButtonItem = self.navigationItem.leftBarButtonItem
        self.navigationItem.setLeftBarButton(nil, animated: false)
        self.rightBarButtonItem = self.navigationItem.rightBarButtonItem
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
        self.navigationItem.setHidesBackButton(false, animated: false)
        self.navigationItem.setLeftBarButton(self.leftBarButtonItem, animated: false)
        self.navigationItem.setRightBarButton(self.isSearchBarHidden ? nil : self.rightBarButtonItem, animated: false)
        self.navigationItem.titleView = self.segmentedControl
    }
    
    func setupSearchController() {
        let vc = MembersViewController.instantiate()
        vc.isSearchResultsViewController = true
        vc.searchFromViewController = self
        self.searchController = UISearchController(searchResultsController: vc)
        self.searchController?.delegate = self
        self.searchController?.searchResultsUpdater = vc
        self.searchController?.searchBar.delegate = vc
        self.searchController?.searchBar.placeholder = NSLocalizedString("members_vc_search_bar_placeholder")
        self.searchController?.searchBar.showsCancelButton = false
        self.searchController?.hidesNavigationBarDuringPresentation = false
        if self.isSearchBarHidden {
            self.searchController?.searchBar.isHidden = true
        }
        
        if self.isSearchBarHidden {
            if let action = self.navigationItem.rightBarButtonItem?.action, action == #selector(MembersViewController.showSearchController) {
                self.navigationItem.setRightBarButton(nil, animated: false)
            }
        } else {
            self.setupRightBarButtonItem()
        }
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.hideSearchController()
    }
}

// MARK: UISearchBarDelegate
extension MembersViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchKeyword = searchBar.text
        self.loadData()
    }
}

// MARK: UISearchResultsUpdating
extension MembersViewController: UISearchResultsUpdating {
    
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
extension MembersViewController {
    
    @IBAction func toggleFollowingFollower(_ sender: UISegmentedControl) {
        self.isShowingFollowers = sender.selectedSegmentIndex == 1
    }
    
    @IBAction func completeSelection() {
        self.completionHandler?(self.selectedUsers)
        self.dismissSelf()
    }
}
