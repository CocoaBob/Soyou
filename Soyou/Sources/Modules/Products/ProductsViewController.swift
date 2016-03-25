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
    var searchKeywords: [String]?
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
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        if (self.isSearchResultsViewController &&
            (self.searchKeywords == nil || (self.searchKeywords!.count == 1 && self.searchKeywords!.first == ""))) {
            return nil
        }
        var predicates = [NSPredicate]()
        if let brandId = self.brandID {
            predicates.append(FmtPredicate("brandId == %@", brandId))
        }
        if let categoryID = self.categoryID {
            predicates.append(FmtPredicate("categories CONTAINS %@", FmtString("|%@|",categoryID)))
        }
        if let searchKeywords = self.searchKeywords {
            var searchKeywordsPredicates = [NSPredicate]()
//            if self.isQuickSearch {
//                let searchString = searchKeywords.joinWithSeparator(" ")
//                if !searchString.characters.isEmpty {
//                    searchKeywordsPredicates.append(FmtPredicate("title BEGINSWITH[cd] %@", searchString))
//                }
//            } else {
                for searchKeyword in searchKeywords {
                    if !searchKeyword.characters.isEmpty {
                        searchKeywordsPredicates.append(FmtPredicate("appSearchText CONTAINS[cd] %@", searchKeyword))
                    }
                }
//            }
            if !searchKeywordsPredicates.isEmpty {
                predicates.append(CompoundAndPredicate(searchKeywordsPredicates))
            }
        }

        let fetchedResultsController = Product.MR_fetchAllGroupedBy(nil,
                                                                    withPredicate: CompoundAndPredicate(predicates),
                                                                    sortedBy: nil,//"order",
                                                                    ascending: true)
        fetchedResultsController.fetchRequest.fetchBatchSize = 16
        return fetchedResultsController
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
        self.reloadData(nil)
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
extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
            // TODO: Improve favorites
//            cell.isFavorite = product.isFavorite()
            cell.fgImageView.image = nil
            
            if let images = product.images as? NSArray,
                imageURLString = images.firstObject as? String,
                imageURL = NSURL(string: imageURLString) {
                    cell.fgImageView?.sd_setImageWithURL(imageURL,
                        placeholderImage: UIImage(named: "img_placeholder_1_1_m"),
                        options: [.ContinueInBackground, .AllowInvalidSSLCertificates],
                        completed: { (image: UIImage!, error: NSError!, type: SDImageCacheType, url: NSURL!) -> Void in
                            // Update cell size if it's not scrolling
                            if (image != nil &&
                                !self.collectionView().dragging &&
                                !self.collectionView().decelerating &&
                                self.collectionView().indexPathsForVisibleItems().contains(indexPath)) {
                                self.collectionView().reloadItemsAtIndexPaths([indexPath])
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

// MARK: - UIScrollViewDelegate
// Update cell size
// TODO: Update favorites
extension ProductsViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.collectionView().reloadItemsAtIndexPaths(self.collectionView().indexPathsForVisibleItems())
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.collectionView().reloadItemsAtIndexPaths(self.collectionView().indexPathsForVisibleItems())
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
        
        if let product = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? Product,
            images = product.images as? NSArray,
            imageURLString = images.firstObject as? String,
            imageURL = NSURL(string: imageURLString) {
            let cacheKey = SDWebImageManager.sharedManager().cacheKeyForURL(imageURL)
            let image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(cacheKey)
            if image != nil {
                let cellHeight = self.cellWidth * image.size.height / image.size.width + bottomMargin
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
    
    override func reloadData(completion: (() -> Void)?) {
        // Show indicator
        self.showLoadingIndicator()
        
        // Reload Data
        super.reloadData() {
            // Original completion
            if let completion = completion { completion() }
            
            // After searching is completed
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
            if self.searchKeywords != nil {
                self.showNoDataIndicator()
            }
        }
    }
    
    func reloadDataWithIndicators() {
        self.reloadData(nil)
    }
}

// MARK: UISearchResultsUpdating
extension ProductsViewController: UISearchResultsUpdating {
    
    func showNoDataIndicator() {
        _loadingIndicator.text = NSLocalizedString("products_vc_no_data")
        self.isLoadingIndicatorVisible = true
    }
    
    func showLoadingIndicator() {
        _loadingIndicator.text = NSLocalizedString("products_vc_loading")
        self.isLoadingIndicatorVisible = true
    }
    
    func startSearchTimer() {
        stopSearchTimer()
        self.searchTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(ProductsViewController.reloadDataWithIndicators), userInfo: nil, repeats: false)
    }
    
    func stopSearchTimer() {
        self.searchTimer?.invalidate()
        self.searchTimer = nil
    }
    
    func searchKeywords(keyWords: [String]?) {
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.stopSearchTimer()
        
        var newSearchKeywords: [String]?
        if searchController.active {
//            self.isQuickSearch = false
            newSearchKeywords = self.getSearchKeywords(searchController.searchBar.text)
        } else {
            newSearchKeywords = nil
        }
        
        let oldSearchKeywords = self.searchKeywords
        self.searchKeywords = newSearchKeywords
        
        if newSearchKeywords == nil && oldSearchKeywords == nil {
            // Same, no need to search
            return
        } else if let newSearchKeywords = newSearchKeywords, oldSearchKeywords = oldSearchKeywords {
            if newSearchKeywords == oldSearchKeywords {
                // Same, no need to search
                return
            }
        }
        
        // Ready to search
        self.showLoadingIndicator()
        
        if newSearchKeywords == nil {
            self.reloadData(nil)
        } else {
            self.startSearchTimer()
        }
    }
}

// MARK: - UISearchBarDelegate
extension ProductsViewController: UISearchBarDelegate {
    
    func getSearchKeywords(searchText: String?) -> [String]? {
        if let searchText = searchText {
            let searchKeywords = searchText.characters.split() { $0 == " " }.flatMap() { String($0) }
            return searchKeywords.map({Product.normalizedSearchText($0).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())})
        } else {
            return nil
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
//        self.isQuickSearch = true
        self.searchKeywords = self.getSearchKeywords(searchBar.text)
        self.reloadData(nil)
    }
}

// MARK: - SearchControler
extension ProductsViewController: UISearchControllerDelegate {
    
    func setupRightBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: #selector(ProductsViewController.showSearchController))
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
