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
    var searchTexts: [String]?
    var searchFromViewController: UIViewController?
    
    let bottomMargin: CGFloat = 53.0 // Height of 3 Labels + inner margins
    let cellMargin: CGFloat = 4.0 // Cell outer margins
    var cellWidth: CGFloat = 0
    
    override func collectionView() -> UICollectionView {
        return _collectionView
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        if (self.isSearchResultsViewController &&
            (self.searchTexts == nil || (self.searchTexts!.count == 1 && self.searchTexts!.first == ""))) {
            return nil
        }
        var predicates = [NSPredicate]()
        if let brandId = self.brandID {
            predicates.append(FmtPredicate("brandId == %@", brandId))
        }
        if let categoryID = self.categoryID {
            predicates.append(FmtPredicate("categories CONTAINS %@", FmtString("|%@|",categoryID)))
        }
        if let searchTexts = self.searchTexts {
            var searchTextPredicates = [NSPredicate]()
            for searchText in searchTexts {
                if searchText.characters.count > 0 {
                    searchTextPredicates.append(FmtPredicate("appSearchText CONTAINS[cd] %@", searchText))
                }
            }
            if searchTextPredicates.count > 0 {
                predicates.append(NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: searchTextPredicates))
            }
        }
        return Product.MR_fetchAllGroupedBy(
            nil,
            withPredicate: NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: predicates),
            sortedBy: self.isSearchResultsViewController ? "appPricesCount:false,order:true,id:true" : "order,id",
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
        
        // Bars
        self.hidesBottomBarWhenPushed = true
        
        // UIViewController
        self.title = NSLocalizedString("products_vc_title")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.categoryName
        
        // Setups
        self.setupCollectionView()
        
        if !self.isSearchResultsViewController {
            // Setup Search Controller
            self.setupSearchController()
        }
        
        // Pre-calculate cell width
        self.cellWidth = (self.view.frame.size.width - cellMargin * 3) / 2.0
        
        // Fix scroll view insets
        if self.isSearchResultsViewController {
            var tabBarIsVisible = false
            if let tabBarIsHidden = self.searchFromViewController?.hidesBottomBarWhenPushed {
                tabBarIsVisible = !tabBarIsHidden
            }
            self.updateScrollViewInset(self.collectionView(), 0, true, true, false, tabBarIsVisible)
        } else {
            self.updateScrollViewInset(self.collectionView(), 0, true, true, false, false)
        }
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
        MagicalRecord.saveWithBlockAndWait { (localContext) -> Void in
            if let productID = product.id,
                _ = FavoriteProduct.MR_findFirstByAttribute("id", withValue: productID, inContext: localContext) {
                cell.isFavorite = true
            } else {
                cell.isFavorite = false
            }
        }

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
            DLog(FmtString("Product ID = %@, images: %@",product.id ?? "?",product.images ?? "?"))
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
        // Only available for opening a product from products view controller
        if ((operation == .Push && fromVC === self && toVC is ProductViewController) ||
            (operation == .Pop && fromVC is ProductViewController && toVC === self)) {
                return true
        }
        return false
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
                product.toggleFavorite({ (data: AnyObject?) -> () in
                    self.collectionView().reloadItemsAtIndexPaths([indexPath])
                })
            }
        }
    }
}

// MARK: UISearchResultsUpdating
extension ProductsViewController: UISearchResultsUpdating {
    
    func startSearchTimer() {
        stopSearchTimer()
        self.searchTimer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: "reloadData", userInfo: nil, repeats: false)
    }
    
    func stopSearchTimer() {
        self.searchTimer?.invalidate()
        self.searchTimer = nil
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.stopSearchTimer()
        
        if searchController.active {
            if let searchText = searchController.searchBar.text {
                let searchTexts = searchText.componentsSeparatedByString(" ")
                self.searchTexts = searchTexts.map({Product.normalized($0).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())})
            } else {
                self.searchTexts = nil
            }
        } else {
            self.searchTexts = nil
        }
        
        self.startSearchTimer()
    }
}

// MARK: - SearchControler
extension ProductsViewController: UISearchControllerDelegate {
    
    func showSearchController() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setRightBarButtonItem(nil, animated: false)
        self.navigationItem.titleView = self.searchController!.searchBar
        self.searchController!.searchBar.becomeFirstResponder()
    }
    
    func hideSearchController() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "showSearchController")
        self.navigationItem.titleView = nil
    }
    
    func setupSearchController() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "showSearchController")

        let searchResultsController = ProductsViewController.instantiate()
        searchResultsController.isSearchResultsViewController = true
        searchResultsController.searchFromViewController = self
        searchResultsController.brandID = self.brandID
        searchResultsController.categoryID = self.categoryID
        self.searchController = UISearchController(searchResultsController: searchResultsController)
        self.searchController!.delegate = self
        self.searchController!.searchResultsUpdater = searchResultsController
        self.searchController!.searchBar.placeholder = FmtString(NSLocalizedString("products_vc_search_bar_placeholder"), self.categoryName ?? "")
        self.searchController!.hidesNavigationBarDuringPresentation = false
        
        // Workaround of warning: Attempting to load the view of a view controller while it is deallocating is not allowed and may result in undefined behavior (<UISearchController: 0x7f9307f11ff0>)
//        let _ = self.searchController?.view // Force loading the view
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        self.navigationItem.setHidesBackButton(false, animated: false)
        self.hideSearchController()
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
