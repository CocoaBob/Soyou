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
    
    var isFollowers = true // If false, it's followings
    var followers: [Follower]?
    
    // Class methods
    class func instantiate() -> FollowersViewController {
        return  UIStoryboard(name: "FollowersViewController", bundle: nil).instantiateViewController(withIdentifier: "FollowersViewController") as! FollowersViewController
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIViewController
        self.title = NSLocalizedString(isFollowers ? "followers_vc_title_followers" : "followers_vc_title_followings")
        
        // Fix scroll view insets
//        self.updateScrollViewInset(self.tableView, 0, true, true, false, false)
        
        // Setup Table
        self.tableView.rowHeight = 80
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorColor = UIColor.clear
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
        return self.followers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FollowersTableViewCell", for: indexPath)
        if let cell = cell as? FollowersTableViewCell {
            cell.follower = self.followers?[indexPath.row]
        }
        return cell
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let follower = self.followers?[indexPath.row] {
            let circlesVC = CirclesViewController.instantiate(follower.id, follower.profileUrl, follower.username)
            self.navigationController?.pushViewController(circlesVC, animated: true)
        }
    }
}
