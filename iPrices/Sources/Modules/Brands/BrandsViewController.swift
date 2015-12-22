//
//  BrandsViewController.swift
//  iPrices
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class BrandsViewController: BaseViewController {
    
    @IBOutlet var _collectionView: UICollectionView?
    var _requestsCount = 0
    
    var isEdgeSwiping: Bool = false // Use edge swiping instead of custom animator if interactivePopGestureRecognizer is trigered
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UIViewController
        self.title = NSLocalizedString("brands_vc_title")
        
        // UITabBarItem
        self.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "img_tab_tag"), selectedImage: UIImage(named: "img_tab_tag_selected"))
//        self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        self.tabBarItem.title = NSLocalizedString("brands_vc_tab_title")
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
        if self.fetchedResultsController.fetchedObjects?.count == 0 {
            loadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.hideToolbar(false);
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        prefetchImages()
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        return Brand.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "label", ascending: true)
    }
    
    override func collectionView() -> UICollectionView {
        return _collectionView!
    }
}

// MARK: Routines
extension BrandsViewController {
    
    func prefetchImages() {
        let imageURLs = self.fetchedResultsController.sections![0].objects?.flatMap({ (brand) -> NSURL? in
            if let imageURLString = (brand as! Brand).imageUrl, let imageURL = NSURL(string: imageURLString) {
                return imageURL
            }
            return nil
        })
        SDWebImagePrefetcher.sharedImagePrefetcher().prefetchURLs(imageURLs)
    }
}

// MARK: Data
extension BrandsViewController {
    
    private func handleAllBrandsSuccess(responseObject: AnyObject?) {
        self.endRefreshing()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            guard let responseObject = responseObject as? Dictionary<String, AnyObject> else { return }
            let allBrands = responseObject["data"] as? [NSDictionary]
            Brand.importDatas(allBrands, true)
        }
    }
    
    private func handleAllProductsSuccess(responseObject: AnyObject?) {
        self.endRefreshing()
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            guard let responseObject = responseObject as? Dictionary<String, AnyObject> else { return }
            let allBrands = responseObject["data"] as? [NSDictionary]
            Product.importDatas(allBrands, false, true)
        }
    }
    
    private func handleError(error: NSError?) {
        print("\(error)")
    }
    
    func loadData() {
        self.beginRefreshing()
        
        ServerManager.shared.requestAllBrands(
            { (responseObject: AnyObject?) -> () in self.handleAllBrandsSuccess(responseObject) },
            { (error: NSError?) -> () in self.handleError(error) }
        );
        
        ServerManager.shared.requestAllProductIDs(
            { (responseObject: AnyObject?) -> () in self.handleAllProductsSuccess(responseObject) },
            { (error: NSError?) -> () in self.handleError(error) }
        )
    }
}

// MARK: - CollectionView Delegate Methods
extension BrandsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
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
        let cell: BrandCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("BrandCollectionViewCell", forIndexPath: indexPath) as! BrandCollectionViewCell
        
        let brand = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Brand
        
        cell.lblTitle?.clipsToBounds = true
        cell.lblTitle?.layer.shadowRadius = 1
        cell.lblTitle?.layer.shadowColor = UIColor.blackColor().CGColor
        cell.lblTitle?.layer.shadowOpacity = 1
        cell.lblTitle?.layer.shadowOffset = CGSizeZero
        if let label = brand.label {
            cell.lblTitle?.text = label
        }

        if let imageURLString = brand.imageUrl, let imageURL = NSURL(string: imageURLString) {
            cell.fgImageView?.sd_setImageWithURL(imageURL, completed: { (image: UIImage!, error: NSError!, type: SDImageCacheType, url: NSURL!) -> Void in
//                collectionView.reloadItemsAtIndexPaths([indexPath])
            })
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("\(indexPath.row)")
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.isEdgeSwiping = false
    }
}

//MARK: - CollectionView Waterfall Layout
extension BrandsViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func setupCollectionView() {
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.itemRenderDirection = .LeftToRight
        layout.minimumColumnSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1)
        
        // Add the waterfall layout to your collection view
        self.collectionView().collectionViewLayout = layout
        
        (self.collectionView().collectionViewLayout as! CHTCollectionViewWaterfallLayout).columnCount = 2
        
        // Collection view attributes
        self.collectionView().autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        self.collectionView().alwaysBounceVertical = true
    }
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        return CGSizeMake(3, 2)
    }
}

// MARK: UIGestureRecognizerDelegate (interactivePopGestureRecognizer.delegate)
extension BrandsViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        self.isEdgeSwiping = true
        return true
    }
}

// MARK: - UINavigationControllerDelegate
extension BrandsViewController: UINavigationControllerDelegate {
    
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

// MARK: - Refreshing
extension BrandsViewController {
    
    func setupRefreshControls() {
        let header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadData()
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
    }
    
    func beginRefreshing() {
        ++_requestsCount
        MBProgressHUD.showLoader()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func endRefreshing() {
        --_requestsCount
        if _requestsCount <= 0 {
            self.collectionView().mj_header.endRefreshing()
            MBProgressHUD.hideLoader()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
    }
}

// MARK: - Custom cells
class BrandCollectionViewCell: UICollectionViewCell {
    @IBOutlet var fgImageView: UIImageView!
    @IBOutlet var lblTitle: UILabel?
    
    override func prepareForReuse() {
        lblTitle?.text = nil
        lblTitle?.attributedText = nil
    }
}
