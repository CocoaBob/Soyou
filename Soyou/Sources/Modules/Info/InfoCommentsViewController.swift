//
//  InfoCommentsViewController.swift
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
//            "parentUsername": null,
//            "parentMatricule": null,
//            "parentComment": null
//        },
//        {
//            "id": 10,
//            "username": "jiyuny",
//            "matricule": 100001,
//            "comment": "Hh",
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
    var parentUsername: String?
    var parentMatricule: Int?
    var parentComment: String?
    
    init(id: Int = 0,
         username: String = "",
         matricule: Int = -1,
         comment: String = "",
         parentUsername: String? = nil,
         parentMatricule: Int? = nil,
         parentComment: String? = nil) {
        self.id = id
        self.username = username
        self.matricule = matricule
        self.comment = comment
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
        self.comment = json["comment"].stringValue
        self.parentUsername = json["parentUsername"].string
        self.parentMatricule = json["parentMatricule"].int
        self.parentComment = json["parentComment"].string
    }
}

class InfoCommentsViewController: UIViewController {
    
    var infoID: NSNumber!
    var commentIDs = [Int]()
    var commentsByID = [Int: Comment]()
    @IBOutlet var tableView: UITableView!
    @IBOutlet var btnWriteComment: UIButton!
    
    var dataProvider: ((_ relativeID: Int?, _ completion: @escaping ((_ data: Any?) -> ())) -> ())?
    var isCallingDataProvider = false
    
    // Class methods
    class func instantiate() -> InfoCommentsViewController {
        return UIStoryboard(name: "InfoViewController", bundle: nil).instantiateViewController(withIdentifier: "InfoCommentsViewController") as! InfoCommentsViewController
    }
    
    // UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("comments_vc_title")
        self.btnWriteComment.setTitle(NSLocalizedString("comments_vc_write_comment"), for: .normal)
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.tableView, 0, true, true, false, false)
        
        // Setups
        self.setupRefreshControls()
        
        // Setup table
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // Setup context menu
        let reply = UIMenuItem(title: NSLocalizedString("comments_vc_menu_reply"), action: #selector(InfoCommentsTableViewCell.reply))
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
extension InfoCommentsViewController {
    
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
                    self.commentsByID[comment.id] = comment
                    hasSmallerID = hasSmallerID || (commentID < lastSmallestID)
                }
            }
            self.commentIDs.sort(by: >)
        }
        return hasSmallerID
    }
}

//// MARK: UITableViewDataSource, UITableViewDelegate
extension InfoCommentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentIDs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "InfoCommentsTableViewCell", for: indexPath) as? InfoCommentsTableViewCell)!
        
        cell.infoCommentsViewController = self
        
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
extension InfoCommentsViewController {
    
    @IBAction func writeComment() {
        self.postNewComment(nil)
    }
}

// MARK: Post new comments {
extension InfoCommentsViewController: InfoNewCommentViewControllerDelegate {
    
    func postNewComment(_ replyToComment: Comment?) {
        let infoNewCommentViewController = InfoNewCommentViewController.instantiate()
        infoNewCommentViewController.infoID = self.infoID
        infoNewCommentViewController.replyToComment = replyToComment
        infoNewCommentViewController.delegate = self
        self.navigationController?.pushViewController(infoNewCommentViewController, animated: true)
    }
    
    func didPostNewComment() {
        self.loadNewData()
    }
}

// MARK: - Refreshing
extension InfoCommentsViewController {
    
    func setupRefreshControls() {
        guard let header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadNewData()
            self.beginRefreshing()
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
            if self.tableView.mj_header.isRefreshing() {
                self.tableView.mj_header.endRefreshing()
            }
            if self.tableView.mj_footer.isRefreshing() {
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

class InfoCommentsTableViewCell: UITableViewCell {
    
    @IBOutlet var tvContent: UITextView!
    var comment: Comment!
    weak var infoCommentsViewController: InfoCommentsViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        self.tvContent.text = nil
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func setup(_ comment: Comment) {
        self.comment = comment
        var attributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 15.0), NSForegroundColorAttributeName: UIColor.black]
        let attributedString = NSMutableAttributedString(string: comment.username, attributes: attributes)
        attributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 5.0)]
        attributedString.append(NSMutableAttributedString(string: "\n\n", attributes: attributes))
        attributes = [NSFontAttributeName : UIFont.systemFont(ofSize: 15.0), NSForegroundColorAttributeName: UIColor.black]
        attributedString.append(NSMutableAttributedString(string: comment.comment, attributes: attributes))
        if let parentUsername = self.comment.parentUsername, let parentComment = self.comment.parentComment {
            attributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 5.0)]
            attributedString.append(NSMutableAttributedString(string: "\n\n", attributes: attributes))
            attributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 15.0), NSForegroundColorAttributeName: UIColor.gray]
            attributedString.append(NSMutableAttributedString(string: "\(parentUsername): ", attributes: attributes))
            attributes = [NSFontAttributeName : UIFont.systemFont(ofSize: 15.0), NSForegroundColorAttributeName: UIColor.gray]
            attributedString.append(NSMutableAttributedString(string: "\(parentComment)", attributes: attributes))
        }
        self.tvContent.attributedText = attributedString
    }
    
    // MARK: Context menu
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) || action == #selector(InfoCommentsTableViewCell.reply) {
            return true
        }
        return false
    }
    
    func reply() {
        self.infoCommentsViewController.postNewComment(self.comment)
    }
    
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = self.comment.comment
    }
}
