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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateNews()
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        return News.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "datePublication", ascending: false)
    }
    
}

// MARK: Query data
extension NewsViewController {
    func updateNews() {
        ServerManager.shared.getNewsList(5, 0, true,
            { (responseObject: AnyObject?) -> () in
                guard let responseObject = responseObject as? Dictionary<String, AnyObject> else {
                    return
                }
                
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

class NewsTableViewCell: UITableViewCell {
    
}