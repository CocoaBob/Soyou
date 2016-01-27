//
//  ViewController.swift
//  iPrices
//
//  Created by CocoaBob on 15/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class NewsViewController: BaseViewController {
    
    // Override BaseViewController
    @IBOutlet var _collectionView: UICollectionView!
    
    override func collectionView() -> UICollectionView {
        return _collectionView
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        return News.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "datePublication:false,id:false,appIsMore:true", ascending: false)
    }
    
    // Properties
    var transition: ZoomInteractiveTransition?
    
    var selectedMoreButtonCell: NewsCollectionViewCellMore?
    var selectedIndexPath: NSIndexPath?
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UIViewController
        self.title = NSLocalizedString("news_vc_title")

        // UITabBarItem
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("news_vc_tab_title"), image: UIImage(named: "img_tab_house"), selectedImage: UIImage(named: "img_tab_house_selected"))
        
        // Bars
        self.hidesBottomBarWhenPushed = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.collectionView(), 0, false, false)
        
        // Setups
        setupCollectionView()
        setupRefreshControls()
        
        // Data
        loadData(nil)
        
        // Transitions
        self.transition = ZoomInteractiveTransition(navigationController: self.navigationController)
        self.transition?.handleEdgePanBackGesture = false
        self.transition?.transitionDuration = 0.3
        let animationOpts: UIViewAnimationOptions = .CurveEaseOut
        let keyFrameOpts: UIViewKeyframeAnimationOptions = UIViewKeyframeAnimationOptions(rawValue: animationOpts.rawValue)
        self.transition?.transitionAnimationOption = [UIViewKeyframeAnimationOptions.CalculationModeCubic, keyFrameOpts]
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        self.hideToolbar(false);
        
        // Load favorites
        DataManager.shared.requestNewsFavorites(nil)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        updateColumnCount(Int(floor(size.width / 240)))
    }
    
}

// MARK: Data
extension NewsViewController {
    
    private func resetMoreButtonCell() {
        if let cell = self.selectedMoreButtonCell {
            cell.indicator.hidden = true
            cell.moreImage.hidden = false
        }
    }
    
    private func loadData(relativeID: NSNumber?) {
        DataManager.shared.requestNewsList(relativeID) { () -> () in
            self.endRefreshing()
            self.resetMoreButtonCell()
        }
    }
    
}

// MARK: - CollectionView Delegate Methods
extension NewsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if let sections = self.fetchedResultsController.sections {
            return sections.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections![section].numberOfObjects
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let news = self.fetchedResultsController.objectAtIndexPath(indexPath) as! News
        
        var returnValue: UICollectionViewCell?
        if news.appIsMore != nil && news.appIsMore!.boolValue {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NewsCollectionViewCellMore", forIndexPath: indexPath) as! NewsCollectionViewCellMore
            
            cell.indicator.hidden = true
            cell.moreImage.hidden = false
            returnValue = cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NewsCollectionViewCell", forIndexPath: indexPath) as! NewsCollectionViewCell
            
            cell.lblTitle.text = news.title
            if let imageURLString = news.image, let imageURL = NSURL(string: imageURLString) {
                cell.fgImageView.sd_setImageWithURL(imageURL,
                    placeholderImage: UIImage.imageWithRandomColor(CGSizeMake(3, 2)),
                    options: [.ContinueInBackground, .AllowInvalidSSLCertificates, .HighPriority],
                    completed: { (image: UIImage!, error: NSError!, type: SDImageCacheType, url: NSURL!) -> Void in
                        UIView.animateWithDuration(0.25, animations: { () -> Void in
                            collectionView.collectionViewLayout.invalidateLayout()
                            }
                        )
                })
            }
            returnValue = cell
        }
        
        return returnValue!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = indexPath
        
        let news = self.fetchedResultsController.objectAtIndexPath(indexPath) as! News
        
        MagicalRecord.saveWithBlockAndWait { (localContext: NSManagedObjectContext!) -> Void in
            guard let localNews = news.MR_inContext(localContext) else { return }
            let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            if localNews.appIsMore != nil && localNews.appIsMore!.boolValue {
                guard let cell = cell as? NewsCollectionViewCellMore else { return }
                
                self.selectedMoreButtonCell = cell
                
                cell.indicator.startAnimating()
                cell.indicator.hidden = false
                cell.moreImage.hidden = true
                self.loadData(localNews.id)
            } else {
                guard let cell = cell as? NewsCollectionViewCell else { return }
                
                // Prepare cover image
                var image: UIImage?
                if let imageURLString = localNews.image, let imageURL = NSURL(string: imageURLString) {
                    let cacheKey = SDWebImageManager.sharedManager().cacheKeyForURL(imageURL)
                    image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(cacheKey)
                }
                
                if image == nil {
                    image = cell.fgImageView.image
                }
                
                // Prepare view controller
                let newsDetailViewController = NewsDetailViewController.instantiate()
                newsDetailViewController.news = localNews
                newsDetailViewController.headerImage = image
                
                // Push view controller
                self.navigationController?.pushViewController(newsDetailViewController, animated: true)
            }
        }
    }
}

