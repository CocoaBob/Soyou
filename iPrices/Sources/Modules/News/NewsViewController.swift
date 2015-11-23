//
//  ViewController.swift
//  iPrices
//
//  Created by CocoaBob on 15/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class NewsViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout {
    
    @IBOutlet var _collectionView: UICollectionView?
    
    var currentMoreButtonCell: NewsCollectionViewCellMore?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupRefreshControls()
        
        requestNewsList(nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        return News.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "datePublication:false,id:false,isMore:true", ascending: false)
    }
    
    override func collectionView() -> UICollectionView? {
        return _collectionView
    }
}

// MARK: Data
extension NewsViewController {
    
    private func resetMoreButtonCell() {
        if let cell = self.currentMoreButtonCell {
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

// MARK: - CollectionView Delegate Methods
extension NewsViewController {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections![section].numberOfObjects
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let news: News = self.fetchedResultsController.objectAtIndexPath(indexPath) as! News
        
        if news.isMore != nil && news.isMore!.boolValue {
            let cell: NewsCollectionViewCellMore = collectionView.dequeueReusableCellWithReuseIdentifier("NewsCollectionViewCellMore", forIndexPath: indexPath) as! NewsCollectionViewCellMore
            cell.indicator?.hidden = true
            cell.moreImage?.hidden = false
            return cell
        } else {
            let cell: NewsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("NewsCollectionViewCell", forIndexPath: indexPath) as! NewsCollectionViewCell
            cell.tltTextView?.text = news.title
            if let imageURLString = news.image, let imageURL = NSURL(string: imageURLString) {
                cell.bgImageView?.sd_setImageWithURL(imageURL, completed: { (image: UIImage!, error: NSError!, type: SDImageCacheType, url: NSURL!) -> Void in
                    cell.bgImageView?.hidden = false
                })
            }
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let news: News = self.fetchedResultsController.objectAtIndexPath(indexPath) as! News
        MagicalRecord.saveWithBlockAndWait { (localContext: NSManagedObjectContext!) -> Void in
            let localNews = news.MR_inContext(localContext)
            if localNews.isMore != nil && localNews.isMore!.boolValue {
                if let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as? NewsCollectionViewCellMore {
                    cell.indicator?.startAnimating()
                    cell.indicator?.hidden = false
                    cell.moreImage?.hidden = true
                    self.currentMoreButtonCell = cell
                }
                self.requestNewsList(localNews.id)
            }
        }
    }
}

//MARK: - CollectionView Waterfall Layout
extension NewsViewController {
    
    func setupCollectionView() {
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.minimumColumnSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        
        // Collection view attributes
        self.collectionView()!.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        self.collectionView()!.alwaysBounceVertical = true
        
        // Add the waterfall layout to your collection view
        self.collectionView()!.collectionViewLayout = layout
        
        updateColumnCount(Int(floor(self.view.frame.size.width / 240)))
    }
    
    func updateColumnCount(count: Int) {
        (self.collectionView()!.collectionViewLayout as! CHTCollectionViewWaterfallLayout).columnCount = count
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        updateColumnCount(Int(floor(size.width / 240)))
    }
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        
        let news: News = self.fetchedResultsController.objectAtIndexPath(indexPath) as! News
        let cacheKey = SDWebImageManager.sharedManager().cacheKeyForURL(NSURL(string: news.image!))
        if let image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(cacheKey) {
            return image.size
        } else {
            return CGSizeZero
        }
    }
}

// MARK: - Refreshing
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
        self.collectionView()!.mj_header = header
        
        let footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            let lastNews = self.fetchedResultsController.fetchedObjects?.last as? News
            self.requestNewsList(lastNews?.id)
            self.beginRefreshing()
        });
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_idle", comment: ""), forState: .Idle)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_pulling", comment: ""), forState: .Pulling)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_refreshing", comment: ""), forState: .Refreshing)
        footer.setTitle(NSLocalizedString("pull_to_refresh_no_more_data", comment: ""), forState: .NoMoreData)
        self.collectionView()!.mj_footer = footer
    }
    
    func beginRefreshing() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func endRefreshing() {
        self.collectionView()!.mj_header.endRefreshing()
        self.collectionView()!.mj_footer.endRefreshing()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

class NewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var tltTextView: UITextView?
    @IBOutlet var bgImageView: UIImageView?
    
    override func prepareForReuse() {
        tltTextView?.text = ""
        bgImageView?.hidden = true
    }
}

class NewsCollectionViewCellMore: UICollectionViewCell {
    @IBOutlet var indicator: UIActivityIndicatorView?
    @IBOutlet var moreImage: UIImageView?
}