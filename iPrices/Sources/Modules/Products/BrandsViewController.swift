//
//  BrandsViewController.swift
//  iPrices
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class BrandsViewController: BaseViewController {
    
    @IBOutlet var _collectionView: UICollectionView?
    
    var selectedCell: BrandsCollectionViewCell?
    var selectedIndexPath: NSIndexPath?
    
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
        
        // UINavigationController delegate
        self.navigationController?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
                options: [.ContinueInBackground, .AllowInvalidSSLCertificates])
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
                let localBrand = brand.MR_inContext(localContext)
                brandViewController.brandID = "\(localBrand.id)"
                brandViewController.brandName = localBrand.label
                brandViewController.brandCategories = localBrand.categories as! [NSDictionary]?
                imageURLString = localBrand.imageUrl
            })
            // Load image
            guard let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as? BrandsCollectionViewCell else { return }
            self.selectedCell = cell
            
            brandViewController.brandImage = cell.fgImageView.image
            if let imageURLString = imageURLString, let imageURL = NSURL(string: imageURLString) {
                if !SDWebImageManager.sharedManager().cachedImageExistsForURL(imageURL) {
                    brandViewController.brandImageURL = imageURL
                }
            }
            
            // Push view
            self.navigationController?.pushViewController(brandViewController, animated: true)
        }
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
        layout.sectionInset = UIEdgeInsetsZero
        
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

// MARK: - RMPZoomTransition
extension BrandsViewController: UINavigationControllerDelegate, RMPZoomTransitionAnimating, RMPZoomTransitionDelegate {
    
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
    
    func imageViewFrame() -> CGRect {
        if let indexPath = self.selectedIndexPath,
            let cell = self.collectionView().cellForItemAtIndexPath(indexPath) as? BrandsCollectionViewCell,
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
        imageView.image = self.selectedCell?.fgImageView!.image
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
