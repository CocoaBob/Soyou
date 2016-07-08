//
//  InfoCommentsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 08/07/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

struct Comment {
    var id: Int?
    var username: String?
    var matricule: String?
    var comment: String?
    var parentId: Int?
    
    init(id: Int? = nil,
         username: String? = nil,
         matricule: String? = nil,
         comment: String? = nil,
         parentId: Int? = nil) {
        self.id = id
        self.username = username
        self.matricule = matricule
        self.comment = comment
        self.parentId = parentId
    }
    
//    init() {
//        
//    }
//    
//    init(json: JSON) {
//        self.importDataFromJSON(json)
//    }
//    
//    mutating func importDataFromJSON(json: JSON) {
//        self.title_line1 = json["title_line1"].stringValue
//        self.title_line2 = json["title_line2"].stringValue
//        self.start_date = Cons.utcDateFormatter.dateFromString(json["start_date"].stringValue)
//        if let isStreaming = json["stream_currently_streaming"].bool {
//            self.stream_currently_streaming = isStreaming
//        } else {
//            self.stream_currently_streaming = json["currently_streaming"].boolValue
//        }
//        self.movie_id = json["movie_id"].int
//        self.image_main_720x405 = NSURL(string: json["image_main_720x405"].stringValue)
//        self.duration = json["duration"].int
//        
//        self.isInitialized = true
//    }
}

class InfoCommentsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var dataProvider: (()->(AnyObject))?
    
    // Class methods
    class func instantiate() -> InfoCommentsViewController {
        return (UIStoryboard(name: "InfoViewController", bundle: nil).instantiateViewControllerWithIdentifier("InfoCommentsViewController") as? InfoCommentsViewController)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let dataProvider = self.dataProvider {
            MBProgressHUD.showLoader(self.view)
            let data = dataProvider()
            MBProgressHUD.hideLoader(self.view)
        }
    }
}

//// MARK: UITableViewDataSource, UITableViewDelegate
//extension InfoCommentsViewController: UITableViewDataSource, UITableViewDelegate {
//    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return sections.count
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return sections[section].rows.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let row = sections[indexPath.section].rows[indexPath.row]
//        
//        return cell
//    }
//    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        let row = sections[indexPath.section].rows[indexPath.row]
//        return row.cell.height ?? UITableViewAutomaticDimension
//    }
//    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sections[section].headerTitle
//    }
//    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return (sections[section].headerTitle != nil) ? UITableViewAutomaticDimension : 15
//    }
//    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return nil
//    }
//    
//    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        return sections[section].footerTitle
//    }
//    
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return (sections[section].footerTitle != nil) ? UITableViewAutomaticDimension : 5
//    }
//    
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return nil
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        
//        let row = sections[indexPath.section].rows[indexPath.row]
//        if let didSelectClosure = row.didSelect {
//            didSelectClosure(tableView, indexPath)
//        }
//        
//        self.selectedIndexPath = indexPath
//    }
//}
