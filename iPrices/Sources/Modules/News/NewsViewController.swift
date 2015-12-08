//
//  ViewController.swift
//  iPrices
//
//  Created by CocoaBob on 15/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class NewsViewController: BaseViewController {
    
    @IBOutlet var _collectionView: UICollectionView?
    
    var selectedMoreButtonCell: NewsCollectionViewCellMore?
    var selectedNewsViewCell: NewsCollectionViewCell?
    var selectedIndexPath: NSIndexPath?
    var isEdgeSwiping: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UIViewController
        updateTitleViewImage(nil)
        
        self.edgesForExtendedLayout = UIRectEdge.All
        self.extendedLayoutIncludesOpaqueBars = true
        self.automaticallyAdjustsScrollViewInsets = true

        // UITabBarItem
        self.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "img_tab_home"), selectedImage: UIImage(named: "img_tab_home_selected"))
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UINavigationController delegate
        self.navigationController?.delegate = self;
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;

        // Setups
        setupCollectionView()
        setupRefreshControls()
        
        // Data
        requestNewsList(nil)
        
        ////////
//        MagicalRecord.saveWithBlockAndWait { (localContext: NSManagedObjectContext!) -> Void in
//            for news in News.MR_findAllInContext(localContext) {
//                news.MR_deleteEntityInContext(localContext)
//            }
//        }
//        ServerManager.shared.requestNewsList(1, 4,
//            { (responseObject: AnyObject?) -> () in self.handleSuccess(responseObject, 4) },
//            { (error: NSError?) -> () in self.handleError(error) }
//        );
        ////////
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let tabBar = self.tabBarController?.tabBar {
            var frame = tabBar.frame
            frame.origin.y = CGRectGetMaxY(self.view.frame) - CGRectGetHeight(frame)
            if frame != tabBar.frame {
                UIView.animateWithDuration(0.25) { () -> Void in
                    tabBar.frame = frame
                }
            }
        }
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        return News.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "datePublication:false,id:false,isMore:true", ascending: false)
    }
    
    override func collectionView() -> UICollectionView {
        return _collectionView!
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        updateColumnCount(Int(floor(size.width / 240)))
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context) -> Void in
            self.updateTitleViewImage(newCollection.verticalSizeClass)
            }, completion: nil)
    }
    
}

// MARK: Routines
extension NewsViewController {
    
    func updateTitleViewImage(newSizeClass: UIUserInterfaceSizeClass?) {
        if let newSizeClass = newSizeClass {
            self.navigationItem.titleView = UIImageView(image: UIImage(named: newSizeClass == .Regular ? "img_logo_nav_bar" : "img_logo_nav_bar_compact"))
        } else {
            self.navigationItem.titleView = UIImageView(image: UIImage(named: self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClass.Regular ? "img_logo_nav_bar" : "img_logo_nav_bar_compact"))
        }
    }
    
}

// MARK: Data
extension NewsViewController {
    
    private func resetMoreButtonCell() {
        if let cell = self.selectedMoreButtonCell {
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
extension NewsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections![section].numberOfObjects
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let news: News = self.fetchedResultsController.objectAtIndexPath(indexPath) as! News
        
        var returnValue: UICollectionViewCell?
        if news.isMore != nil && news.isMore!.boolValue {
            let cell: NewsCollectionViewCellMore = collectionView.dequeueReusableCellWithReuseIdentifier("NewsCollectionViewCellMore", forIndexPath: indexPath) as! NewsCollectionViewCellMore
            
            cell.indicator?.hidden = true
            cell.moreImage?.hidden = false
            returnValue = cell
        } else {
            let cell: NewsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("NewsCollectionViewCell", forIndexPath: indexPath) as! NewsCollectionViewCell
            
            cell.tltTextView?.clipsToBounds = true
            cell.tltTextView?.layer.shadowRadius = 1
            cell.tltTextView?.layer.shadowColor = UIColor.blackColor().CGColor
            cell.tltTextView?.layer.shadowOpacity = 1
            cell.tltTextView?.layer.shadowOffset = CGSizeZero
            cell.tltTextView?.text = news.title
            if let imageURLString = news.image, let imageURL = NSURL(string: imageURLString) {
                cell.fgImageView?.sd_setImageWithURL(imageURL, placeholderImage: UIImage(named: "iTunesArtwork"), completed: { (image: UIImage!, error: NSError!, type: SDImageCacheType, url: NSURL!) -> Void in
                    collectionView.reloadItemsAtIndexPaths([indexPath])
                })
            }
            returnValue = cell
        }
        
        if indexPath.row < (self.fetchedResultsController.sections![indexPath.section].numberOfObjects - 1) {
            (returnValue as? NewsCollectionViewCellBase)?.bottomImageView?.image = UIImage(named: "img_news_cell_bottom")?.resizableImageWithCapInsets(UIEdgeInsetsMake(2, 1, 0, 1))
        } else {
            (returnValue as? NewsCollectionViewCellBase)?.bottomImageView?.image = nil
        }
        
        return returnValue!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let news: News = self.fetchedResultsController.objectAtIndexPath(indexPath) as! News
        MagicalRecord.saveWithBlockAndWait { (localContext: NSManagedObjectContext!) -> Void in
            let localNews = news.MR_inContext(localContext)
            let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            if localNews.isMore != nil && localNews.isMore!.boolValue {
                if let cell = cell as? NewsCollectionViewCellMore {
                    cell.indicator?.startAnimating()
                    cell.indicator?.hidden = false
                    cell.moreImage?.hidden = true
                    self.selectedMoreButtonCell = cell
                    self.selectedIndexPath = indexPath
                    self.requestNewsList(localNews.id)
                }
            } else {
                if let cell = cell as? NewsCollectionViewCell {
                    self.selectedNewsViewCell = cell
                    self.selectedIndexPath = indexPath
                    
                    let newsDetailViewController = NewsDetailViewController(news: localNews, image: cell.fgImageView?.image)
                    
                    self.navigationController?.pushViewController(newsDetailViewController, animated: true)
                }
            }
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.isEdgeSwiping = false
    }
}

//MARK: - CollectionView Waterfall Layout
extension NewsViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func setupCollectionView() {
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.itemRenderDirection = .LeftToRight
        layout.minimumColumnSpacing = 0
        layout.minimumInteritemSpacing = 0

        // Collection view attributes
        self.collectionView().autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        self.collectionView().alwaysBounceVertical = true
        
        // Add the waterfall layout to your collection view
        self.collectionView().collectionViewLayout = layout
        
        updateColumnCount(Int(floor(self.view.frame.size.width / 568)))
    }
    
    func updateColumnCount(count: Int) {
        // Update column count
        (self.collectionView().collectionViewLayout as! CHTCollectionViewWaterfallLayout).columnCount = max(count, 1)
        
        // Update margins
        if let layout = self.collectionView().collectionViewLayout as? CHTCollectionViewWaterfallLayout {
            if count > 1 {
                layout.sectionInset = UIEdgeInsetsMake(0, 4, 0, 4)
            } else {
                layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
            }
        }
    }
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        let news: News = self.fetchedResultsController.objectAtIndexPath(indexPath) as! News
        
        if news.isMore == nil || !news.isMore!.boolValue {
            let cacheKey = SDWebImageManager.sharedManager().cacheKeyForURL(NSURL(string: news.image!))
            if let image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(cacheKey) {
                return image.size
            } else {
                return CGSizeMake(256, 256)
            }
        } else {
            return CGSizeMake(256, 32)
        }
    }
}

