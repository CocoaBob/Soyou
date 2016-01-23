//
//  BrandsViewController.swift
//  iPrices
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class BrandsViewController: BaseViewController {
    
    @IBOutlet var _collectionView: UICollectionView?
    
    var transition: ZoomInteractiveTransition?
    
    var selectedIndexPath: NSIndexPath?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UIViewController
        self.title = NSLocalizedString("brands_vc_title")
        
        // UITabBarItem
        self.tabBarItem = UITabBarItem(title: NSLocalizedString("brands_vc_tab_title"), image: UIImage(named: "img_tab_tag"), selectedImage: UIImage(named: "img_tab_tag_selected"))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.collectionView(), 0, false, false)
        
        // Setups
        setupCollectionView()
        
        // Transitions
        self.transition = ZoomInteractiveTransition(navigationController: self.navigationController)
        self.transition?.handleEdgePanBackGesture = false
        self.transition?.transitionDuration = 0.3
        let animationOpts: UIViewAnimationOptions = .CurveEaseOut
        let keyFrameOpts: UIViewKeyframeAnimationOptions = UIViewKeyframeAnimationOptions(rawValue: animationOpts.rawValue)
        self.transition?.transitionAnimationOption = [UIViewKeyframeAnimationOptions.CalculationModeCubic, keyFrameOpts]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Hide toolbar. No animation because it might need to be shown immediately
        self.hideToolbar(false)
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        return Brand.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "order", ascending: true)
    }
    
    override func collectionView() -> UICollectionView {
        return _collectionView!
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
        let cell: BrandsCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("BrandsCollectionViewCell", forIndexPath: indexPath) as! BrandsCollectionViewCell
        
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
        
        if let brandViewController = self.storyboard?.instantiateViewControllerWithIdentifier("BrandViewController") as? BrandViewController {
            // Prepare attributes
            var imageURLString: String? = nil
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                guard let localBrand = brand.MR_inContext(localContext) else { return }
                brandViewController.brandID = "\(localBrand.id)"
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
            let cell = self.collectionView().cellForItemAtIndexPath(indexPath) as? BrandsCollectionViewCell,
            let imageView = cell.fgImageView {
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
}

// MARK: - Custom cells
class BrandsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var fgImageView: UIImageView!
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
    }
}
