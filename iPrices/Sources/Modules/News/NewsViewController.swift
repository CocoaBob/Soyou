//
//  ViewController.swift
//  iPrices
//
//  Created by CocoaBob on 15/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class NewsViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView()
        
        setupRefreshControls()
        
//        requestNewsList(nil)
        
        ////////
        MagicalRecord.saveWithBlockAndWait { (localContext: NSManagedObjectContext!) -> Void in
            for news in News.MR_findAllInContext(localContext) {
                news.MR_deleteEntityInContext(localContext)
            }
        }
        ServerManager.shared.requestNewsList(1, 4,
            { (responseObject: AnyObject?) -> () in self.handleSuccess(responseObject) },
            { (error: NSError?) -> () in self.handleError(error) }
        );
        ////////
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        return News.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "datePublication", ascending: false)
    }
    
}

// MARK: Data
extension NewsViewController {
    
    private func handleSuccess(responseObject: AnyObject?) {
        self.endRefreshing()
        guard let responseObject = responseObject as? Dictionary<String, AnyObject> else { return }
        let allNews = responseObject["data"] as? [NSDictionary]
        News.importDatas(allNews)
    }
    
    private func handleError(error: NSError?) {
        self.endRefreshing()
        print("\(error)")
    }
    
    func requestNewsList(relativeNewsID: NSNumber?) {
        /////// Cons.Svr.reqCnt
        ServerManager.shared.requestNewsList(1, relativeNewsID,
            { (responseObject: AnyObject?) -> () in self.handleSuccess(responseObject) },
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
        
        if news.isMore != nil && news.isMore!.integerValue != NewsIsMore.False.rawValue {
            let cell: NewsTableViewCellMore = tableView.dequeueReusableCellWithIdentifier("NewsTableViewCellMore", forIndexPath: indexPath) as! NewsTableViewCellMore
            if news.isMore!.integerValue == NewsIsMore.True.rawValue {
                cell.indicator?.hidden = true
                cell.moreImage?.hidden = false
            } else if news.isMore!.integerValue == NewsIsMore.Loading.rawValue {
                cell.indicator?.hidden = false
                cell.indicator?.startAnimating()
                cell.moreImage?.hidden = true
            }
            return cell
        } else {
            let cell: NewsTableViewCell = tableView.dequeueReusableCellWithIdentifier("NewsTableViewCell", forIndexPath: indexPath) as! NewsTableViewCell
            cell.textLabel?.text = news.title
            cell.detailTextLabel?.text = news.author
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let news: News = self.fetchedResultsController.objectAtIndexPath(indexPath) as! News
        MagicalRecord.saveWithBlockAndWait { (localContext: NSManagedObjectContext!) -> Void in
            let localNews = news.MR_inContext(localContext)
            if localNews.isMore != nil && localNews.isMore!.boolValue {
                localNews.isMore = NSNumber(integer: NewsIsMore.Loading.rawValue)
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
    
}

class NewsTableViewCellMore: UITableViewCell {
    @IBOutlet var indicator: UIActivityIndicatorView?
    @IBOutlet var moreImage: UIImageView?
}