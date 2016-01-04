//
//  ProductsViewController.swift
//  iPrices
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class ProductsViewController: BaseViewController {
    
    @IBOutlet var _collectionView: UICollectionView?
    
    var isEdgeSwiping: Bool = false // Use edge swiping instead of custom animator if interactivePopGestureRecognizer is trigered
    
    var brandID: String?
    var brandName: String?
    var categoryID: NSNumber?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UIViewController
        self.title = NSLocalizedString("products_vc_title")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.collectionView(), false, false)
        
        // Setups
        setupCollectionView()
        setupRefreshControls()
        
        // UINavigationController delegate
        self.navigationController?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        // Data
        if self.fetchedResultsController.fetchedObjects?.count == 0 {
            loadData()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.hideToolbar(false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        endRefreshing()
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        return Product.MR_fetchAllGroupedBy(
            nil,
            withPredicate: FmtPredicate("categories CONTAINS %@", FmtString("|%@|",categoryID ?? "")),
            sortedBy: "order",
            ascending: true)
    }
    
    override func collectionView() -> UICollectionView {
        return _collectionView!
    }
}

// MARK: Data
extension ProductsViewController {
    
    func loadData() {
//        self.beginRefreshing()
//        DataManager.shared.loadAllBrands { () -> () in
//            self.endRefreshing()
//        }
    }
}

// MARK: - CollectionView Delegate Methods
extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
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
        let cell: ProductsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductsCollectionViewCell", forIndexPath: indexPath) as! ProductsCollectionViewCell
        
        let product = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Product
        
        if let title = product.title {
            cell.lblTitle?.text = title
        }
        if let brandName = product.title {
            cell.lblBrand?.text = brandName
        }
        if let prices = product.prices as? NSArray {
            if let price = prices.firstObject as! NSDictionary? {
                cell.lblBrand?.text = price["price"] as! String?
            }
        }
        
        
//        if let imageURLString = product.imageUrl, let imageURL = NSURL(string: imageURLString) {
//            cell.fgImageView?.sd_setImageWithURL(imageURL,
//                placeholderImage: UIImage.imageWithRandomColor(),
//                options: [.ProgressiveDownload, .ContinueInBackground, .AllowInvalidSSLCertificates, .HighPriority, .DelayPlaceholder])
//        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let product = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Product
        
        if let productViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProductViewController") as? ProductViewController {
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                let localProduct = product.MR_inContext(localContext)
                DLog(localProduct)
            })
            self.navigationController?.pushViewController(productViewController, animated: true)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.isEdgeSwiping = false
    }
}

//MARK: - CollectionView Waterfall Layout
extension ProductsViewController: CHTCollectionViewDelegateWaterfallLayout {
    
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
extension ProductsViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        self.isEdgeSwiping = true
        return true
    }
}

// MARK: - UINavigationControllerDelegate
extension ProductsViewController: UINavigationControllerDelegate {
    
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
extension ProductsViewController {
    
    func setupRefreshControls() {
        let header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadData()
        })
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
        MBProgressHUD.showLoader(self.view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func endRefreshing() {
        self.collectionView().mj_header.endRefreshing()
        MBProgressHUD.hideLoader(self.view)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

// MARK: - Custom cells
class ProductsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var fgImageView: UIImageView!
    @IBOutlet var lblBrand: UILabel?
    @IBOutlet var lblTitle: UILabel?
    @IBOutlet var lblPrice: UILabel?
    
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
