//
//  BrandsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class BrandsViewController: BaseViewController {
    
    // Override BaseViewController
    @IBOutlet var _collectionView: UICollectionView!
    
    var searchController: UISearchController?
    
    override func collectionView() -> UICollectionView {
        return _collectionView
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        return Brand.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "order", ascending: true)
    }
    
    // Properties
    var transition: ZoomInteractiveTransition?
    
    var selectedIndexPath: NSIndexPath?
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Bars
        self.hidesBottomBarWhenPushed = false
        
        // UIViewController
        self.title = NSLocalizedString("brands_vc_title")
        
        // UITabBarItem
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("brands_vc_tab_title"), image: UIImage(named: "img_tab_tag"), selectedImage: UIImage(named: "img_tab_tag_selected"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // To let ProductsViewController's viewWillAppear()/viewDidAppear() be called
        self.navigationController?.delegate = self
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.collectionView(), 0, true, true, false, true)
        
        // Setups
        self.setupCollectionView()
        self.setupRefreshControls()
        
        // Setup Search Controller
        self.setupSearchController()
        
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
        // Hide toolbar. No animation because it might need to be shown immediately
        self.hideToolbar(false)
        // For navigation bar search bar
        self.definesPresentationContext = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // For navigation bar search bar
        self.definesPresentationContext = false
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BrandsCollectionViewCell", forIndexPath: indexPath) as! BrandsCollectionViewCell
        
        let brand = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Brand
        
        if let label = brand.label {
            cell.lblTitle?.text = label
        }

        if let imageURLString = brand.imageUrl, let imageURL = NSURL(string: imageURLString) {
            cell.fgImageView?.sd_setImageWithURL(imageURL,
                placeholderImage: UIImage.imageWithRandomColor(nil),
                options: [.ContinueInBackground, .AllowInvalidSSLCertificates, .DelayPlaceholder])
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = indexPath
        
        let brand = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Brand
        
        let brandViewController = BrandViewController.instantiate()
        
        // Prepare attributes
        var imageURLString: String? = nil
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            guard let localBrand = brand.MR_inContext(localContext) else { return }
            brandViewController.brandID = localBrand.id
            brandViewController.brandName = localBrand.label
            brandViewController.brandCategories = localBrand.categories as! [NSDictionary]?
            imageURLString = localBrand.imageUrl
        })
        
        // Load brand image
        var image: UIImage?
        if let imageURLString = imageURLString, let imageURL = NSURL(string: imageURLString) {
            brandViewController.brandImageURL = imageURL
            
            let cacheKey = SDWebImageManager.sharedManager().cacheKeyForURL(imageURL)
            image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(cacheKey)
        }
        if image == nil {
            if let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as? BrandsCollectionViewCell {
                image = cell.fgImageView.image
            }
        }
        brandViewController.brandImage = image
        
        // Push view
        self.navigationController?.pushViewController(brandViewController, animated: true)
    }
}

//MARK: - CollectionView Waterfall Layout
extension BrandsViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func setupCollectionView() {
        self.collectionView().indicatorStyle = .White

        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.itemRenderDirection = .LeftToRight
        layout.minimumColumnSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsetsMake(1, 0, 1, 0)
        
        // Add the waterfall layout to your collection view
        self.collectionView().collectionViewLayout = layout
        
        (self.collectionView().collectionViewLayout as! CHTCollectionViewWaterfallLayout).columnCount = 2
        
        // Collection view attributes
        self.collectionView().autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        self.collectionView().alwaysBounceVertical = true
        
        // Load data
        self.collectionView().reloadData()
    }
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        return CGSizeMake(3, 2)
    }
}

// MARK: ZoomInteractiveTransition
extension BrandsViewController: ZoomTransitionProtocol {
    
    private func imageViewForZoomTransition() -> UIImageView? {
        if let indexPath = self.selectedIndexPath,
            cell = self.collectionView().cellForItemAtIndexPath(indexPath) as? BrandsCollectionViewCell,
            imageView = cell.fgImageView {
                return imageView
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
        if ((operation == .Push && fromVC === self && toVC is BrandViewController) ||
            (operation == .Pop && fromVC is BrandViewController && toVC === self)) {
            return true
        }
        return false
    }
}

// MARK: - Refreshing
extension BrandsViewController {
    
    func setupRefreshControls() {
        let header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            DataManager.shared.updateData({ (_, _) -> () in
                self.endRefreshing()
            })
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
        header.lastUpdatedTimeKey = "lastUpdatedTimeKeyBrandsViewController"
        self.collectionView().mj_header = header
    }
    
    func beginRefreshing() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func endRefreshing() {
        self.collectionView().mj_header.endRefreshing()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

// MARK: - SearchControler
extension BrandsViewController: UISearchControllerDelegate {
    
    func setupSearchController() {
        let searchResultsController = ProductsViewController.instantiate()
        searchResultsController.isSearchResultsViewController = true
        searchResultsController.searchFromViewController = self
        self.searchController = UISearchController(searchResultsController: searchResultsController)
        self.searchController!.searchResultsUpdater = searchResultsController
        self.searchController!.searchBar.placeholder = NSLocalizedString("brands_vc_search_bar_placeholder")
        self.searchController!.hidesNavigationBarDuringPresentation = false
        self.navigationItem.titleView = self.searchController!.searchBar
        
        // Workaround of warning: Attempting to load the view of a view controller while it is deallocating is not allowed and may result in undefined behavior (<UISearchController: 0x7f9307f11ff0>)
//        let _ = self.searchController?.view // Force loading the view
    }
}

// MARK: - UINavigationControllerDelegate
extension BrandsViewController: UINavigationControllerDelegate {
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        viewController.viewWillAppear(animated)
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        viewController.viewDidAppear(animated)
    }
}

// MARK: - Custom cells
class BrandsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var fgImageView: UIImageView!
    @IBOutlet var lblTitle: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lblTitle?.clipsToBounds = true
//        self.lblTitle?.layer.shadowRadius = 1
//        self.lblTitle?.layer.shadowColor = UIColor.blackColor().CGColor
//        self.lblTitle?.layer.shadowOpacity = 1
//        self.lblTitle?.layer.shadowOffset = CGSizeZero
    }
    
    override func prepareForReuse() {
        lblTitle?.text = nil
    }
}
