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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Nav bar
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        super.viewWillAppear(animated)
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
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
}

// MARK: - Table View DataSource & Delegate
extension FollowersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isShowingFollowers ? (self.followers?.count ?? 0) : (self.followings?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersTableViewCell", for: indexPath)
        if let cell = cell as? FollowersTableViewCell {
            cell.follower = self.isShowingFollowers ? self.followers?[indexPath.row] : self.followings?[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let follower = (self.isShowingFollowers ? self.followers?[indexPath.row] : self.followings?[indexPath.row]) {
            let circlesVC = CirclesViewController.instantiate(follower.id, follower.profileUrl, follower.username)
            self.navigationController?.pushViewController(circlesVC, animated: true)
        }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}

// MARK: - Load data
extension FollowersViewController {
    
    func loadData() {
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

// MARK: - Actions
extension FollowersViewController {
    
    @IBAction func toggleFollowingFollower(_ sender: UISegmentedControl) {
        self.isShowingFollowers = sender.selectedSegmentIndex == 1
    }
}
