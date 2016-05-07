//
//  ProductsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class ProductsViewController: AsyncedFetchedResultsViewController {
    
    // Override AsyncedFetchedResultsViewController
    @IBOutlet private var _collectionView: UICollectionView!
    
    @IBOutlet private var _swipeUpIndicator: UIView!
    @IBOutlet private var _swipeUpIndicatorBottomConstraint: NSLayoutConstraint!
    private var _swipeUpIndicatorIsVisible = true
    
    @IBOutlet private var _loadingView: UIView!
    @IBOutlet private var _loadingViewLabel: UILabel!
    var isLoadingViewVisible: Bool = true {
        didSet {
            self._loadingView.hidden = !isLoadingViewVisible
            self.collectionView().mj_footer.hidden = isLoadingViewVisible
        }
    }
    
    // Used for searchFinished method, to know if 2 searches are both finished
    var lastFinishedSearchOffset: Int?
    
    var searchController: UISearchController?
    
    var isSearchResultsViewController: Bool = false
    var searchKeywords: [String]?
    weak var searchFromViewController: UIViewController?
    
    let bottomMargin: CGFloat = 53.0 // Height of 3 Labels + inner margins
    let cellMargin: CGFloat = 4.0 // Cell outer margins
    var cellWidth: CGFloat = 0
    var lastCellSize = CGSize(width: 1, height: 1)
    
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
    
    deinit {
        // Stop observing data updating
        NSNotificationCenter.defaultCenter().removeObserver(self, name: Cons.DB.productsUpdatingDidFinishNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.categoryName
        
        // Setups
        self.setupCollectionView()
        self.setupLoadMoreControl()
        
        // If it's not another VC's search results VC, setup its search controller
        if !self.isSearchResultsViewController {
            // Setup Search Controller
            self.setupSearchController()
        } else {
            self.showTapSearch()
        }
        
        // Pre-calculate cell width
        self.cellWidth = (self.view.frame.width - cellMargin * 3) / 2.0
        
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
        
        // Setup swipe up indicator
        _swipeUpIndicatorBottomConstraint.constant = self.collectionView().contentInset.bottom
        // Reset swipe up indicator
        self.hideSwipeUpIndicator()
        
        // Observe data updating
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ProductsViewController.reloadDataWithoutCompletion), name: Cons.DB.productsUpdatingDidFinishNotification, object: nil)
        
        // Load data
        if !self.isSearchResultsViewController {
            self.reloadData(nil)
        }
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
        self.reloadVisibleCells()
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

// MARK: AsyncedFetchedResultsViewController
extension ProductsViewController {
    
    override func collectionView() -> UICollectionView {
        return _collectionView
    }
    
    override func createFetchRequest(context: NSManagedObjectContext) -> NSFetchRequest? {
        // If it's search results view controller
        // If search keywords is empty
        if (self.isSearchResultsViewController && self.searchKeywordsIsEmpty()) {
            return nil
        }
        
        // Prepare predicates
        var predicates = [NSPredicate]()
        if let brandId = self.brandID {
            predicates.append(FmtPredicate("brandId == %@", brandId))
        }
        if let categoryID = self.categoryID {
            predicates.append(FmtPredicate("categories CONTAINS %@", FmtString("|%@|",categoryID)))
        }
        if let searchKeywords = self.searchKeywords {
            var searchKeywordsPredicates = [NSPredicate]()
            for searchKeyword in searchKeywords {
                if !searchKeyword.characters.isEmpty {
                    searchKeywordsPredicates.append(FmtPredicate("appSearchText CONTAINS[cd] %@", searchKeyword))
                }
            }
            if !searchKeywordsPredicates.isEmpty {
                predicates.append(CompoundAndPredicate(searchKeywordsPredicates))
            }
        }
        
        // Create fetch request
        let request = Product.MR_requestAllSortedBy(
            "order,id",
            ascending: true,
            withPredicate: CompoundAndPredicate(predicates),
            inContext: context)
        
        // Setup fetch request
        self.fetchLimit = Cons.App.productsPageSize
        
        return request
    }
}

// MARK: ProductViewControllerDelegate
extension ProductsViewController: ProductViewControllerDelegate {
    
    func getNextProduct(currentIndex: Int?) -> (Int?, Product?)? {
        guard let fetchedResults = self.fetchedResults else { return nil }
        
        var currentProductIndex = -1
        if let currentIndex = currentIndex {
            currentProductIndex = currentIndex
        }
        
        let nextProductIndex = currentProductIndex + 1
        if nextProductIndex < fetchedResults.count {
            let product = fetchedResults[nextProductIndex] as? Product
            return (nextProductIndex, product)
        }
        
        return nil
    }
    
