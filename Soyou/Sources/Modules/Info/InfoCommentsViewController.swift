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
//            "id": 1,
//            "username": "Jime",
//            "matricule": 123455,
//            "comment": "comment content1",
//            "parentId": null
//        },
//        {
//            "id": 2,
//            "username": "Mike",
//            "matricule": 12,
//            "comment": "comment content2",
//            "parentId": 1
//        }
//    ]
//}

struct Comment {
    var id: Int = 0
    var username: String = ""
    var matricule: String = ""
    var comment: String = ""
    var parentId: Int = -1
    
    init(id: Int = 0,
         username: String = "",
         matricule: String = "",
         comment: String = "",
         parentId: Int = -1) {
        self.id = id
        self.username = username
        self.matricule = matricule
        self.comment = comment
        self.parentId = parentId
    }
    
    init() {
        
    }
    
    init(json: JSON) {
        self.importDataFromJSON(json)
    }
    
    mutating func importDataFromJSON(json: JSON) {
        self.id = json["id"].intValue
        self.username = json["username"].stringValue
        self.matricule = json["matricule"].stringValue
        self.comment = json["comment"].stringValue
        self.parentId = json["parentId"].intValue
    }
}

class InfoCommentsViewController: UIViewController {
    
    var infoID: NSNumber!
    var commentIDs: [Int] = [Int]()
    var commentsByID: [Int: Comment] = [Int: Comment]()
    @IBOutlet var tableView: UITableView!
    
    var dataProvider: ((relativeID: Int?, completion: ((data: AnyObject?) -> ())) -> ())?
    var isCallingDataProvider = false
    var hasNoMoreData = false
    
    // Class methods
    class func instantiate() -> InfoCommentsViewController {
        return (UIStoryboard(name: "InfoViewController", bundle: nil).instantiateViewControllerWithIdentifier("InfoCommentsViewController") as? InfoCommentsViewController)!
    }
    
    // UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("comments_vc_title")
        
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
        UIMenuController.sharedMenuController().menuItems = [reply]
        UIMenuController.sharedMenuController().update()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        self.hideToolbar(false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loadData(nil)
        self.hideToolbar(false)
    }
}

// MARK: Comments data
extension InfoCommentsViewController {
    
    private func loadData(relativeID: Int?) {
        // Avoid multiple calling
        if self.isCallingDataProvider {
            return
        }
        if let dataProvider = self.dataProvider {
            self.isCallingDataProvider = true
            self.beginRefreshing()
            dataProvider(relativeID: relativeID, completion: { (responseObject) in
                guard let responseObject = responseObject as? [String: AnyObject] else { return }
                guard let data = responseObject["data"] as? [NSDictionary] else { return }
                
                self.appendCommentsWithData(data)
                self.tableView.reloadData()
                self.isCallingDataProvider = false
                self.endRefreshing(data.count)
            })
        }
    }
    
    private func loadNextData() {
        self.loadData(self.commentIDs.last)
    }
    
    private func appendCommentsWithData(data: AnyObject) {
        let json = JSON(data)
        if !json.isEmpty {
            // Get all IDs and Comments
            var tempCommentIDs: [Int] = [Int]()
            var tempCommentsByID: [Int: Comment] = [Int: Comment]()
            for (_, item) in json {
                let comment = Comment(json: item)
                tempCommentIDs.append(comment.id)
                tempCommentsByID[comment.id] = comment
            }
            // Remove existing comments
            let newIDs = tempCommentIDs.filter() { !self.commentIDs.contains($0) }
            // Add new comments to data source
            for id in newIDs {
                self.commentIDs.append(id)
                self.commentsByID[id] = tempCommentsByID[id]
            }
            self.commentIDs.sortInPlace(>)
        } else {
            // Has no more data, stop automatically requesting more data
            self.hasNoMoreData = true
        }
    }
}

//// MARK: UITableViewDataSource, UITableViewDelegate
extension InfoCommentsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentIDs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCellWithIdentifier("InfoCommentsTableViewCell", forIndexPath: indexPath) as? InfoCommentsTableViewCell)!
        
        cell.infoCommentsViewController = self
        
        let comment = self.commentsByID[self.commentIDs[indexPath.row]]!
        var parent: Comment?
        if comment.parentId != -1 {
            parent = self.commentsByID[comment.parentId]
        }
        
        cell.setup(comment, parent: parent)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) else { return }
        
        cell.becomeFirstResponder()
        UIMenuController.sharedMenuController().setTargetRect(cell.bounds, inView: cell)
        UIMenuController.sharedMenuController().setMenuVisible(true, animated: true)
    }
    
    // MARK: Context menu
    func tableView(tableView: UITableView, shouldShowMenuForRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, performAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    }
}