// MARK: - UINavigationControllerDelegate
extension NewsViewController: UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if self.isEdgeSwiping {
            self.isEdgeSwiping = false
            return nil
        }
        
        if fromVC is RMPZoomTransitionAnimating && toVC is RMPZoomTransitionAnimating {
            let src = fromVC as! protocol<RMPZoomTransitionAnimating, RMPZoomTransitionDelegate>
            let dest = toVC as! protocol<RMPZoomTransitionAnimating, RMPZoomTransitionDelegate>
            
            // If one of the frames is invisible
            if (operation == .Pop &&
                src.transitionDestinationImageViewFrame().size.height == 0) {
                    return nil
            }
            
            let animator = RMPZoomTransitionAnimator()
            animator.goingForward = (operation == .Push)
            animator.sourceTransition = src
            animator.destinationTransition = dest
            return animator
        }
        
        return nil
    }
}

// MARK: UIGestureRecognizerDelegate (interactivePopGestureRecognizer.delegate)
extension NewsViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        self.isEdgeSwiping = true
        return true
    }
}

// MARK: - RMPZoomTransitionAnimating/RMPZoomTransitionDelegate
extension NewsViewController: RMPZoomTransitionAnimating, RMPZoomTransitionDelegate {
    
    func imageViewFrame() -> CGRect {
        if let indexPath = self.selectedIndexPath,
            let cell = self.collectionView().cellForItemAtIndexPath(indexPath) as? NewsCollectionViewCell,
            let imageView = cell.fgImageView {
                let frame = imageView.convertRect(imageView.frame, toView: self.view.window)
                return frame
        }
        return CGRectZero
    }
    
    func transitionSourceImageView() -> UIImageView! {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.userInteractionEnabled = false
        imageView.contentMode = .ScaleAspectFill
        imageView.frame = imageViewFrame()
        imageView.image = self.selectedNewsViewCell?.fgImageView!.image
        return imageView
    }
    
    func transitionSourceBackgroundColor() -> UIColor! {
        return self.view.backgroundColor
    }
    
    func transitionDestinationImageViewFrame() -> CGRect {
        return imageViewFrame()
    }
    
    func zoomTransitionAnimator(animator: RMPZoomTransitionAnimator!, didCompleteTransition didComplete: Bool, animatingSourceImageView imageView: UIImageView!) {
        
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
        self.collectionView().mj_header = header
        
        let footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            let lastNews = self.fetchedResultsController.fetchedObjects?.last as? News
            self.requestNewsList(lastNews?.id)
            self.beginRefreshing()
        });
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_idle", comment: ""), forState: .Idle)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_pulling", comment: ""), forState: .Pulling)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_refreshing", comment: ""), forState: .Refreshing)
        footer.setTitle(NSLocalizedString("pull_to_refresh_no_more_data", comment: ""), forState: .NoMoreData)
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

class NewsCollectionViewCellBase: UICollectionViewCell {
    @IBOutlet var bottomImageView: UIImageView?
    
}

class NewsCollectionViewCell: NewsCollectionViewCellBase {
    @IBOutlet var fgImageView: UIImageView?
    @IBOutlet var tltTextView: UITextView?
    
    override func prepareForReuse() {
        tltTextView?.text = nil
        tltTextView?.attributedText = nil
    }
}

class NewsCollectionViewCellMore: NewsCollectionViewCellBase {
    @IBOutlet var indicator: UIActivityIndicatorView?
    @IBOutlet var moreImage: UIImageView?
}