//MARK: - CollectionView Waterfall Layout
extension NewsViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func setupCollectionView() {
        self.collectionView().indicatorStyle = .White

        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.itemRenderDirection = .LeftToRight
        layout.minimumColumnSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        // Add the waterfall layout to your collection view
        self.collectionView().collectionViewLayout = layout
        
        updateColumnCount(Int(floor(self.view.frame.size.width / 568)))
        
        // Collection view attributes
        self.collectionView().autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        self.collectionView().alwaysBounceVertical = true
    }
    
    func updateColumnCount(count: Int) {
        // Update column count
        (self.collectionView().collectionViewLayout as! CHTCollectionViewWaterfallLayout).columnCount = max(count, 1)
        
        // Update margins
        if let layout = self.collectionView().collectionViewLayout as? CHTCollectionViewWaterfallLayout {
//            if count > 1 {
//                layout.sectionInset = UIEdgeInsetsMake(0, 4, 0, 4)
//            } else {
                layout.sectionInset = UIEdgeInsetsZero
//            }
        }
    }
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        let news = self.fetchedResultsController.objectAtIndexPath(indexPath) as! News
        var size = CGSizeMake(3, 2) // Default size for news
        MagicalRecord.saveWithBlockAndWait { (localContext: NSManagedObjectContext!) -> Void in
            guard let localNews = news.MR_inContext(localContext) else { return }
            if localNews.appIsMore == nil || !localNews.appIsMore!.boolValue {
                if let imageURLString = localNews.image,
                    let imageURL = NSURL(string: imageURLString),
                    let cacheKey = SDWebImageManager.sharedManager().cacheKeyForURL(imageURL),
                    let image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(cacheKey) {
                        size = image.size
                }
            } else {
                size = CGSizeMake(8, 1)
            }
        }
        return size
    }
}

// MARK: ZoomInteractiveTransition
extension NewsViewController: ZoomTransitionProtocol {
    
    private func imageViewForZoomTransition() -> UIImageView? {
        if let indexPath = self.selectedIndexPath,
            let cell = self.collectionView().cellForItemAtIndexPath(indexPath) as? NewsCollectionViewCell {
            return cell.fgImageView
        }
        return nil
    }
    
    func viewForZoomTransition(isSource: Bool) -> UIView? {
        return self.imageViewForZoomTransition()
    }
    
    func initialZoomViewSnapshotFromProposedSnapshot(snapshot: UIImageView!) -> UIImageView? {
        if let imageView = self.imageViewForZoomTransition() {
            let returnImageView = UIImageView(image: imageView.image)
            returnImageView.contentMode = imageView.contentMode
            return returnImageView
        }
        return nil
    }
}

// MARK: - Refreshing
extension NewsViewController {
    
    func setupRefreshControls() {
        let header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadData(nil)
            self.beginRefreshing()
        });
        header.setTitle(NSLocalizedString("pull_to_refresh_header_idle"), forState: .Idle)
        header.setTitle(NSLocalizedString("pull_to_refresh_header_pulling"), forState: .Pulling)
        header.setTitle(NSLocalizedString("pull_to_refresh_header_refreshing"), forState: .Refreshing)
        header.setTitle(NSLocalizedString("pull_to_refresh_no_more_data"), forState: .NoMoreData)
        header.lastUpdatedTimeText = { (date: NSDate!) -> (String!) in
            if date == nil {
                return FmtString(NSLocalizedString("pull_to_refresh_header_last_updated"), NSLocalizedString("pull_to_refresh_header_never"))
            }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM/dd HH:mm"
            let dateString = dateFormatter.stringFromDate(date)
            return FmtString(NSLocalizedString("pull_to_refresh_header_last_updated"), dateString)
        }
        header.lastUpdatedTimeKey = header.lastUpdatedTimeKey
        self.collectionView().mj_header = header
        
        let footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            let lastNews = self.fetchedResultsController.fetchedObjects?.last as? News
            self.loadData(lastNews?.id)
            self.beginRefreshing()
        });
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_idle"), forState: .Idle)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_pulling"), forState: .Pulling)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_refreshing"), forState: .Refreshing)
        footer.setTitle(NSLocalizedString("pull_to_refresh_no_more_data"), forState: .NoMoreData)
        footer.automaticallyHidden = false
        self.collectionView().mj_footer = footer
    }
    
    func beginRefreshing() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func endRefreshing() {
        self.collectionView().mj_header.endRefreshing()
        self.collectionView().mj_footer.endRefreshing()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

// MARK: - Custom cells

class NewsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var fgImageView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle.clipsToBounds = true
        self.lblTitle.layer.shadowRadius = 1
        self.lblTitle.layer.shadowColor = UIColor.blackColor().CGColor
        self.lblTitle.layer.shadowOpacity = 1
        self.lblTitle.layer.shadowOffset = CGSizeZero
    }
    
    override func prepareForReuse() {
        lblTitle.text = nil
    }
}

class NewsCollectionViewCellMore: UICollectionViewCell {
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var moreImage: UIImageView!
}
