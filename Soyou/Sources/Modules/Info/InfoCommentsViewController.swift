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
    
    var dataProvider: ((completion: ((data: AnyObject?) -> ())) -> ())?
    
    // Class methods
    class func instantiate() -> InfoCommentsViewController {
        return (UIStoryboard(name: "InfoViewController", bundle: nil).instantiateViewControllerWithIdentifier("InfoCommentsViewController") as? InfoCommentsViewController)!
    }
    
    // UIViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("comments_vc_title")
        
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
        
        self.reloadComments()
        self.hideToolbar(false)
    }
}

// MARK: Comments data
extension InfoCommentsViewController {
    
    private func reloadComments() {
        if let dataProvider = self.dataProvider {
            MBProgressHUD.showLoader(self.view)
            dataProvider(completion: { (responseObject) in
                guard let responseObject = responseObject as? [String: AnyObject] else { return }
                guard let data = responseObject["data"] else { return }
                self.prepareCommentsData(data)
                self.tableView.reloadData()
                MBProgressHUD.hideLoader(self.view)
            })
        }
    }
    
    private func prepareCommentsData(data: AnyObject) {
        let json = JSON(data)
        if !json.isEmpty {
            self.commentIDs.removeAll()
            self.commentsByID.removeAll()
            for (_, item) in json {
                let comment = Comment(json: item)
                self.commentIDs.append(comment.id)
                self.commentsByID[comment.id] = comment
            }
            self.commentIDs.sortInPlace()
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
        self.reloadComments()
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
