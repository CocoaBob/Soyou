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
    @IBOutlet var _loadingView: UIView!
    @IBOutlet var _loadingIndicator: UILabel!
    
    var searchController: UISearchController?
    var searchTimer: NSTimer?
    
    var isSearchResultsViewController: Bool = false
//    var isQuickSearch: Bool = true
    var searchTexts: [String]?
    var searchFromViewController: UIViewController?
    var isLoadingIndicatorVisible: Bool = true {
        didSet {
            self._loadingView.hidden = !isLoadingIndicatorVisible
        }
    }
    
    let bottomMargin: CGFloat = 53.0 // Height of 3 Labels + inner margins
    let cellMargin: CGFloat = 4.0 // Cell outer margins
    var cellWidth: CGFloat = 0
    
    override func collectionView() -> UICollectionView {
        return _collectionView
    }
    
    override func createFetchedResultsController(context: NSManagedObjectContext) -> NSFetchedResultsController? {
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
//            if self.isQuickSearch {
//                let searchString = searchTexts.joinWithSeparator(" ")
//                if !searchString.characters.isEmpty {
//                    searchTextPredicates.append(FmtPredicate("title BEGINSWITH[cd] %@", searchString))
//                }
//            } else {
                for searchText in searchTexts {
                    if !searchText.characters.isEmpty {
                        searchTextPredicates.append(FmtPredicate("appSearchText CONTAINS[cd] %@", searchText))
                    }
                }
//            }
            if !searchTextPredicates.isEmpty {
                predicates.append(NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: searchTextPredicates))
            }
        }
        
        let request = Product.MR_requestAllSortedBy(
            self.isSearchResultsViewController ? "appPricesCount:false,order:true,id:true" : "order,id",
            ascending: true,
            withPredicate: NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: predicates),
            inContext: context)
        return Product.MR_fetchController(request,
            delegate: self,
            useFileCache: false,
            groupedBy: nil,
            inContext: context)
    }
    
    // Properties
    var selectedIndexPath: NSIndexPath?
    
    var categoryName: String?
    var categoryID: NSNumber?
    var brandID: NSNumber?
    
    // Class methods
    class func instantiate() -> ProductsViewController {
        return (UIStoryboard(name: "ProductsViewController", bundle: nil).instantiateViewControllerWithIdentifier("ProductsViewController") as? ProductsViewController)!
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
        
        // Load data
        self.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        
        // Hide toolbar. No animation because it might need to be shown immediately
        self.hideToolbar(false)
        
        // For navigation bar search bar
        self.definesPresentationContext = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Reload in case if appIsFavorite is changed
        self.collectionView().reloadData()
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
        if let sections = self.fetchedResultsController?.sections {
            return sections.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let returnValue = self.fetchedResultsController?.sections![section].numberOfObjects {
            return returnValue
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCellWithReuseIdentifier("ProductsCollectionViewCell", forIndexPath: indexPath) as? ProductsCollectionViewCell)!
        
        if let product = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? Product {
            cell.lblTitle?.text = product.title
            cell.lblBrand?.text = product.brandLabel
            cell.lblPrice?.text = CurrencyManager.shared.cheapestFormattedPriceInUserCurrency(product.prices)
            cell.isFavorite = product.isFavorite()
            cell.fgImageView.image = nil
            
            if let images = product.images as? NSArray,
                imageURLString = images.firstObject as? String,
                imageURL = NSURL(string: imageURLString) {
                    cell.fgImageView?.sd_setImageWithURL(imageURL,
                        placeholderImage: UIImage(named: "img_placeholder_1_1_m"),
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
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = indexPath
        
        guard let product = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? Product else {
            return
        }
            
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
            returnImageView.clipsToBounds = true
            return returnImageView
        }
        return nil
    }
    
    func shouldAllowZoomTransitionForOperation(operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController!, toViewController toVC: UIViewController!) -> Bool {
        if self.isSearchResultsViewController || self.presentedViewController is UISearchController {
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
        
        (self.collectionView().collectionViewLayout as? CHTCollectionViewWaterfallLayout)?.columnCount = 2
        
        // Collection view attributes
        self.collectionView().autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        self.collectionView().alwaysBounceVertical = true
    }
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        var size = CGSize(width: 1, height: 1) // Default size for product
        if let product = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? Product {
            if let imageRatio = product.appImageRatio?.doubleValue {
                let cellHeight = self.cellWidth * CGFloat(imageRatio) + bottomMargin
                size = CGSize(width: self.cellWidth, height: cellHeight)
                
            }
        }
        return size
    }
}

//MARK: - Actions
extension ProductsViewController {
    
    @IBAction func favProduct(sender: UIButton) {
        let position = sender.convertPoint(CGPoint.zero, toView: self.collectionView())
        guard let indexPath = self.collectionView().indexPathForItemAtPoint(position) else { return }
        UserManager.shared.loginOrDo() { () -> () in
            if let product = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? Product {
                product.toggleFavorite({ (data: AnyObject?) -> () in
                    self.collectionView().reloadItemsAtIndexPaths([indexPath])
                })
            }
        }
    }
}

// MARK: - Reload data
extension ProductsViewController {
    
    override func reloadData() {
        // Show indicator
        _loadingIndicator.text = NSLocalizedString("products_vc_loading")
        self.isLoadingIndicatorVisible = true
        
        // Reload Data
        super.reloadData()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
            if let sections = self.fetchedResultsController?.sections {
                if !sections.isEmpty {
                    if let rows = self.fetchedResultsController?.sections?[0].numberOfObjects {
                        if rows > 0 {
                            self.isLoadingIndicatorVisible = false
                            return
                        }
                    }
                }
            }
            if self.searchTexts != nil {
                self._loadingIndicator.text = NSLocalizedString("products_vc_no_data")
            }
            self.isLoadingIndicatorVisible = true
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
            _loadingIndicator.text = NSLocalizedString("products_vc_loading")
            self.isLoadingIndicatorVisible = true
//            self.isQuickSearch = false
            self.searchSearchBarText(searchController.searchBar)
        } else {
            self.searchTexts = nil
        }
        
        self.startSearchTimer()
    }
}

// MARK: - UISearchBarDelegate
extension ProductsViewController: UISearchBarDelegate {
    
    func searchSearchBarText(searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            let searchTexts = searchText.componentsSeparatedByString(" ")
            self.searchTexts = searchTexts.map({Product.normalized($0).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())})
        } else {
            self.searchTexts = nil
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        self.isQuickSearch = true
        self.searchSearchBarText(searchBar)
        self.reloadData()
    }
}

