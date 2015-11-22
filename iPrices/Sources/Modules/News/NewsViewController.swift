//
//  ViewController.swift
//  iPrices
//
//  Created by CocoaBob on 15/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class NewsViewController: BaseTableViewController {
    
    var moreButtonCell: NewsTableViewCellMore?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = UIColor.clearColor();
        
        setupRefreshControls()
        
        requestNewsList(nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        return News.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "datePublication:false,id:false,isMore:true", ascending: false)
    }
    
}

// MARK: Data
extension NewsViewController {
    
    private func resetMoreButtonCell() {
        if let cell = self.moreButtonCell {
            cell.indicator?.hidden = true
            cell.moreImage?.hidden = false
        }
    }
    
    private func handleSuccess(responseObject: AnyObject?, _ relativeID: NSNumber?) {
        self.endRefreshing()
        resetMoreButtonCell()
        
        guard let responseObject = responseObject as? Dictionary<String, AnyObject> else { return }
        let allNews = responseObject["data"] as? [NSDictionary]
        News.importDatas(allNews, relativeID)
    }
    
    private func handleError(error: NSError?) {
        self.endRefreshing()
        resetMoreButtonCell()
        
        print("\(error)")
    }
    
    func requestNewsList(relativeID: NSNumber?) {
        /////// Cons.Svr.reqCnt
        ServerManager.shared.requestNewsList(Cons.Svr.reqCnt, relativeID,
            { (responseObject: AnyObject?) -> () in self.handleSuccess(responseObject, relativeID) },
            { (error: NSError?) -> () in self.handleError(error) }
        );
    }
    
}

// MARK: UITableViewDataSource/UITableViewDelegate
extension NewsViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = self.fetchedResultsController.sections {
            return sections[section].numberOfObjects
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let news: News = self.fetchedResultsController.objectAtIndexPath(indexPath) as! News
        
        if news.isMore != nil && news.isMore!.boolValue {
            let cell: NewsTableViewCellMore = tableView.dequeueReusableCellWithIdentifier("NewsTableViewCellMore", forIndexPath: indexPath) as! NewsTableViewCellMore
            cell.indicator?.hidden = true
            cell.moreImage?.hidden = false
            return cell
        } else {
            let cell: NewsTableViewCell = tableView.dequeueReusableCellWithIdentifier("NewsTableViewCell", forIndexPath: indexPath) as! NewsTableViewCell
            cell.tltTextView?.text = news.title
            if let imageURLString = news.image, let imageURL = NSURL(string: imageURLString) {
                cell.bgImageView?.sd_setImageWithURL(imageURL, completed: { (image: UIImage!, error: NSError!, type: SDImageCacheType, url: NSURL!) -> Void in
                    cell.bgImageView?.hidden = false
                })
            }
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let news: News = self.fetchedResultsController.objectAtIndexPath(indexPath) as! News
        MagicalRecord.saveWithBlockAndWait { (localContext: NSManagedObjectContext!) -> Void in
            let localNews = news.MR_inContext(localContext)
            if localNews.isMore != nil && localNews.isMore!.boolValue {
                if let cell = tableView.cellForRowAtIndexPath(indexPath) as? NewsTableViewCellMore {
                    cell.indicator?.startAnimating()
                    cell.indicator?.hidden = false
                    cell.moreImage?.hidden = true
                    self.moreButtonCell = cell
                }
                self.requestNewsList(localNews.id)
            }
        }
    }
    
}

// MARK: Refreshing
extension NewsViewController {
    
    func setupRefreshControls() {
        let header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.requestNewsList(nil)
            self.beginRefreshing()
        });
        header.setTitle(NSLocalizedString("pull_to_refresh_header_idle", comment: ""), forState: .Idle)
        header.setTitle(NSLocalizedString("pull_to_refresh_header_pulling", comment: ""), forState: .Pulling)
        header.setTitle(NSLocalizedString("pull_to_refresh_header_refreshing", comment: ""), forState: .Refreshing)
        header.setTitle(NSLocalizedString("pull_to_refresh_no_more_data", comment: ""), forState: .NoMoreData)
        header.lastUpdatedTimeText = { (date: NSDate!) -> (String!) in
            if date == nil {
                return FmtString(NSLocalizedString("pull_to_refresh_header_last_updated", comment: ""), NSLocalizedString("pull_to_refresh_header_never", comment: ""))
            }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd HH:mm"
            let dateString = dateFormatter.stringFromDate(date)
            return FmtString(NSLocalizedString("pull_to_refresh_header_last_updated", comment: ""), dateString)
        }
        header.lastUpdatedTimeKey = header.lastUpdatedTimeKey
        self.tableView.mj_header = header
        
        let footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            let lastNews = self.fetchedResultsController.fetchedObjects?.last as? News
            self.requestNewsList(lastNews?.id)
            self.beginRefreshing()
        });
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_idle", comment: ""), forState: .Idle)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_pulling", comment: ""), forState: .Pulling)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_refreshing", comment: ""), forState: .Refreshing)
        footer.setTitle(NSLocalizedString("pull_to_refresh_no_more_data", comment: ""), forState: .NoMoreData)
        self.tableView.mj_footer = footer
    }
    
    func beginRefreshing() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func endRefreshing() {
        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_footer.endRefreshing()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

class NewsTableViewCell: UITableViewCell {
    @IBOutlet var tltTextView: UITextView?
    @IBOutlet var bgImageView: UIImageView?
    
    override func prepareForReuse() {
        tltTextView?.text = ""
        bgImageView?.hidden = true
    }
}

class NewsTableViewCellMore: UITableViewCell {
    @IBOutlet var indicator: UIActivityIndicatorView?
    @IBOutlet var moreImage: UIImageView?
}