    func didShowNextProduct(product: Product, index: Int) {
        self.collectionView().scrollToItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0), atScrollPosition: .Top, animated: false)
        self.selectedIndexPath = NSIndexPath(forRow: index, inSection: 0)
    }
}

// MARK: CollectionView Delegate Methods
extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return (self.fetchedResults != nil) ? 1 : 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchedResults?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCellWithReuseIdentifier("ProductsCollectionViewCell", forIndexPath: indexPath) as? ProductsCollectionViewCell)!
        
        if let product = self.fetchedResults?[indexPath.row] as? Product {
            cell.lblTitle?.text = product.title
            cell.lblBrand?.text = product.brandLabel
            cell.lblPrice?.text = CurrencyManager.shared.cheapestFormattedPriceInUserCurrency(product.prices)
            cell.isFavorite = product.isFavorite()
            cell.fgImageView.image = nil
            
            if let images = product.images as? NSArray,
                imageURLString = images.firstObject as? String,
                imageURL = NSURL(string: imageURLString) {
                let countBeforeUpdating = self.fetchedResults?.count
                if let imageView = cell.fgImageView {
                    imageView.sd_setImageWithURL(imageURL,
                                                 placeholderImage: UIImage(named: "img_placeholder_1_1_m"),
                                                 options: [.ContinueInBackground, .AllowInvalidSSLCertificates],
                                                 completed: { (image: UIImage!, error: NSError!, type: SDImageCacheType, url: NSURL!) -> Void in
                                                    // Update image if it's still visible
                                                    if (image != nil && self.collectionView().indexPathsForVisibleItems().contains(indexPath)) {
                                                        // Update the image with an animation
                                                        UIView.transitionWithView(imageView,
                                                            duration: 0.3,
                                                            options: UIViewAnimationOptions.TransitionCrossDissolve,
                                                            animations: { imageView.image = image },
                                                            completion: nil)
                                                        
                                                        // If image ratio is different, reload the cell to update layout
                                                        let imageViewRatio = imageView.frame.height / imageView.frame.width
                                                        let imageRatio = image.size.height / image.size.width
                                                        if (abs(imageViewRatio - imageRatio) > 0.01 && self.fetchedResults?.count == countBeforeUpdating) {
                                                            self.collectionView().reloadItemsAtIndexPaths([indexPath])
                                                        }
                                                    }
                    })
                }
            } else {
                DLog(FmtString("Product ID = %@, images: %@",product.id ?? "?",product.images ?? "?"))
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndexPath = indexPath
        
        guard let product = self.fetchedResults?[indexPath.row] as? Product else {
            return
        }
            
        let productViewController = ProductViewController.instantiate()
        productViewController.delegate = self
        productViewController.product = product
        productViewController.productIndex = indexPath.row
        
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

// MARK: UIScrollViewDelegate
extension ProductsViewController {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // If it's the end of the scroll view
        if scrollView.contentOffset.y >= scrollView.contentSize.height - (scrollView.bounds.height - scrollView.contentInset.bottom) {
            self.showSwipeUpIndicator()
        }
    }
}

// MARK: Show / Hide swipe up indicator
extension ProductsViewController {
    
    func showSwipeUpIndicator() {
        // If indicator invisible
        if (!_swipeUpIndicatorIsVisible &&
            // If it isn't "no more data" status
            self.collectionView().mj_footer.state != .NoMoreData) {
            _swipeUpIndicatorIsVisible = true
            self._swipeUpIndicator.alpha = 0
            self._swipeUpIndicator.hidden = false
            UIView.animateWithDuration(0.3, animations: {
                self._swipeUpIndicator.alpha = 1
                self._swipeUpIndicatorBottomConstraint.constant = self.collectionView().contentInset.bottom
                self._swipeUpIndicator.setNeedsLayout()
                self._swipeUpIndicator.layoutIfNeeded()
                }, completion: { (_) in
                    DispatchAfter(0.5, closure: {
                        self.hideSwipeUpIndicator()
                    })
            })
        }
    }
    
    func hideSwipeUpIndicator() {
        if self._swipeUpIndicatorIsVisible {
            UIView.animateWithDuration(0.3, animations: {
                self._swipeUpIndicator.alpha = 0
                self._swipeUpIndicatorBottomConstraint.constant = self.collectionView().contentInset.bottom - 32
                self._swipeUpIndicator.setNeedsLayout()
                self._swipeUpIndicator.layoutIfNeeded()
                }, completion: { (_) in
                    self._swipeUpIndicator.hidden = true
                    self._swipeUpIndicatorIsVisible = false
            })
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

// MARK: CollectionView Waterfall Layout
extension ProductsViewController: CHTCollectionViewDelegateWaterfallLayout {
    
    func setupCollectionView() {
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        
        // Change individual layout attributes for the spacing between cells
        layout.itemRenderDirection = .LeftToRight
        layout.minimumColumnSpacing = cellMargin
        layout.minimumInteritemSpacing = cellMargin
        layout.sectionInset = UIEdgeInsets(top: cellMargin, left: cellMargin, bottom: cellMargin, right: cellMargin)
        
        // Add the waterfall layout to your collection view
        self.collectionView().collectionViewLayout = layout
        
        (self.collectionView().collectionViewLayout as? CHTCollectionViewWaterfallLayout)?.columnCount = 2
        
        // Collection view attributes
        self.collectionView().autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        self.collectionView().alwaysBounceVertical = true
    }
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAtIndexPath indexPath: NSIndexPath!) -> CGSize {
        var size = self.lastCellSize // Default size for product
        
        if let product = self.fetchedResults?[indexPath.row] as? Product,
            images = product.images as? NSArray,
            imageURLString = images.firstObject as? String,
            imageURL = NSURL(string: imageURLString) {
            let cacheKey = SDWebImageManager.sharedManager().cacheKeyForURL(imageURL)
            let image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(cacheKey)
            if image != nil {
                let cellHeight = self.cellWidth * image.size.height / image.size.width + bottomMargin
                size = CGSize(width: self.cellWidth, height: cellHeight)
                self.lastCellSize = size
            }
        }
        return size
    }
}

// MARK: Pull to load more
extension ProductsViewController {
    
    func setupLoadMoreControl() {        
        let footer = MJRefreshBackNormalFooter(refreshingBlock: { () -> Void in
            self.loadMore({ offset, resultCount in
                self.endRefreshing(resultCount)
            })
            self.beginRefreshing()
        })
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_idle"), forState: .Idle)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_pulling"), forState: .Pulling)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_refreshing"), forState: .Refreshing)
        footer.setTitle(NSLocalizedString("pull_to_refresh_no_more_data"), forState: .NoMoreData)
        footer.automaticallyHidden = true
        self.collectionView().mj_footer = footer
    }
    
    func beginRefreshing() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func endRefreshing(resultCount: Int) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if resultCount > 0 {
                self.collectionView().mj_footer.endRefreshing()
            } else {
                self.collectionView().mj_footer.endRefreshingWithNoMoreData()
            }
        })
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func resetNoMoreDataStatus() {
        self.collectionView().mj_footer.resetNoMoreData()
    }
}

