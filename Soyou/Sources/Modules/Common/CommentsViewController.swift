//
//  CommentsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 08/07/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

//{
//    "message":"OK",
//    "data": [
//        {
//            "id": 13,
//            "username": "jiyuny",
//            "matricule": 100001,
//            "comment": "哈哈哈就",
//            "canDelete": 1,
//            "parentUsername": null,
//            "parentMatricule": null,
//            "parentComment": null
//        },
//        {
//            "id": 10,
//            "username": "jiyuny",
//            "matricule": 100001,
//            "comment": "Hh",
//            "canDelete": 0,
//            "parentUsername": "CocoaBob",
//            "parentMatricule": 100003,
//            "parentComment": "Test Comment at 491439367.379247"
//        }
//    ]
//}

struct Comment {
    var id: Int = 0
    var username: String = ""
    var matricule: Int = -1
    var comment: String = ""
    var canDelete: Int = 0
    var parentUsername: String?
    var parentMatricule: Int?
    var parentComment: String?
    
    init(id: Int = 0,
         username: String = "",
         matricule: Int = -1,
         comment: String = "",
         canDelete: Int = 0,
         parentUsername: String? = nil,
         parentMatricule: Int? = nil,
         parentComment: String? = nil) {
        self.id = id
        self.username = username
        self.matricule = matricule
        self.comment = comment
        self.canDelete = canDelete
        self.parentUsername = parentUsername
        self.parentMatricule = parentMatricule
        self.parentComment = parentComment
    }
    
    init() {
        
    }
    
    init(json: JSON) {
        self.importDataFromJSON(json)
    }
    
    mutating func importDataFromJSON(_ json: JSON) {
        self.id = json["id"].intValue
        self.username = json["username"].stringValue
        self.matricule = json["matricule"].intValue
        self.comment = json["comment"].stringValue.removingPercentEncoding ?? ""
        self.canDelete = json["canDelete"].intValue
        self.parentUsername = json["parentUsername"].string
        self.parentMatricule = json["parentMatricule"].int
        self.parentComment = json["parentComment"].string?.removingPercentEncoding
    }
}

class CommentsViewController: UIViewController {
    
    var infoID: Int!
    var commentIDs = [Int]()
    var commentsByID = [Int: Comment]()
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnComposeComment: UIButton!
    
    var dataProvider: ((_ relativeID: Int?, _ completion: @escaping DataClosure) -> ())?
    var isCallingDataProvider = false
    
    var commentCreator: ((_ id: Int, _ commentId: Int?, _ comment: String, _ completion: @escaping CompletionClosure) -> ())?
    var commentDeletor: ((_ commentID: Int, _ completion: @escaping CompletionClosure) -> ())?
    
    // Class methods
    class func instantiate() -> CommentsViewController {
        return UIStoryboard(name: "InfoViewController", bundle: nil).instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
    }
    
    // UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("comments_vc_title")
        self.btnComposeComment.setTitle(NSLocalizedString("comments_vc_compose_comment"), for: .normal)
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.tableView, 0, true, true, false, false)
        
        // Setups
        self.setupRefreshControls()
        
        // Setup table
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Setup context menu
        let reply = UIMenuItem(title: NSLocalizedString("comments_vc_menu_reply"), action: #selector(CommentsTableViewCell.reply))
        UIMenuController.shared.menuItems = [reply]
        UIMenuController.shared.update()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        self.hideToolbar(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadData(nil)
        self.hideToolbar(false)
    }
}

// MARK: Comments data
extension CommentsViewController {
    
    fileprivate func loadData(_ relativeID: Int?) {
        // Avoid multiple calling
        if self.isCallingDataProvider {
            return
        }
        if let dataProvider = self.dataProvider {
            self.isCallingDataProvider = true
            self.beginRefreshing()
            dataProvider(relativeID, { (responseObject) in
                guard let responseObject = responseObject as? [String: Any] else { return }
                guard let data = responseObject["data"] else { return }
                
                let hasEarlierComments = self.appendCommentsWithData(data)
                self.tableView.reloadData()
                self.isCallingDataProvider = false
                
                if let _ = relativeID {
                    self.endRefreshing(hasEarlierComments) // If it was loading earlier comments but no result, hide footer
                } else {
                    self.endRefreshing(nil)
                }
            })
        }
    }
    
