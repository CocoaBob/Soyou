//
//  ProductsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class ProductsViewController: BaseViewController {
    
    // Override BaseViewController
    @IBOutlet var _collectionView: UICollectionView!
    
    var searchController: UISearchController?
    var searchTimer: NSTimer?
    
    var isSearchResultsViewController: Bool = false
    var searchText: String?
    
    let bottomMargin: CGFloat = 53.0 // Height of 3 Labels + inner margins
    let cellMargin: CGFloat = 4.0 // Cell outer margins
    var cellWidth: CGFloat = 0
    
    override func collectionView() -> UICollectionView {
        return _collectionView
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        var predicates = [NSPredicate]()
        if let brandId = self.brandID {
            predicates.append(FmtPredicate("brandId == %@", brandId))
        }
        if let categoryID = self.categoryID {
            predicates.append(FmtPredicate("categories CONTAINS %@", FmtString("|%@|",categoryID)))
        }
        if let searchText = self.searchText {
            predicates.append(FmtPredicate("appSearchText CONTAINS[cd] %@", searchText))
        }
        return Product.MR_fetchAllGroupedBy(
            nil,
            withPredicate: NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: predicates),
            sortedBy: "order,id",
            ascending: true)
    }
    
    // Properties
    var selectedIndexPath: NSIndexPath?
    
    var categoryName: String?
    var categoryID: NSNumber?
    var brandID: NSNumber?
    
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
        
        self.title = self.categoryName
        
        if !self.isSearchResultsViewController {
            // Fix scroll view insets
            self.updateScrollViewInset(self.collectionView(), 0, false, false)
        }
        
        // Setups
        self.setupCollectionView()
        
        // Setup Search Controller
        self.setupSearchController()
        
        // Pre-calculate cell width
        self.cellWidth = (self.view.frame.size.width - cellMargin * 3) / 2.0
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        // Hide toolbar. No animation because it might need to be shown immediately
        self.hideToolbar(false)
        
        if !self.isSearchResultsViewController {
            // Update the selected cell in case if appIsFavorite is changed
            if let selectedIndexPath = self.selectedIndexPath {
                self.collectionView().reloadItemsAtIndexPaths([selectedIndexPath])
            }
        }
        
        // Load favorites
        if let categoryID = self.categoryID {
            if UserManager.shared.isLoggedIn {
                DataManager.shared.requestProductFavorites(categoryID) { responseObject, error in
                    self.reloadData()
                }
            }
        }
        // For navigation bar search bar
        self.definesPresentationContext = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // For navigation bar search bar
        self.definesPresentationContext = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        DLog("didReceiveMemoryWarning")
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
        cell.lblPrice?.text = CurrencyManager.shared.cheapestFormattedPriceInCHY(product.prices as? [NSDictionary])
        cell.isFavorite = product.appIsFavorite?.boolValue

        if let images = product.images as? NSArray,
            imageURLString = images.firstObject as? String,
            imageURL = NSURL(string: imageURLString) {
            cell.fgImageView?.sd_setImageWithURL(imageURL,
                placeholderImage: UIImage.imageWithRandomColor(nil),
                options: [.ContinueInBackground, .AllowInvalidSSLCertificates],
                completed: { (image: UIImage!, error: NSError!, type: SDImageCacheType, url: NSURL!) -> Void in
                    if image != nil && image.size.width != 0 {
                        MagicalRecord.saveWithBlock { (localContext: NSManagedObjectContext!) -> Void in
                            guard let localProduct = product.MR_inContext(localContext) else { return }
                            localProduct.appImageRatio = NSNumber(double: Double(image.size.height / image.size.width))
                        }
                    }
            })
        } else {
            DLog(FmtString("Product ID = %@, images:\n%@",product.id!,product.images!))
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = indexPath
        
        let product = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Product
        
        let productViewController = ProductViewController.instantiate()
        productViewController.product = product
        
        if let cell = self.collectionView().cellForItemAtIndexPath(indexPath) as? ProductsCollectionViewCell,
            imageView = cell.fgImageView,
            image = imageView.image {
                productViewController.firstImage = image
        }
        if self.isSearchResultsViewController {
            self.presentingViewController?.navigationController?.pushViewController(productViewController, animated: true)
        } else {
            self.navigationController?.pushViewController(productViewController, animated: true)
        }
    }
}

// MARK: ZoomInteractiveTransition
extension ProductsViewController: ZoomTransitionProtocol {
    
    private func imageViewForZoomTransition() -> UIImageView? {
        if let indexPath = self.selectedIndexPath,
            cell = self.collectionView().cellForItemAtIndexPath(indexPath) as? ProductsCollectionViewCell,
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
            returnImageView.contentMode = .ScaleAspectFit
            return returnImageView
        }
        return nil
    }
    
    func shouldAllowZoomTransitionForOperation(operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController!, toViewController toVC: UIViewController!) -> Bool {
        if self.isSearchResultsViewController {
            return false
        }
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
        layout.minimumColumnSpacing = cellMargin
        layout.minimumInteritemSpacing = cellMargin
        layout.sectionInset = UIEdgeInsetsMake(cellMargin, cellMargin, cellMargin, cellMargin)
        
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
        
        var size = CGSizeMake(1, 1) // Default size for product
        if let imageRatio = product.appImageRatio?.doubleValue {
            let cellHeight = self.cellWidth * CGFloat(imageRatio) + bottomMargin
            size = CGSizeMake(self.cellWidth, cellHeight)

        }
        return size
    }
}

//MARK: - Actions
extension ProductsViewController {
    
    @IBAction func favProduct(sender: UIButton) {
        let position = sender.convertPoint(CGPointZero, toView: self.collectionView())
        guard let indexPath = self.collectionView().indexPathForItemAtPoint(position) else { return }
        UserManager.shared.loginOrDo() { () -> () in
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
        }
    }
}

// MARK: UISearchResultsUpdating
extension ProductsViewController: UISearchResultsUpdating {
    
    func startSearchTimer() {
        stopSearchTimer()
        self.searchTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "reloadData", userInfo: nil, repeats: false)
    }
    
    func stopSearchTimer() {
        self.searchTimer?.invalidate()
        self.searchTimer = nil
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.stopSearchTimer()
        
        if searchController.active {
            if let searchText = searchController.searchBar.text {
                self.searchText = Product.normalized(searchText).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            } else {
                self.searchText = nil
            }
        } else {
            self.searchText = nil
        }
        
        self.startSearchTimer()
    }
}

// MARK: - SearchControler
extension ProductsViewController: UISearchControllerDelegate {
    
    func setupSearchController() {
        let searchResultsController = ProductsViewController.instantiate()
        searchResultsController.isSearchResultsViewController = true
        searchResultsController.brandID = self.brandID
        searchResultsController.categoryID = self.categoryID
        self.searchController = UISearchController(searchResultsController: searchResultsController)
        self.searchController?.searchResultsUpdater = searchResultsController
        self.searchController!.searchBar.placeholder = FmtString(NSLocalizedString("products_vc_search_bar_placeholder"),self.categoryName ?? "")
        self.searchController?.hidesNavigationBarDuringPresentation = false
        self.navigationItem.titleView = self.searchController!.searchBar
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
            } else{
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
