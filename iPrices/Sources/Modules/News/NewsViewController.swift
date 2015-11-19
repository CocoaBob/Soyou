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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadLatestNews()
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        return News.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "datePublication", ascending: false)
    }
    
}

// MARK: Query data
extension NewsViewController {
    
    func loadLatestNews() {
        ServerManager.shared.getLatestNews(5,
            { (responseObject: AnyObject?) -> () in
                self.endRefreshing()
                
                guard let responseObject = responseObject as? Dictionary<String, AnyObject> else { return }
                
                let allNews = responseObject["data"]
                if let allNews = allNews as? [NSDictionary] {
                    MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                        for newsData in allNews {
                            News.importData(newsData, localContext)
                        }
                    })
                }
            },
            { (error: NSError?) -> () in
                self.endRefreshing()
                
                print("\(error)")
            }
        );
    }
    
    func loadOlderNews(news: News) {
        guard let newsID = news.id else {
            return
        }
        ServerManager.shared.getOlderNews(Cons.Svr.reqCnt, newsID,
            { (responseObject: AnyObject?) -> () in
                self.endRefreshing()
                
                guard let responseObject = responseObject as? Dictionary<String, AnyObject> else { return }
                
                let allNews = responseObject["data"]
                if let allNews = allNews as? [NSDictionary] {
                    MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                        for newsData in allNews {
                            News.importData(newsData, localContext)
                        }
                    })
                }
            },
            { (error: NSError?) -> () in
                self.endRefreshing()
                
                print("\(error)")
            }
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
        let cell: NewsTableViewCell = tableView.dequeueReusableCellWithIdentifier("NewsTableViewCell", forIndexPath: indexPath) as! NewsTableViewCell
        let news: News = self.fetchedResultsController.objectAtIndexPath(indexPath) as! News
        cell.textLabel?.text = news.title
        cell.detailTextLabel?.text = news.author
        return cell
    }
    
}

// MARK: Refreshing
extension NewsViewController {
    
    func setupRefreshControls() {
        let header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadLatestNews()
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
            if let lastNews = self.fetchedResultsController.fetchedObjects?.last as? News {
                self.loadOlderNews(lastNews)
            } else {
                self.loadLatestNews()
            }
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