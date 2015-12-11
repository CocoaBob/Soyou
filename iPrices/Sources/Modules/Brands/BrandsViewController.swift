//
//  BrandsViewController.swift
//  iPrices
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class BrandsViewController: BaseViewController {
    
    @IBOutlet var _collectionView: UICollectionView?
    
    var isEdgeSwiping: Bool = false // Use edge swiping instead of custom animator if interactivePopGestureRecognizer is trigered
    
    // TODO: To be replaced
    var brands = [
        ["id": 1,"label": "BURBERRY","imageUrl": "http://www.geocities.ws/iprice/imgs/o-burberry.jpg","extra": "","type": "brand"],
        ["id": 2,"label": "BALENCIAGA","imageUrl": "http://www.geocities.ws/iprice/imgs/o-balenciaga.jpg","extra": "","type": "brand"]
    ]
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UIViewController
        self.title = NSLocalizedString("brands_view_controller_title", comment: "")
        
        // UITabBarItem
        self.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "img_tab_tag"), selectedImage: UIImage(named: "img_tab_tag_selected"))
        self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.collectionView(), toolbarIsVisible: false)
        
        // Setups
        setupCollectionView()

        // UINavigationController delegate
        self.navigationController?.delegate = self;
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        
        // Data
        requestBrandsList(nil)
    }
    
    override func collectionView() -> UICollectionView {
        return _collectionView!
    }
}

// MARK: Data
extension BrandsViewController {
    private func handleSuccess(responseObject: AnyObject?, _ relativeID: NSNumber?) {
        
    }
    
    private func handleError(error: NSError?) {
        print("\(error)")
    }
    
    func requestBrandsList(relativeID: NSNumber?) {
        
    }
}

// MARK: - CollectionView Delegate Methods
extension BrandsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {

    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.brands.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: BrandCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("BrandCollectionViewCell", forIndexPath: indexPath) as! BrandCollectionViewCell
        
        let brand = self.brands[indexPath.row]
        
        cell.tltTextView?.clipsToBounds = true
        cell.tltTextView?.layer.shadowRadius = 1
        cell.tltTextView?.layer.shadowColor = UIColor.blackColor().CGColor
        cell.tltTextView?.layer.shadowOpacity = 1
        cell.tltTextView?.layer.shadowOffset = CGSizeZero
        cell.tltTextView?.text = brand["label"] as! String

        if let imageURLString = brand["imageUrl"], let imageURL = NSURL(string: imageURLString as! String) {
            cell.fgImageView?.sd_setImageWithURL(imageURL, placeholderImage: UIImage(named: "iTunesArtwork"), completed: { (image: UIImage!, error: NSError!, type: SDImageCacheType, url: NSURL!) -> Void in
                collectionView.reloadItemsAtIndexPaths([indexPath])
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
        
        // Collection view attributes
        self.collectionView().autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        self.collectionView().alwaysBounceVertical = true
        
        // Add the waterfall layout to your collection view
        self.collectionView().collectionViewLayout = layout
        
        (self.collectionView().collectionViewLayout as! CHTCollectionViewWaterfallLayout).columnCount = 2
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

// MARK: - Custom cells
class BrandCollectionViewCell: UICollectionViewCell {
    @IBOutlet var fgImageView: UIImageView!
    @IBOutlet var tltTextView: UITextView!
    
    override func prepareForReuse() {
        tltTextView?.text = nil
        tltTextView?.attributedText = nil
    }
}
