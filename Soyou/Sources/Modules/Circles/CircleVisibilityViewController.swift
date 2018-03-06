//
//  CircleVisibilityViewController.swift
//  Soyou
//
//  Created by CocoaBob on 2018-03-05.
//  Copyright © 2018 Soyou. All rights reserved.
//

struct Visibility {
    static let everyone = 0
    static let followers = 1
    static let author = 2
    static let allowSelected = 3
    static let forbidSelected = 4
}

class CircleVisibilityViewController: UIViewController {
    
    // Properties
    @IBOutlet var tableView: UITableView!
    
    var selectedVisibility: Int = Visibility.followers
    var tags = [Tag]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var selectedTags = Set<Tag>()
    var isUnfolded = false
    var completionHandler: ((_ visibility: Int, _ allowedTags: [Tag]?,_ forbiddenTags: [Tag]?) -> ())?
    
    // Class methods
    class func instantiate() -> CircleVisibilityViewController {
        return  UIStoryboard(name: "CirclesViewController", bundle: nil).instantiateViewController(withIdentifier: "CircleVisibilityViewController") as! CircleVisibilityViewController
    }
    
    // Life Cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Titles
        self.title = NSLocalizedString("circles_visibility_vc_title")
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.tableView, 0, true, true, false, false)
        
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
extension CircleVisibilityViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfRows() -> Int {
        if selectedVisibility == Visibility.everyone ||
            selectedVisibility == Visibility.followers ||
            selectedVisibility == Visibility.author {
            return 5
        } else {
            return 5 + (isUnfolded ? self.tags.count : 0)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 4 ||
            (selectedVisibility == Visibility.allowSelected && indexPath.row == numberOfRows() - 1) ||
            (selectedVisibility != Visibility.allowSelected && indexPath.row == Visibility.forbidSelected) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CircleVisibilityTableViewCell", for: indexPath)
            if let cell = cell as? CircleVisibilityTableViewCell {
                if indexPath.row == Visibility.everyone {
                    cell.lblTitle.text = NSLocalizedString("circles_visibility_vc_everyone")
                    cell.lblSubTitle.text = NSLocalizedString("circles_visibility_vc_everyone_desc")
                    cell.imgSelection.isHidden = selectedVisibility != Visibility.everyone
                    cell.imgFolder.isHidden = true
                } else if indexPath.row == Visibility.followers {
                    cell.lblTitle.text = NSLocalizedString("circles_visibility_vc_followers")
                    cell.lblSubTitle.text = NSLocalizedString("circles_visibility_vc_followers_desc")
                    cell.imgSelection.isHidden = selectedVisibility != Visibility.followers
                    cell.imgFolder.isHidden = true
                } else if indexPath.row == Visibility.author {
                    cell.lblTitle.text = NSLocalizedString("circles_visibility_vc_author")
                    cell.lblSubTitle.text = NSLocalizedString("circles_visibility_vc_author_desc")
                    cell.imgSelection.isHidden = selectedVisibility != Visibility.author
                    cell.imgFolder.isHidden = true
                } else if indexPath.row == Visibility.allowSelected {
                    cell.lblTitle.text = NSLocalizedString("circles_visibility_vc_allowed_followers")
                    cell.lblSubTitle.text = NSLocalizedString("circles_visibility_vc_allowed_followers_desc")
                    cell.imgSelection.isHidden = selectedVisibility != Visibility.allowSelected
                    cell.imgFolder.isHidden = false
                    cell.imgFolder.image = UIImage(named:(selectedVisibility == Visibility.allowSelected && isUnfolded) ? "img_arrow_up" : "img_arrow_down")
                } else {
                    cell.lblTitle.text = NSLocalizedString("circles_visibility_vc_forbidden_followers")
                    cell.lblSubTitle.text = NSLocalizedString("circles_visibility_vc_forbidden_followers_desc")
                    cell.imgSelection.isHidden = selectedVisibility != Visibility.forbidSelected
                    cell.imgFolder.isHidden = false
                    cell.imgFolder.image = UIImage(named:(selectedVisibility == Visibility.forbidSelected && isUnfolded) ? "img_arrow_up" : "img_arrow_down")
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CircleVisibilityTagTableViewCell", for: indexPath)
            if let cell = cell as? CircleVisibilityTagTableViewCell {
                let tagIndex = indexPath.row - selectedVisibility - 1
                let tag = self.tags[tagIndex]
                let isSelected = self.selectedTags.contains(tag)
                cell.imgSelection.image = UIImage(named: isSelected ? "img_cell_checked" : "img_cell_unchecked")
                cell.lblTitle.text = tag.label
                cell.lblSubTitle.text = tag.memberNames()
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
                            self.tags[tagIndex].members = members
                            cell.lblSubTitle.text = tag.memberNames()
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
        // If it's now index 0, 1, 2
        if indexPath.row == Visibility.everyone || indexPath.row == Visibility.followers || indexPath.row == Visibility.author {
            selectedVisibility = indexPath.row
            isUnfolded = false
        }
        // If it was index 0, 1, 2
        else if selectedVisibility != Visibility.allowSelected && selectedVisibility != Visibility.forbidSelected {
            selectedVisibility = indexPath.row
            isUnfolded = indexPath.row == Visibility.allowSelected || indexPath.row == Visibility.forbidSelected
        }
        // If it was index 3
        else if selectedVisibility == Visibility.allowSelected {
            // It's now index 3, the same index
            if indexPath.row == Visibility.allowSelected {
                isUnfolded = !isUnfolded
            }
            // It's now index 4
            else if indexPath.row == numberOfRows() - 1 {
                selectedVisibility = Visibility.forbidSelected
                isUnfolded = true
                self.selectedTags.removeAll()
            }
            // A tag is selected
            else {
                let selectedTag = self.tags[indexPath.row - Visibility.allowSelected - 1]
                if self.selectedTags.contains(selectedTag) {
                    self.selectedTags.remove(selectedTag)
                } else {
                    self.selectedTags.insert(selectedTag)
                }
            }
        }
        // If it was index 4
        else if selectedVisibility == Visibility.forbidSelected {
            // It's now index 4, the same index
            if indexPath.row == Visibility.forbidSelected {
                isUnfolded = !isUnfolded
            }
            // It's now index 3
            else if indexPath.row == Visibility.allowSelected {
                selectedVisibility = Visibility.allowSelected
                isUnfolded = true
                self.selectedTags.removeAll()
            }
            // A tag is selected
            else {
                let selectedTag = self.tags[indexPath.row - Visibility.forbidSelected - 1]
                if self.selectedTags.contains(selectedTag) {
                    self.selectedTags.remove(selectedTag)
                } else {
                    self.selectedTags.insert(selectedTag)
                }
            }
        }
        // Reload table
        self.tableView.reloadData()
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}

// MARK: - Load data
extension CircleVisibilityViewController {
    
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
        }
    }
}

// MARK: - Actions
extension CircleVisibilityViewController {
    
    @IBAction func done() {
        var visibility = 0
        switch selectedVisibility {
        case Visibility.everyone:
            visibility = CircleVisibility.everyone
        case Visibility.followers:
            visibility = CircleVisibility.friends
        case Visibility.author:
            visibility = CircleVisibility.author
        case Visibility.allowSelected:
            visibility = CircleVisibility.friends
        case Visibility.forbidSelected:
            visibility = CircleVisibility.friends
        default:
            visibility = CircleVisibility.author
        }
        self.completionHandler?(visibility,
                                selectedVisibility == Visibility.allowSelected ? Array(self.selectedTags) : nil,
                                selectedVisibility == Visibility.forbidSelected ? Array(self.selectedTags) : nil)
        self.dismissSelf()
    }
}

// MARK: - CircleVisibilityTableViewCell
class CircleVisibilityTableViewCell: UITableViewCell {
    
    @IBOutlet var imgSelection: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var imgFolder: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgSelection.isHidden = true
        self.lblTitle.text = nil
        self.lblSubTitle.text = nil
        self.imgFolder.isHidden = true
    }
}

// MARK: - CircleVisibilityTagTableViewCell
class CircleVisibilityTagTableViewCell: UITableViewCell {
    
    @IBOutlet var imgSelection: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
        self.separatorInset = UIEdgeInsetsMake(0, 40, 0, 0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imgSelection.isHidden = false
        self.lblTitle.text = nil
        self.lblSubTitle.text = nil
    }
}