// MARK: UIScrollViewDelegate
//extension InfoCommentsViewController {
//    
//    func scrollViewDidScroll(scrollView: UIScrollView) {
//        // If it's close to the end of the scroll view, request more data
//        if !self.hasNoMoreData {
//            let bottom = scrollView.contentOffset.y + scrollView.frame.height - scrollView.contentInset.bottom
//            if bottom > scrollView.contentSize.height - 64 { // 64 points to the end
//                self.loadNextData()
//            }
//        }
//    }
//}

// MARK: Actions
extension InfoCommentsViewController {
    
    @IBAction func writeComment() {
        self.postNewComment(nil)
    }
}

// MARK: Post new comments {
extension InfoCommentsViewController: InfoNewCommentViewControllerDelegate {
    
    func postNewComment(replyToComment: Comment?) {
        let infoNewCommentViewController = InfoNewCommentViewController.instantiate()
        infoNewCommentViewController.infoID = self.infoID
        infoNewCommentViewController.replyToComment = replyToComment
        infoNewCommentViewController.delegate = self
        self.navigationController?.pushViewController(infoNewCommentViewController, animated: true)
    }
    
    func didPostNewComment() {
        self.loadData(nil)
    }
}

// MARK: - Refreshing
extension InfoCommentsViewController {
    
    func setupRefreshControls() {
        let header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadData(nil)
            self.beginRefreshing()
        })
        header.setTitle(NSLocalizedString("pull_to_refresh_header_idle"), forState: .Idle)
        header.setTitle(NSLocalizedString("pull_to_refresh_header_pulling"), forState: .Pulling)
        header.setTitle(NSLocalizedString("pull_to_refresh_header_refreshing"), forState: .Refreshing)
        header.setTitle(NSLocalizedString("pull_to_refresh_no_more_data"), forState: .NoMoreData)
        header.lastUpdatedTimeLabel?.hidden = true
        self.tableView.mj_header = header
        
        let footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            self.loadNextData()
        })
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_idle"), forState: .Idle)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_pulling"), forState: .Pulling)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_refreshing"), forState: .Refreshing)
        footer.setTitle(NSLocalizedString("pull_to_refresh_no_more_data"), forState: .NoMoreData)
        footer.automaticallyHidden = false
        self.tableView.mj_footer = footer
    }
    
    func beginRefreshing() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func endRefreshing(resultCount: Int) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.mj_header.endRefreshing()
            if resultCount > 0 {
                self.tableView.mj_footer.endRefreshing()
            } else {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }
        })
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

class InfoCommentsTableViewCell: UITableViewCell {
    @IBOutlet var lblUsername: UILabel!
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
        self.lblUsername.text = nil
        self.tvContent.text = nil
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func setup(comment: Comment, parent: Comment?) {
        self.comment = comment
        self.lblUsername.text = comment.username
        var attributes = [NSFontAttributeName : UIFont.systemFontOfSize(15.0), NSForegroundColorAttributeName: UIColor.blackColor()]
        let attributedString = NSMutableAttributedString(string: comment.comment, attributes: attributes)
        if let parent = parent {
            attributes = [NSFontAttributeName : UIFont.boldSystemFontOfSize(15.0), NSForegroundColorAttributeName: UIColor.grayColor()]
            attributedString.appendAttributedString(NSMutableAttributedString(string: "\n\(parent.username): ", attributes: attributes))
            attributes = [NSFontAttributeName : UIFont.systemFontOfSize(15.0), NSForegroundColorAttributeName: UIColor.grayColor()]
            attributedString.appendAttributedString(NSMutableAttributedString(string: "\(parent.comment)", attributes: attributes))
        }
        self.tvContent.attributedText = attributedString
    }
    
    // MARK: Context menu
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == #selector(NSObject.copy(_:)) || action == #selector(InfoCommentsTableViewCell.reply) {
            return true
        }
        return false
    }
    
    func reply() {
        self.infoCommentsViewController.postNewComment(self.comment)
    }
    
    override func copy(sender: AnyObject?) {
        UIPasteboard.generalPasteboard().string = self.comment.comment
    }
}