// MARK: Actions
extension ProductsViewController {
    
    @IBAction func favProduct(sender: UIButton) {
        let position = sender.convertPoint(CGPoint.zero, toView: self.collectionView())
        guard let indexPath = self.collectionView().indexPathForItemAtPoint(position) else { return }
        UserManager.shared.loginOrDo() { () -> () in
            if let product = self.fetchedResults?[indexPath.row] as? Product {
                product.toggleFavorite({ (data: AnyObject?) -> () in
                    self.collectionView().reloadItemsAtIndexPaths([indexPath])
                })
            }
        }
    }
}

// MARK: FetchedResultsController
extension ProductsViewController {
    
    func searchFinished(offset: Int, _ resultCount: Int, _ completion: ((Int, Int) -> Void)?) {
        // New search, reset no more data status
        self.resetNoMoreDataStatus()
        // Scrolls to top
        self.collectionView().setContentOffset(CGPoint(x: 0, y: -self.collectionView().contentInset.top), animated: false)
        
        // Original completion
        if let completion = completion { completion(offset, resultCount) }
        
        // After searching is completed, if there are results, hide the indicator
        if self.fetchedResults?.count ?? 0 > 0 {
            self.isLoadingViewVisible = false
        } else {
            // If one of the searches has 0 result, the other one will continue the search
            // So we have to check if it's the 1st result or the 2nd
            // If it's the 1st, keep displaying "Loading", if it's the 2nd, display "No Data"
            if self.lastFinishedSearchOffset == nil {
                self.lastFinishedSearchOffset = offset
            } else {
                self.lastFinishedSearchOffset = nil
                // If it's not searching but there's no data, it means data isn't ready
                if !self.searchKeywordsIsEmpty() {
                    self.showNoDataIndicator()
                }
            }
        }
    }
    
