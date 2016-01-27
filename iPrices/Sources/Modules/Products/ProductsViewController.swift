//
//  ProductsViewController.swift
//  iPrices
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class ProductsViewController: BaseViewController {
    
    // Override BaseViewController
    @IBOutlet var _collectionView: UICollectionView!
    
    override func collectionView() -> UICollectionView {
        return _collectionView
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        return Product.MR_fetchAllGroupedBy(
            nil,
            withPredicate: FmtPredicate("categories CONTAINS %@", FmtString("|%@|",categoryID ?? "")),
            sortedBy: "order,id",
            ascending: true)
    }
    
    // Properties
    var selectedIndexPath: NSIndexPath?
    
    var brandID: String?
    var brandName: String?
    var categoryID: NSNumber?
    
    // Class methods
    class func instantiate() -> ProductsViewController {
        return UIStoryboard(name: "ProductsViewController", bundle: nil).instantiateViewControllerWithIdentifier("ProductsViewController") as! ProductsViewController
    }
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UIViewController
        self.title = NSLocalizedString("products_vc_title")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.collectionView(), 0, false, false)
        
        // Setups
        setupCollectionView()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        // Hide toolbar. No animation because it might need to be shown immediately
        self.hideToolbar(false)
        
        // Update the selected cell in case if appIsFavorite is changed
        if let selectedIndexPath = self.selectedIndexPath {
            self.collectionView().reloadItemsAtIndexPaths([selectedIndexPath])
        }
        
        // Load favorites
        DataManager.shared.requestProductFavorites(categoryID!) { (data: AnyObject?) -> () in
            self.reloadData()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProductsCollectionViewCell", forIndexPath: indexPath) as! ProductsCollectionViewCell
        
        let product = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Product
        
        cell.lblTitle?.text = product.title
        cell.lblBrand?.text = product.brandLabel
        if let prices = product.prices as? NSArray {
            if let price = prices.firstObject as! NSDictionary?, priceNumber = price["price"] as? NSNumber {
                cell.lblPrice?.text = FmtString("%@",priceNumber)
            }
        }
        cell.isFavorite = product.appIsFavorite?.boolValue

        if let images = product.images as? NSArray, let imageURLString = images.firstObject as? String, let imageURL = NSURL(string: imageURLString) {
            cell.fgImageView?.sd_setImageWithURL(imageURL,
                placeholderImage: UIImage.imageWithRandomColor(nil),
                options: [.ContinueInBackground, .AllowInvalidSSLCertificates],
                completed: { (image: UIImage!, error: NSError!, type: SDImageCacheType, url: NSURL!) -> Void in
                    collectionView.collectionViewLayout.invalidateLayout()
            })
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = indexPath
        
        let product = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Product
        
        let productViewController = ProductViewController.instantiate()
        productViewController.product = product
        
        if let cell = self.collectionView().cellForItemAtIndexPath(indexPath) as? ProductsCollectionViewCell,
            let imageView = cell.fgImageView,
            let image = imageView.image {
                productViewController.firstImage = image
        }
        self.navigationController?.pushViewController(productViewController, animated: true)
    }
}

// MARK: ZoomInteractiveTransition
extension ProductsViewController: ZoomTransitionProtocol {
    
    private func imageViewForZoomTransition() -> UIImageView? {
        if let indexPath = self.selectedIndexPath,
            let cell = self.collectionView().cellForItemAtIndexPath(indexPath) as? ProductsCollectionViewCell,
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
            returnImageView.contentMode = .ScaleAspectFit
            return returnImageView
        }
        return nil
    }
    
    func shouldAllowZoomTransitionForOperation(operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController!, toViewController toVC: UIViewController!) -> Bool {
        if operation == .Pop && fromVC === self && toVC is BrandViewController {
            return false
        }
        return true
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
                let bottomMargin: CGFloat = 51.0
                let cellMargin: CGFloat = 4.0
                let cellWidth = (collectionView.frame.size.width - cellMargin * 3) / 2.0
                let cellHeight = cellWidth * image.size.height / image.size.width + bottomMargin
                return CGSizeMake(cellWidth, cellHeight)
            }
        }
        return CGSizeMake(1, 1)
    }
}

//MARK: - Actions
extension ProductsViewController {
    
    @IBAction func favProduct(sender: UIButton) {
        let position = sender.convertPoint(CGPointZero, toView: self.collectionView())
        guard let indexPath = self.collectionView().indexPathForItemAtPoint(position) else { return }
        if UserManager.shared.isLoggedIn {
            if let product = self.fetchedResultsController.objectAtIndexPath(indexPath) as? Product {
                product.doFavorite({ (data: AnyObject?) -> () in
                    MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                        if let localProduct = product.MR_inContext(localContext) {
                            if let cell = self.collectionView().cellForItemAtIndexPath(indexPath) as? ProductsCollectionViewCell {
                                cell.isFavorite = localProduct.appIsFavorite?.boolValue
                            }
                        }
                    })
                })
            }
        } else {
            let loginViewController = UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")
            loginViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .Done,
                target:loginViewController,
                action: "dismissSelf")
            let navC = UINavigationController(rootViewController: loginViewController)
            self.presentViewController(navC, animated: true, completion: nil)
        }
    }
}

// MARK: - Custom cells
class ProductsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var fgImageView: UIImageView!
    @IBOutlet var lblBrand: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var btnFav: UIButton!
    
    var isFavorite: Bool? {
        didSet {
            if UserManager.shared.isLoggedIn {
                if isFavorite != nil && isFavorite!.boolValue {
                    self.btnFav.setImage(UIImage(named: "img_heart_shadow_selected"), forState: UIControlState.Normal)
                } else {
                    self.btnFav.setImage(UIImage(named: "img_heart_shadow"), forState: UIControlState.Normal)
                }
            }else{
                isFavorite = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        lblBrand.text = nil
        lblTitle.text = nil
        lblPrice.text = nil
        self.isFavorite = false
    }
}
