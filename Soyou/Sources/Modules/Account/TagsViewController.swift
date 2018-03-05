//
//  TagsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 2018-02-25.
//  Copyright © 2018 Soyou. All rights reserved.
//

struct TagUser {
    var userId: Int = -1
    var username: String?
    var userProfileUrl: String?
}

struct Tag {
    var id: Int?
    var label: String?
    var members: [TagUser]?
    
    mutating func addMember(member: TagUser) {
        if members == nil {
            self.members = [TagUser]()
        }
        if let members = self.members,
            members.map({ $0.userId }).contains(member.userId) {
            return
        }
        self.members?.append(member)
    }
}

class TagsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var tags: [Tag]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    // Class methods
    class func instantiate() -> TagsViewController {
        return  UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewController(withIdentifier: "TagsViewController") as! TagsViewController
    }
    
    // Life Cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title
        self.title = NSLocalizedString("tags_vc_title")
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.tableView, 0, true, true, false, false)
        
        // Setup refresh controls
        self.setupRefreshControls()
        
        // Setup Table
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
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

// MARK: - UITableViewDataSource, UITableViewDelegate
extension TagsViewController: UITableViewDataSource, UITableViewDelegate {
    
    fileprivate func numberOfRows() -> Int {
        return self.tags?.count ?? 0
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
                cell.lblTitle.text = NSLocalizedString(self.tags == nil ? "tags_vc_loading_data" : "tags_vc_no_result")
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TagsTableViewCell", for: indexPath)
            if let cell = cell as? TagsTableViewCell, let tag = self.tags?[indexPath.row] {
                cell.aTag = tag
                if let tagId = tag.id, tag.members == nil {
                    DataManager.shared.allMembersOfTag(tagId) { responseObject, error in
                        if let responseObject = responseObject as? Dictionary<String, AnyObject>,
                            let data = responseObject["data"] as? [NSDictionary] {
                            var members = [TagUser]()
                            for dict in data {
                                let userId = dict["userId"] as? Int ?? -1
                                var username = dict["username"] as? String
                                username = username?.removingPercentEncoding ?? username
                                let userProfileUrl = dict["userProfileUrl"] as? String
                                members.append(TagUser(userId: userId, username: username, userProfileUrl: userProfileUrl))
                            }
                            self.tags?[indexPath.row].members = members
                            cell.aTag = self.tags?[indexPath.row]
                        }
                    }
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard indexPath.row < self.tags?.count ?? 0 else {
            return
        }
        if let tag = self.tags?[indexPath.row] {
            let vc = TagEditViewController.instantiate(tag: tag)
            vc.completion = {
                self.loadData()
            }
            let navC = InteractivePopNavigationController(rootViewController: vc)
            self.present(navC, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.numberOfRows() == 0 ? false : true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if self.numberOfRows() > 0,
            let tag = self.tags?[indexPath.row],
            let tagId = tag.id {
            DataManager.shared.removeTag(tagId, { (responseObject, error) in
                if error == nil {
                    self.tableView.beginUpdates()
                    self.tags?.remove(at: indexPath.row)
                    if self.tags?.count ?? 0 == 0 {
                        self.tableView.reloadData()
                    } else {
                        self.tableView.deleteRows(at: [indexPath], with: .left)
                    }
                    self.tableView.endUpdates()
                }
            })
        }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}

// MARK: - Refreshing
extension TagsViewController {
    
    func setupRefreshControls() {
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
            self.tableView.mj_header.beginRefreshing()
        }
    }
    
    func endRefreshing() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        DispatchQueue.main.async {
            self.tableView.mj_header.endRefreshing()
        }
    }
}

// MARK: - Load data
extension TagsViewController {
    
    func loadData() {
        DataManager.shared.allTags() { responseObject, error in
            if let responseObject = responseObject as? Dictionary<String, AnyObject>,
                let data = responseObject["data"] as? [NSDictionary] {
                var tags = [Tag]()
                for dict in data {
                    if let id = dict["id"] as? Int, let label = dict["label"] as? String {
                        let tag = Tag(id: id, label: label.removingPercentEncoding ?? label, members: nil)
                        tags.append(tag)
                    }
                }
                self.tags = tags
            }
            self.endRefreshing()
        }
    }
}

// MARK: - Actions
extension TagsViewController {
    
    @IBAction func addNewTag() {
        let vc = TagEditViewController.instantiate(tag: nil)
        vc.completion = {
            self.loadData()
        }
        let navC = InteractivePopNavigationController(rootViewController: vc)
        self.present(navC, animated: true, completion: nil)
    }
}

// MARK: - TagsTableViewCell
class TagsTableViewCell: UITableViewCell {
    
    var aTag: Tag? {
        didSet {
            self.configureCell()
        }
    }
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblMembers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
        self.separatorInset = UIEdgeInsets.zero
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lblName.text = nil
        self.lblMembers.text = nil
    }
    
    func configureCell() {
        if let tag = self.aTag {
            self.lblName.text = "\(tag.label ?? "") (\(tag.members?.count ?? 0))"
            if let nameString = tag.members?.flatMap({ $0.username }).joined(separator: ", ") {
                self.lblMembers.text = nameString.count > 0 ? nameString : NSLocalizedString("tags_vc_no_member")
            } else {
                self.lblMembers.text = NSLocalizedString("tags_vc_loading_members")
            }
        } else {
            self.prepareForReuse()
        }
    }
}