    fileprivate func loadNextData() {
        if let lastID = self.commentIDs.last, let lastComment = self.commentsByID[lastID] {
            self.loadData(lastComment.id)
        } else {
            self.loadData(0)
        }
    }
    
    fileprivate func loadNewData() {
        self.loadData(nil)
    }
    
    // Return true if get earlier comments
    fileprivate func appendCommentsWithData(_ data: Any) -> Bool {
        var hasSmallerID = false
        let json = JSON(data)
        if !json.isEmpty {
            let lastSmallestID = self.commentIDs.last ?? Int.max
            for (_, item) in json {
                let comment = Comment(json: item)
                let commentID = comment.id
                if !self.commentIDs.contains(commentID) {
                    self.commentIDs.append(commentID)
                }
                hasSmallerID = hasSmallerID || (commentID < lastSmallestID)
                self.commentsByID[comment.id] = comment
            }
            self.commentIDs.sort(by: >)
        }
        return hasSmallerID
    }
}

//// MARK: UITableViewDataSource, UITableViewDelegate
extension CommentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: indexPath) as? CommentsTableViewCell)!
        
        cell.CommentsViewController = self
        
        if let comment = self.commentsByID[self.commentIDs[indexPath.row]] {
            cell.setup(comment)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        cell.becomeFirstResponder()
        UIMenuController.shared.setTargetRect(cell.bounds, in: cell)
        UIMenuController.shared.setMenuVisible(true, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let comment = self.commentsByID[self.commentIDs[indexPath.row]] {
            return comment.canDelete == 1
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        self.deleteComment(commentID: self.commentIDs[indexPath.row])
    }
    
    // MARK: Context menu
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
    }
}

// MARK: Actions
extension CommentsViewController {
    
    @IBAction func composeComment() {
        UserManager.shared.loginOrDo {
            self.postNewComment(nil)
        }
    }
    
