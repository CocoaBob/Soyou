//
//  TagEditViewController.swift
//  Soyou
//
//  Created by CocoaBob on 2018-03-03.
//  Copyright © 2018 Soyou. All rights reserved.
//

class TagEditViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var completion: (()->())?
    
    fileprivate var originalTag: Tag?
    var tag: Tag = Tag()
    
    // Class methods
    class func instantiate(tag: Tag?) -> TagEditViewController {
        let vc = UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewController(withIdentifier: "TagEditViewController") as! TagEditViewController
        if let tag = tag {
            vc.tag = tag
            vc.originalTag = tag
        }
        return vc
    }
    
    // Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title
        self.title = NSLocalizedString("tag_edit_vc_title")
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.tableView, 0, true, true, true, false)
        
        // Setup Table
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Disable Save Button
        self.navigationItem.rightBarButtonItem?.isEnabled = false
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
extension TagEditViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    fileprivate func numberOfRows() -> Int {
        return self.tag.members?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return numberOfRows() + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TagsEditLabelTableViewCell", for: indexPath)
            if let cell = cell as? TagsEditLabelTableViewCell {
                cell.tfLabel.text = self.tag.label
                if cell.tfLabel.allTargets.count == 0 {
                    cell.tfLabel.addTarget(self, action: #selector(TagEditViewController.textFieldDidChange(_:)), for: .allEditingEvents)
                }
            }
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TagsAddMemberTableViewCell", for: indexPath)
                if let cell = cell as? TagsAddMemberTableViewCell {
                    cell.lblTitle.text = NSLocalizedString("tag_edit_vc_add_member")
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MembersTableViewCell", for: indexPath)
                if let cell = cell as? MembersTableViewCell, let tagUser = self.tag.members?[indexPath.row - 1] {
                    cell.member = Member(id: tagUser.userId, username: tagUser.username, profileUrl: tagUser.userProfileUrl)
                }
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        } else {
            return indexPath.row == 0 ? 44 : 64
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("tag_edit_vc_section_title_name")
        } else if section == 1 {
            return FmtString(NSLocalizedString("tag_edit_vc_section_title_member"), self.tag.members?.count ?? 0)
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                self.addMember()
            } else {
                if let tagUser = self.tag.members?[indexPath.row - 1] {
                    let circlesVC = CirclesViewController.instantiate(tagUser.userId, tagUser.userProfileUrl, tagUser.username)
                    self.navigationController?.pushViewController(circlesVC, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1 && indexPath.row > 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row >= 0 {
                self.tableView.beginUpdates()
                self.tag.members?.remove(at: indexPath.row - 1)
                self.tableView.deleteRows(at: [indexPath], with: .left)
                self.tableView.endUpdates()
                self.updateSaveButton()
            }
        }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}

// MARK: UITextFieldDelegate
extension TagEditViewController: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField:UITextField) {
        self.tag.label = textField.text
        self.updateSaveButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

// MARK: Routines
extension TagEditViewController {
    
    func updateSaveButton() {
        var isEnabled = true
        if self.tag.label?.count ?? 0 == 0 {
            isEnabled = false
        } else if let originalTag = self.originalTag {
            let originalLabel = originalTag.label ?? ""
            let currentLabel = self.tag.label ?? ""
            let originalIds = originalTag.members?.map({ $0.userId }) ?? [Int]()
            let currentIds = self.tag.members?.map({ $0.userId }) ?? [Int]()
            if originalLabel == currentLabel && originalIds == currentIds {
                isEnabled = false
            }
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = isEnabled
    }
}

// MARK: - Actions
extension TagEditViewController {

    @IBAction func addMember() {
        let vc = MembersViewController.instantiate()
        vc.userID = UserManager.shared.userID
        vc.isShowingFollowers = true
        vc.isSegmentedControlHidden = true
        vc.isSearchBarHidden = true
        vc.isSelectionMode = true
        vc.excludedUsers = self.tag.members?.map { Member.init(id: $0.userId, gender: "", username: $0.username, profileUrl: $0.userProfileUrl, matricule: -1, badges: nil) }
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: vc, action: #selector(dismissSelf))
        vc.completionHandler = { members in
            for member in members {
                let tagUser = TagUser(userId: member.id, username: member.username, userProfileUrl: member.profileUrl)
                self.tag.addMember(member: tagUser)
            }
            self.tableView.reloadData()
            self.updateSaveButton()
        }
        let navC = InteractivePopNavigationController(rootViewController: vc)
        self.present(navC, animated: true, completion: nil)
    }
    
    @IBAction func save() {
        self.view.endEditing(true)
        MBProgressHUD.show(self.view)
        // Create Tag / Update Label
        var label = self.tag.label ?? ""
        label = label.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) ?? label
        let completeAndDismissSelf = {
            MBProgressHUD.hide(self.view)
            self.completion?()
            self.dismissSelf()
        }
        DataManager.shared.createOrModifyTag(self.tag.id, label: label) { (responseObject, error) in
            if let responseObject = responseObject,
                let data = DataManager.getResponseData(responseObject) as? NSDictionary,
                let tagID = data["id"] as? Int,
                let currentUserIds = self.tag.members?.flatMap({ $0.userId }) {
                // Collected added/removed user IDs
                var addedUserIds: [Int]?
                var removedUserIds: [Int]?
                
                if let originalUserIds = self.originalTag?.members?.flatMap({ $0.userId }) {
                    addedUserIds = currentUserIds.filter { !originalUserIds.contains($0) }
                    removedUserIds = originalUserIds.filter { !currentUserIds.contains($0) }
                } else {
                    addedUserIds = currentUserIds
                }
                
                // Nothing changed, complete
                if addedUserIds == nil && removedUserIds == nil {
                    completeAndDismissSelf()
                }
                // Submit added/removed user IDs
                else {
                    let dispatchGroup = DispatchGroup()
                    if let addedUserIds = addedUserIds {
                        dispatchGroup.enter()
                        DataManager.shared.addOrRemoveMembersForTag(tagID, isAdd: true, userIds: addedUserIds, { (responseObject, error) in
                            dispatchGroup.leave()
                        })
                    }
                    if let removedUserIds = removedUserIds {
                        dispatchGroup.enter()
                        DataManager.shared.addOrRemoveMembersForTag(tagID, isAdd: false, userIds: removedUserIds, { (responseObject, error) in
                            dispatchGroup.leave()
                        })
                    }
                    dispatchGroup.notify(queue: .main) {
                        completeAndDismissSelf()
                    }
                }
            } else {
                completeAndDismissSelf()
            }
        }
    }
}

// MARK: - TagsAddMemberTableViewCell
class TagsAddMemberTableViewCell: UITableViewCell {
    
    @IBOutlet var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
        self.separatorInset = UIEdgeInsets.zero
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lblTitle.text = nil
    }
}


// MARK: - TagsEditLabelTableViewCell
class TagsEditLabelTableViewCell: UITableViewCell {
    
    @IBOutlet var tfLabel: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
        self.separatorInset = UIEdgeInsets.zero
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.tfLabel.text = nil
    }
}
