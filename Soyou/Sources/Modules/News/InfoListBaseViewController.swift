//
//  InfoListBaseViewController.swift
//  Soyou
//
//  Created by CocoaBob on 01/06/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

class InfoListBaseViewController: SyncedFetchedResultsViewController {
    
    // Override AsyncedFetchedResultsViewController
    @IBOutlet var _collectionView: UICollectionView!
    
    override func collectionView() -> UICollectionView {
        return _collectionView
    }
    
    // Properties
    var transition: ZoomInteractiveTransition?
    
    var selectedMoreButtonCell: InfoCollectionViewCellMore?
    var selectedIndexPath: NSIndexPath?
    
    // Class methods
    class func instantiate() -> InfoListBaseViewController {
        return (UIStoryboard(name: "NewsViewController", bundle: nil).instantiateViewControllerWithIdentifier("InfoListBaseViewController") as? InfoListBaseViewController)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.collectionView(), 0, false, false, false, true)
        
        // Setups
        self.setupCollectionView()
        self.setupRefreshControls()
        
        // Data
        self.loadData(nil)
        self.reloadData(nil)
        
        // Transitions
        self.transition = ZoomInteractiveTransition(navigationController: self.navigationController)
        self.transition?.handleEdgePanBackGesture = false
        self.transition?.transitionDuration = 0.3
        let animationOpts: UIViewAnimationOptions = .CurveEaseOut
        let keyFrameOpts: UIViewKeyframeAnimationOptions = UIViewKeyframeAnimationOptions(rawValue: animationOpts.rawValue)
        self.transition?.transitionAnimationOption = [UIViewKeyframeAnimationOptions.CalculationModeCubic, keyFrameOpts]
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        updateColumnCount(Int(floor(size.width / 240)))
    }
    
    // Methods to be overridden
    func getNextInfo(currentIndex: Int?) -> (Int?, AnyObject?)? {
        return nil
    }
    
    func didShowNextInfo(info: AnyObject, index: Int) {
        
    }
    
}

// MARK: Data
extension InfoListBaseViewController {
    
    func resetMoreButtonCell() {
        if let cell = self.selectedMoreButtonCell {
            cell.indicator.hidden = true
            cell.moreImage.hidden = false
        }
    }
    
    func loadData(relativeID: NSNumber?) {
        
    }
}

// MARK: NewsDetailViewControllerDelegate
extension InfoListBaseViewController: NewsDetailViewControllerDelegate {
    
    func getNextNews(currentIndex: Int?) -> (Int?, BaseNews?)? {
        return self.getNextInfo(currentIndex) as? (Int?, BaseNews?)
    }
    
    func didShowNextNews(news: BaseNews, index: Int) {
        self.didShowNextInfo(news, index: index)
    }
}

// MARK: - CollectionView Delegate Methods
extension InfoListBaseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func cellForItemAtIndexPath(collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("InfoCollectionViewCellMore", forIndexPath: indexPath)
        return cell
    }
    
    func didSelectItemAtIndexPath(collectionView: UICollectionView, indexPath: NSIndexPath) {

    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.fetchedResultsController?.sections?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.cellForItemAtIndexPath(collectionView, indexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = indexPath
        self.didSelectItemAtIndexPath(collectionView, indexPath: indexPath)
    }
}

// MARK: - UIScrollViewDelegate
extension InfoListBaseViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.collectionView().reloadItemsAtIndexPaths(self.collectionView().indexPathsForVisibleItems())
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.collectionView().reloadItemsAtIndexPaths(self.collectionView().indexPathsForVisibleItems())
    }
}

// MARK: - CollectionView Waterfall Layout
extension InfoListBaseViewController: CHTCollectionViewDelegateWaterfallLayout {
    
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
        
        updateColumnCount(Int(floor(self.view.frame.width / 568)))
        
        // Collection view attributes
        self.collectionView().autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        self.collectionView().alwaysBounceVertical = true
    }
    
    func updateColumnCount(count: Int) {
        // Update column count
        (self.collectionView().collectionViewLayout as? CHTCollectionViewWaterfallLayout)?.columnCount = max(count, 1)
        
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
        var size = CGSize(width: 3, height: 2) // Default size for news
        
        if let news = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? News {
            if news.appIsMore == nil || !news.appIsMore!.boolValue {
                if let imageURLString = news.image, imageURL = NSURL(string: imageURLString) {
                    let cacheKey = SDWebImageManager.sharedManager().cacheKeyForURL(imageURL)
                    let image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(cacheKey)
                    if image != nil {
                        size = CGSize(width: image.size.width, height: image.size.height)
                    }
                }
            } else {
                size = CGSize(width: 8, height: 1)
            }
        }
        
        return size
    }
}

// MARK: ZoomInteractiveTransition
extension InfoListBaseViewController: ZoomTransitionProtocol {
    
    private func imageViewForZoomTransition() -> UIImageView? {
        if let indexPath = self.selectedIndexPath,
            cell = self.collectionView().cellForItemAtIndexPath(indexPath) as? InfoCollectionViewCell {
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
    
    func shouldAllowZoomTransitionForOperation(operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController!, toViewController toVC: UIViewController!) -> Bool {
        // Only available for opening/closing a news from/to news view controller
        if ((operation == .Push && fromVC === self && toVC is NewsDetailViewController) ||
            (operation == .Pop && fromVC is NewsDetailViewController && toVC === self)) {
            return true
        }
        return false
    }
}

// MARK: - Refreshing
extension InfoListBaseViewController {
    
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
        self.collectionView().mj_header = header
        
        let footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            let lastNews = self.fetchedResultsController?.fetchedObjects?.last as? News
            self.loadData(lastNews?.id)
            self.beginRefreshing()
        })
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
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.collectionView().mj_header.endRefreshing()
            self.collectionView().mj_footer.endRefreshing()
        })
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

// MARK: - Custom cells

class InfoCollectionViewCell: UICollectionViewCell {
    @IBOutlet var fgImageView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
        
        self.lblTitle.clipsToBounds = true
        self.lblTitle.layer.shadowRadius = 1
        self.lblTitle.layer.shadowColor = UIColor.blackColor().CGColor
        self.lblTitle.layer.shadowOpacity = 1
        self.lblTitle.layer.shadowOffset = CGSize.zero
    }
    
    override func prepareForReuse() {
        lblTitle.text = nil
    }
}

class InfoCollectionViewCellMore: UICollectionViewCell {
    @IBOutlet var indicator: UIActivityIndicatorView!
    @IBOutlet var moreImage: UIImageView!
}