// MARK: - SearchControler
extension ProductsViewController: UISearchControllerDelegate {
    
    func setupRightBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "showSearchController")
    }
    
    func showSearchController() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setRightBarButtonItem(nil, animated: false)
        self.navigationItem.titleView = self.searchController!.searchBar
        self.searchController!.searchBar.becomeFirstResponder()
    }
    
    func hideSearchController() {
        self.setupRightBarButtonItem()
        self.navigationItem.titleView = nil
    }
    
    func setupSearchController() {
        self.setupRightBarButtonItem()

        let searchResultsController = ProductsViewController.instantiate()
        searchResultsController.isSearchResultsViewController = true
        searchResultsController.searchFromViewController = self
        searchResultsController.brandID = self.brandID
        searchResultsController.categoryID = self.categoryID
        self.searchController = UISearchController(searchResultsController: searchResultsController)
        self.searchController!.delegate = self
        self.searchController!.searchResultsUpdater = searchResultsController
        self.searchController!.searchBar.delegate = searchResultsController
        self.searchController!.searchBar.placeholder = FmtString(NSLocalizedString("products_vc_search_bar_placeholder"), self.categoryName ?? "")
        self.searchController!.hidesNavigationBarDuringPresentation = false
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
            } else {
                isFavorite = false
            }
        }
    }
}