    private func queryServer(completion: ((Int, Int) -> Void)?) {
        // The offset for current fetch
        let offset = self.fetchOffset
        // Delete all old memory objects before a new search
        if offset == 0 {
            DataManager.shared.memoryContext().runBlockAndWait({ (localContext) in
                Product.MR_deleteAllMatchingPredicate(FmtPredicate("1==1"), inContext: localContext)
            })
        }
        
        // Query parameters
        let queryString = self.searchKeywords?.joinWithSeparator(" ")
        let brandID = self.brandID
        let categoryID = self.categoryID
        let pageIndex = self.fetchLimit != 0 ? offset/self.fetchLimit : 0
        
        DataManager.shared.searchProducts(queryString, brandID, categoryID, pageIndex) { (responseObject, error) in
            if !self.hasAppendedFetchedResultsForOffset(offset) {
                if let results = responseObject as? [Product] {
                    self.appendFetchedResults(results)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        // Reload UI
                        self.reloadUI()
                        // Completed
                        if let completion = completion { completion(offset, results.count ?? 0) }
                    })
                }
            }
        }
    }
    
    // Load data from server and local, we use the one who comes first
    override func reloadData(completion: ((Int, Int) -> Void)?) {
        // If the results were not empty
        if self.fetchedResults?.count ?? 0 > 0 {
            // Stop image caching, as all the cells are reloaded, the old completion block will reload non-existing cells
            SDWebImageManager.sharedManager().cancelAll()
        }
        // Show indicator
        if self.isSearchResultsViewController && self.searchKeywordsIsEmpty() {
            self.showTapSearch()
        } else {
            self.showLoadingIndicator()
        }
        
        // Search Products locally
        super.reloadData() { offset, resultCount in
            self.searchFinished(offset, resultCount, completion)
        }
        // Search products remotely on server
        self.queryServer() { offset, resultCount in
            self.searchFinished(offset, resultCount, completion)
        }
    }
    
    // Load data from server and local, we use the one who comes first
    override func loadMore(completion: ((Int, Int) -> Void)?) {
        // Search Products locally
        super.loadMore(completion)
        // Search products remotely on server
        self.queryServer(completion)
    }
}

// MARK: UISearchResultsUpdating
extension ProductsViewController: UISearchResultsUpdating {
    
    func searchKeywordsIsEmpty() -> Bool {
        return (self.searchKeywords == nil ||
            self.searchKeywords!.isEmpty ||
            (self.searchKeywords!.count == 1 && self.searchKeywords!.first == ""))
    }
    
    func showTapSearch() {
        _loadingViewLabel.text = NSLocalizedString("products_vc_tap_search")
        self.isLoadingViewVisible = true
    }
    
    func showNoDataIndicator() {
        _loadingViewLabel.text = NSLocalizedString("products_vc_no_data")
        self.isLoadingViewVisible = true
    }
    
    func showLoadingIndicator() {
        _loadingViewLabel.text = NSLocalizedString("products_vc_loading")
        self.isLoadingViewVisible = true
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        // Avoid hiding the searchResultsController if search text field is empty
        if self.fetchedResults?.count ?? 0 > 0 {
            searchController.searchResultsController?.view.hidden = false
        }
        
        var newSearchKeywords: [String]?
        if searchController.active {
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
        
        if newSearchKeywords == nil {
            self.reloadData(nil)
        }
    }
}

// MARK: UISearchBarDelegate
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
        self.searchKeywords = self.getSearchKeywords(searchBar.text)
        self.reloadData(nil)
    }
}

// MARK: SearchControler
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

// MARK: Routines
extension ProductsViewController {
    
    func reloadVisibleCells() {
        // If it isSearchResultsViewController == false
        // If it isSearchResultsViewController == true && search keywords isn't empty
        if (!self.isSearchResultsViewController || !self.searchKeywordsIsEmpty()) {
            self.collectionView().reloadItemsAtIndexPaths(self.collectionView().indexPathsForVisibleItems())
        }
    }
}

// MARK: Custom cells
class ProductsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var fgImageView: UIImageView!
    @IBOutlet var lblBrand: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var btnFav: UIButton!
    
    var isFavorite: Bool? {
        didSet {
            if UserManager.shared.isLoggedIn {
                self.updateFavoriteButton(isFavorite != nil && isFavorite!.boolValue)
            } else {
                isFavorite = false
            }
        }
    }
    
    func updateFavoriteButton(isFavorite: Bool) {
        self.btnFav.setImage(UIImage(named: isFavorite ? "img_heart_shadow_selected" : "img_heart_shadow"), forState: UIControlState.Normal)
    }
}
