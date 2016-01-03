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
    var isEdgeSwiping: Bool = false // Use edge swiping instead of custom animator if interactivePopGestureRecognizer is trigered
    var lastLastCell: NewsCollectionViewCellBase?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UIViewController
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "img_logo_nav_bar"))

        // UITabBarItem
        self.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "img_tab_house"), selectedImage: UIImage(named: "img_tab_house_selected"))
//        self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        self.tabBarItem.title = NSLocalizedString("news_vc_tab_title")
        
        // Bars
        self.hidesBottomBarWhenPushed = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.collectionView(), false, false)
        
        // Setups
        setupCollectionView()
        setupRefreshControls()
        
        // UINavigationController delegate
        self.navigationController?.delegate = self;
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        
        // Data
        loadData(nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.hideToolbar(false);
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        return News.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "datePublication:false,id:false,appIsMore:true", ascending: false)
    }
    
    override func collectionView() -> UICollectionView {
        return _collectionView!
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        updateColumnCount(Int(floor(size.width / 240)))
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
    
    private func loadData(relativeID: NSNumber?) {
        DataManager.shared.loadNewsList(relativeID) { () -> () in
            self.endRefreshing()
            self.resetMoreButtonCell()
        }
    }
    
}

// MARK: NSFetchedResultsControllerDelegate
extension NewsViewController {
    
    override func controllerDidChangeContent(controller: NSFetchedResultsController) {
        // Remember the index path of the last last cell
        var indexPath: NSIndexPath?
        if let lastLastCell = self.lastLastCell {
            indexPath = self.collectionView().indexPathForCell(lastLastCell)
        }
        
        // Insert/Delete/Update/Move content
        super.controllerDidChangeContent(controller)
        
        // Reload last last cell, to update its bottom separator
        if indexPath != nil {
            self.collectionView().reloadItemsAtIndexPaths([indexPath!])
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
            let cell: NewsCollectionViewCellMore = collectionView.dequeueReusableCellWithReuseIdentifier("NewsCollectionViewCellMore", forIndexPath: indexPath) as! NewsCollectionViewCellMore
            
            cell.indicator?.hidden = true
            cell.moreImage?.hidden = false
            returnValue = cell
        } else {
            let cell: NewsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("NewsCollectionViewCell", forIndexPath: indexPath) as! NewsCollectionViewCell
            
            cell.lblTitle?.text = news.title
            if let imageURLString = news.image, let imageURL = NSURL(string: imageURLString) {
                cell.fgImageView?.backgroundColor = UIColor(rgba: "#EEE")
                cell.fgImageView?.sd_setImageWithURL(imageURL,
                    placeholderImage: UIImage.imageWithRandomColor(),
                    options: [.ProgressiveDownload, .ContinueInBackground, .AllowInvalidSSLCertificates, .HighPriority],
                    completed: { (image: UIImage!, error: NSError!, type: SDImageCacheType, url: NSURL!) -> Void in
                        UIView.animateWithDuration(0.25, animations: { () -> Void in
                            collectionView.collectionViewLayout.invalidateLayout()
                        })
                })
            }
            returnValue = cell
        }
        
        if indexPath.row < (self.fetchedResultsController.sections![indexPath.section].numberOfObjects - 1) {
            (returnValue as? NewsCollectionViewCellBase)?.bottomImageViewHeight?.constant = 4
            (returnValue as? NewsCollectionViewCellBase)?.bottomImageView?.image = UIImage(named: "img_news_cell_bottom")?.resizableImageWithCapInsets(UIEdgeInsetsMake(2, 1, 0, 1))
        } else {
            (returnValue as? NewsCollectionViewCellBase)?.bottomImageViewHeight?.constant = 0
            (returnValue as? NewsCollectionViewCellBase)?.bottomImageView?.image = nil
            self.lastLastCell = returnValue as? NewsCollectionViewCellBase
        }
        
        return returnValue!
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let news = self.fetchedResultsController.objectAtIndexPath(indexPath) as! News
        MagicalRecord.saveWithBlockAndWait { (localContext: NSManagedObjectContext!) -> Void in
            let localNews = news.MR_inContext(localContext)
            let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            if localNews.appIsMore != nil && localNews.appIsMore!.boolValue {
                if let cell = cell as? NewsCollectionViewCellMore {
                    cell.indicator?.startAnimating()
                    cell.indicator?.hidden = false
                    cell.moreImage?.hidden = true
                    self.selectedMoreButtonCell = cell
                    self.selectedIndexPath = indexPath
                    self.loadData(localNews.id)
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
            if count > 1 {
                layout.sectionInset = UIEdgeInsetsMake(0, 4, 0, 4)
            } else {
                layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
            }
        }
    }
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        let news = self.fetchedResultsController.objectAtIndexPath(indexPath) as! News
        
        if news.appIsMore == nil || !news.appIsMore!.boolValue {
            let cacheKey = SDWebImageManager.sharedManager().cacheKeyForURL(NSURL(string: news.image!))
            if let image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(cacheKey) {
                return image.size
            } else {
                return CGSizeMake(256, 192)
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
class NewsCollectionViewCellBase: UICollectionViewCell {
    @IBOutlet var bottomImageView: UIImageView?
    @IBOutlet var bottomImageViewHeight: NSLayoutConstraint?
}

class NewsCollectionViewCell: NewsCollectionViewCellBase {
    @IBOutlet var fgImageView: UIImageView?
    @IBOutlet var lblTitle: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle?.clipsToBounds = true
        self.lblTitle?.layer.shadowRadius = 1
        self.lblTitle?.layer.shadowColor = UIColor.blackColor().CGColor
        self.lblTitle?.layer.shadowOpacity = 1
        self.lblTitle?.layer.shadowOffset = CGSizeZero
    }
    
    override func prepareForReuse() {
        lblTitle?.text = nil
        lblTitle?.attributedText = nil
    }
}

class NewsCollectionViewCellMore: NewsCollectionViewCellBase {
    @IBOutlet var indicator: UIActivityIndicatorView?
    @IBOutlet var moreImage: UIImageView?
}
