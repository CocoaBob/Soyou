//
//  TagsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 2018-02-25.
//  Copyright © 2018 Soyou. All rights reserved.
//

struct TagUser {
    var userId: Int?
    var username: String?
    var userProfileUrl: String?
}

struct Tag {
    var id: Int?
    var label: String?
    var members: [TagUser]?
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
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.tableView, 0, true, true, false, false)
        
        // Setup Table
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.separatorColor = UIColor.clear
        
        // Load data
        self.loadData()
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
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
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
                        let tag = Tag(id: id, label: label, members: nil)
                        tags.append(tag)
                    }
                }
                self.tags = tags
            }
        }
    }
}

// MARK: - Actions
extension TagsViewController {
    
    @IBAction func addNewTag() {
        
    }
}
class TagsTableViewCell: UITableViewCell {
    
    var aTag: Tag? {
        didSet {
            self.configureCell()
            guard let tag = self.aTag, let tagId = tag.id else {
                return
            }
            if tag.members == nil {
                DataManager.shared.allMembersOfTag(tagId) { responseObject, error in
                    if let responseObject = responseObject as? Dictionary<String, AnyObject>,
                        let data = responseObject["data"] as? [NSDictionary] {
                        var members = [TagUser]()
                        for dict in data {
                            if let userId = dict["userId"] as? Int,
                                var username = dict["username"] as? String,
                                let userProfileUrl = dict["userProfileUrl"] as? String {
                                username = username.removingPercentEncoding ?? username
                                let user = TagUser(userId: userId, username: username, userProfileUrl: userProfileUrl)
                                members.append(user)
                            }
                        }
                        self.aTag?.members = members
                        self.configureCell()
                    }
                }
            }
        }
    }
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblMembers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
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
