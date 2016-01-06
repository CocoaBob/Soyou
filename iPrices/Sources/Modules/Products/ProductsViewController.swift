//
//  ProductsViewController.swift
//  iPrices
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class ProductsViewController: BaseViewController {
    
    @IBOutlet var _collectionView: UICollectionView?
    
    var lastNavigationControllerDelegate: UINavigationControllerDelegate?
    var lastInteractivePopGestureRecognizerDelegate: UIGestureRecognizerDelegate?
    
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
        
        self.takeOverDelegates()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.hideToolbar(false)
        
        self.takeOverDelegates()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.restoreDelegates()
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
        if let brandName = product.brandLabel {
            cell.lblBrand?.text = brandName
        }
        if let prices = product.prices as? NSArray {
            if let price = prices.firstObject as! NSDictionary?, priceNumber = price["price"] as? NSNumber {
                cell.lblPrice?.text = FmtString("%@",priceNumber)
            }
        }
        
        if let images = product.images as? NSArray, let imageURLString = images.firstObject as? String, let imageURL = NSURL(string: imageURLString) {
            cell.fgImageView?.sd_setImageWithURL(imageURL,
                placeholderImage: UIImage.imageWithRandomColor(nil),
                options: [.ContinueInBackground, .AllowInvalidSSLCertificates],
                completed: { (image: UIImage!, error: NSError!, type: SDImageCacheType, url: NSURL!) -> Void in
                    UIView.animateWithDuration(0.25, animations: { () -> Void in
                        collectionView.collectionViewLayout.invalidateLayout()
                        }
                    )
            })
        }
        
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
        layout.minimumColumnSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.sectionInset = UIEdgeInsetsMake(4, 4, 4, 4)
        
        // Add the waterfall layout to your collection view
        self.collectionView().collectionViewLayout = layout
        
        (self.collectionView().collectionViewLayout as! CHTCollectionViewWaterfallLayout).columnCount = 2
        
        // Collection view attributes
        self.collectionView().autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        self.collectionView().alwaysBounceVertical = true
    }
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        let product = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Product
        
        if let images = product.images as? NSArray, let imageURLString = images.firstObject as? String, let imageURL = NSURL(string: imageURLString) {
            let cacheKey = SDWebImageManager.sharedManager().cacheKeyForURL(imageURL)
            if let image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(cacheKey) {
                return image.size
            }
        }
        return CGSizeMake(1, 1)
    }
}

// MARK: UIGestureRecognizerDelegate (interactivePopGestureRecognizer.delegate)
extension ProductsViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        self.isEdgeSwiping = true
        return true
    }
}

// MARK: - RMPZoomTransitionAnimator
extension ProductsViewController: UINavigationControllerDelegate {
    
    func takeOverDelegates() {
        if let navigationController = self.navigationController {
            if navigationController.delegate == nil || navigationController.delegate! !== self {
                self.lastNavigationControllerDelegate = navigationController.delegate
                self.lastInteractivePopGestureRecognizerDelegate = navigationController.interactivePopGestureRecognizer?.delegate
                
                navigationController.delegate = self
                navigationController.interactivePopGestureRecognizer?.delegate = self
            }
        }
    }
    
    func restoreDelegates() {
        self.navigationController?.delegate = self.lastNavigationControllerDelegate
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self.lastInteractivePopGestureRecognizerDelegate
    }
    
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

// MARK: - Custom cells
class ProductsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var fgImageView: UIImageView!
    @IBOutlet var lblBrand: UILabel?
    @IBOutlet var lblTitle: UILabel?
    @IBOutlet var lblPrice: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        lblBrand?.text = nil
        lblTitle?.text = nil
        lblPrice?.text = nil
        fgImageView.image = UIImage.imageWithRandomColor(nil)
    }
}