    func deleteComment(commentID: Int) {
        guard let _ = self.commentsByID[commentID] else {
            if let index = self.commentIDs.index(of: commentID) {
                self.commentIDs.remove(at: index)
            }
            return
        }
        
        let alertController = UIAlertController(title: nil,
                                                message: NSLocalizedString("comments_vc_delete_comment_alert"),
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("comments_vc_delete_comment_alert_action"),
                                                style: UIAlertActionStyle.destructive,
                                                handler: { (action: UIAlertAction) -> Void in
                                                    if let commentDeletor = self.commentDeletor {
                                                        MBProgressHUD.show(self.view)
                                                        commentDeletor(commentID) { (responseObject, error) -> () in
                                                            if error == nil {
                                                                self.commentsByID.removeValue(forKey: commentID)
                                                                if let index = self.commentIDs.index(of: commentID) {
                                                                    self.commentIDs.remove(at: index)
                                                                }
                                                                self.tableView.reloadData()
                                                            }
                                                            MBProgressHUD.hide(self.view)
                                                        }
                                                    }
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("alert_button_cancel"),
                                                style: UIAlertActionStyle.cancel,
                                                handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: Post new comments {
extension CommentsViewController: CommentComposeViewControllerDelegate {
    
    func postNewComment(_ replyToComment: Comment?) {
        let commentComposeViewController = CommentComposeViewController.instantiate()
        commentComposeViewController.infoID = self.infoID
        commentComposeViewController.replyToComment = replyToComment
        commentComposeViewController.delegate = self
        commentComposeViewController.commentCreator = self.commentCreator
        self.navigationController?.pushViewController(commentComposeViewController, animated: true)
    }
    
    func didPostNewComment() {
        self.loadNewData()
    }
}

// MARK: - Refreshing
extension CommentsViewController {
    
    func setupRefreshControls() {
        guard let header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadNewData()
        }) else { return }
        header.setTitle(NSLocalizedString("pull_to_refresh_header_idle"), for: .idle)
        header.setTitle(NSLocalizedString("pull_to_refresh_header_pulling"), for: .pulling)
        header.setTitle(NSLocalizedString("pull_to_refresh_header_refreshing"), for: .refreshing)
        header.setTitle(NSLocalizedString("pull_to_refresh_no_more_data"), for: .noMoreData)
        header.lastUpdatedTimeLabel?.isHidden = true
        self.tableView.mj_header = header
        
        guard let footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            self.loadNextData()
        }) else { return }
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_idle"), for: .idle)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_pulling"), for: .pulling)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_refreshing"), for: .refreshing)
        footer.setTitle(NSLocalizedString("pull_to_refresh_no_more_data"), for: .noMoreData)
        footer.isAutomaticallyHidden = false
        self.tableView.mj_footer = footer
    }
    
    func beginRefreshing() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func endRefreshing(_ hasEarlierData: Bool?) {
        DispatchQueue.main.async {
            if self.tableView.mj_header.isRefreshing {
                self.tableView.mj_header.endRefreshing()
            }
            if self.tableView.mj_footer.isRefreshing {
                if let hasEarlierData = hasEarlierData {
                    if hasEarlierData {
                        self.tableView.mj_footer.endRefreshing()
                    } else {
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()
                    }
                } else {
                    self.tableView.mj_footer.endRefreshing()
                }
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

class CommentsTableViewCell: UITableViewCell {
    
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var imgMore: UIImageView!
    @IBOutlet var lblComment: UILabel!
    @IBOutlet var marginConstraint: NSLayoutConstraint!
    @IBOutlet var lblParentComment: UILabel!
    @IBOutlet var viewQuote: UIView!
    
    var comment: Comment!
    weak var CommentsViewController: CommentsViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        self.lblUsername.text = nil
        self.imgMore.isHidden = true
        self.lblComment.text = nil
        self.lblParentComment.text = nil
        self.lblParentComment.font = UIFont.systemFont(ofSize: 7)
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let bgColor = self.viewQuote.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        self.viewQuote.backgroundColor = bgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let bgColor = self.viewQuote.backgroundColor
        super.setSelected(selected, animated: animated)
        self.viewQuote.backgroundColor = bgColor
    }
    
    func setup(_ comment: Comment) {
        self.comment = comment
        // Username
        self.lblUsername.text = self.comment.username
        // More
        self.imgMore.isHidden = self.comment.canDelete == 0
        // Comment
        let attr1 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15.0),
                     NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        let attrStr1 = NSAttributedString(string: comment.comment, attributes: attr1)
        self.lblComment.attributedText = attrStr1
        // Parent Comment
        let attrStr2 = NSMutableAttributedString()
        if let parentUsername = self.comment.parentUsername, let parentComment = self.comment.parentComment {
            attrStr2.append(NSAttributedString(string: "\(parentUsername): ",
                attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15.0),
                             NSAttributedStringKey.foregroundColor: UIColor.gray]))
            attrStr2.append(NSAttributedString(string: "\(parentComment)",
                attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15.0),
                             NSAttributedStringKey.foregroundColor: UIColor.gray]))
        }
        // If there's parentMatricule, but no parentUsername and parentComment, it means the parent comment has been deleted
        else if let _ = self.comment.parentMatricule {
            attrStr2.append(NSAttributedString(string: NSLocalizedString("comments_vc_deleted_parent"),
                                               attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15.0),
                                                            NSAttributedStringKey.foregroundColor: UIColor.gray]))
        }
        if attrStr2.length > 0 {
            self.lblParentComment.attributedText = attrStr2
            self.marginConstraint.constant = 8
        } else {
            self.lblParentComment.attributedText = nil
            self.marginConstraint.constant = 0
        }
    }
    
    // MARK: Context menu
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(CommentsTableViewCell.reply) {
            return true
        } else if action == #selector(delete(_:)) && self.comment.canDelete == 1 {
            return true
        }
        return false
    }
    
    @objc func reply() {
        self.CommentsViewController.postNewComment(self.comment)
    }
    
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = self.comment.comment
    }
    
    override func delete(_ sender: Any?) {
        self.CommentsViewController.deleteComment(commentID: self.comment.id)
    }
}
