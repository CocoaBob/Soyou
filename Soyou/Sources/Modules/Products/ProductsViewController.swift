//
//  ProductsViewController.swift
//  Soyou
//
//  Created by CocoaBob on 23/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class ProductsViewController: AsyncedFetchedResultsViewController {
    
    // Override AsyncedFetchedResultsViewController
    @IBOutlet fileprivate var _collectionView: UICollectionView!
    
    @IBOutlet fileprivate var _swipeUpIndicator: UIView!
    @IBOutlet fileprivate var _swipeUpIndicatorBottomConstraint: NSLayoutConstraint!
    fileprivate var _swipeUpIndicatorIsVisible = true
    
    @IBOutlet fileprivate var _loadingView: UIView!
    @IBOutlet fileprivate var _loadingViewLabel: UILabel!
    var isLoadingViewVisible: Bool = true {
        didSet {
            self._loadingView.isHidden = !isLoadingViewVisible
            self.collectionView().mj_footer.isHidden = isLoadingViewVisible
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
    var selectedIndexPath: IndexPath?
    
    var categoryName: String?
    var categoryID: Int?
    var brandID: Int?
    
    // Class methods
    class func instantiate() -> ProductsViewController {
        return UIStoryboard(name: "ProductsViewController", bundle: nil).instantiateViewController(withIdentifier: "ProductsViewController") as! ProductsViewController
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
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Cons.DB.productsUpdatingDidFinishNotification), object: nil)
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
            self.showTapToSearchMessage()
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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ProductsViewController.reloadDataWithoutCompletion),
                                               name: NSNotification.Name(rawValue: Cons.DB.productsUpdatingDidFinishNotification),
                                               object: nil)
        
        // Prepare FetchedResultsController
        if !self.isSearchResultsViewController {
            self.reloadData(nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        
        // Hide toolbar. No animation because it might need to be shown immediately
        self.hideToolbar(false)
        
        // For navigation bar search bar
        self.definesPresentationContext = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Reload in case if appIsFavorite is changed
        self.reloadVisibleCells()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
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
    
    override func createFetchRequest(_ context: NSManagedObjectContext) -> NSFetchRequest<NSFetchRequestResult>? {
        // If it's search results view controller
        // If search keywords is empty
        if (self.isSearchResultsViewController && self.searchKeywordsIsEmpty()) {
            return nil
        }
        
        // Prepare predicates
        var predicates = [NSPredicate]()
        if let brandId = self.brandID as NSNumber? {
            predicates.append(FmtPredicate("brandId == %@", brandId))
        }
        if let categoryID = self.categoryID as NSNumber? {
            predicates.append(FmtPredicate("categories CONTAINS %@", FmtString("|%@|",categoryID)))
        }
        if let searchKeywords = self.searchKeywords {
            var searchKeywordsPredicates = [NSPredicate]()
            for searchKeyword in searchKeywords {
                if !searchKeyword.isEmpty {
                    searchKeywordsPredicates.append(FmtPredicate("appSearchText CONTAINS[cd] %@", searchKeyword))
                }
            }
            if !searchKeywordsPredicates.isEmpty {
                predicates.append(CompoundAndPredicate(searchKeywordsPredicates))
            }
        }
        
        // Create fetch request
        let request = Product.mr_requestAllSorted(by: "order,id",
                                                  ascending: true,
                                                  with: CompoundAndPredicate(predicates),
                                                  in: context)
        
        // Setup fetch request
        self.fetchLimit = Cons.App.productsPageSize
        
        return request
    }
}

// MARK: CollectionView Delegate Methods
extension ProductsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (self.fetchedResults != nil) ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchedResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "ProductsCollectionViewCell", for: indexPath) as? ProductsCollectionViewCell)!
        
        if let product = self.fetchedResults?[indexPath.row] as? Product {
            cell.lblTitle?.text = product.title
            cell.lblBrand?.text = product.brandLabel
            cell.lblPrice?.text = CurrencyManager.shared.cheapestFormattedPriceInUserCurrency(product.prices)
            cell.isFavorite = product.isFavorite()
            cell.fgImageView.image = nil
            
            if let images = product.images as? NSArray,
                let imageURLString = images.firstObject as? String,
                let imageURL = URL(string: imageURLString) {
                let countBeforeUpdating = self.fetchedResults?.count
                if let imageView = cell.fgImageView {
                    imageView.sd_setImage(with: imageURL,
                                          placeholderImage: UIImage(named: "img_placeholder_1_1_m"),
                                          options: [.continueInBackground, .allowInvalidSSLCertificates],
                                          completed: { (image, error, type, url) -> Void in
                                            // Update image if it's still visible
                                            if (self.collectionView().indexPathsForVisibleItems.contains(indexPath)) {
                                                if let image = image {
                                                    // Update the image with an animation
                                                    UIView.transition(with: imageView,
                                                                      duration: 0.3,
                                                                      options: UIViewAnimationOptions.transitionCrossDissolve,
                                                                      animations: { imageView.image = image },
                                                                      completion: nil)
                                                    
                                                    // If image ratio is different, reload the cell to update layout
                                                    let imageViewRatio = imageView.frame.height / imageView.frame.width
                                                    let imageRatio = image.size.height / image.size.width
                                                    if (abs(imageViewRatio - imageRatio) > 0.01 && self.fetchedResults?.count == countBeforeUpdating) {
                                                        self.collectionView().collectionViewLayout.invalidateLayout()
                                                    }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        
        guard let product = self.fetchedResults?[indexPath.row] as? Product else {
            return
        }
            
        let productViewController = ProductViewController.instantiate()
        productViewController.product = product
        
        if let cell = self.collectionView().cellForItem(at: indexPath) as? ProductsCollectionViewCell,
            let imageView = cell.fgImageView,
            let image = imageView.image {
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
            self.collectionView().mj_footer.state != .noMoreData) {
            _swipeUpIndicatorIsVisible = true
            self._swipeUpIndicator.alpha = 0
            self._swipeUpIndicator.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
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
            UIView.animate(withDuration: 0.3, animations: {
                self._swipeUpIndicator.alpha = 0
                self._swipeUpIndicatorBottomConstraint.constant = self.collectionView().contentInset.bottom - (UIDevice.isX() ? 56 : 32)
                self._swipeUpIndicator.setNeedsLayout()
                self._swipeUpIndicator.layoutIfNeeded()
            }, completion: { (_) in
                self._swipeUpIndicator.isHidden = true
                self._swipeUpIndicatorIsVisible = false
            })
        }
    }
}

// MARK: ZoomInteractiveTransition
extension ProductsViewController: ZoomTransitionProtocol {
    
    fileprivate func imageViewForZoomTransition() -> UIImageView? {
        if let indexPath = self.selectedIndexPath,
            let cell = self.collectionView().cellForItem(at: indexPath) as? ProductsCollectionViewCell,
            let imageView = cell.fgImageView {
                return imageView
        }
        return nil
    }
    
    func view(forZoomTransition isSource: Bool) -> UIView? {
        return self.imageViewForZoomTransition()
    }
    
    func initialZoomViewSnapshot(fromProposedSnapshot snapshot: UIImageView!) -> UIImageView? {
        if let imageView = self.imageViewForZoomTransition() {
            let returnImageView = UIImageView(image: imageView.image)
            returnImageView.contentMode = .scaleAspectFit
            returnImageView.clipsToBounds = true
            return returnImageView
        }
        return nil
    }
    
    func shouldAllowZoomTransition(for operation: UINavigationControllerOperation, from fromVC: UIViewController!, to toVC: UIViewController!) -> Bool {
        if self.isSearchResultsViewController || self.presentedViewController is UISearchController {
            return false
        }
        // Only available for opening a product from products view controller
        if ((operation == .push && fromVC === self && toVC is ProductViewController) ||
            (operation == .pop && fromVC is ProductViewController && toVC === self)) {
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
        layout.itemRenderDirection = .leftToRight
        layout.minimumColumnSpacing = cellMargin
        layout.minimumInteritemSpacing = cellMargin
        layout.sectionInset = UIEdgeInsets(top: cellMargin, left: cellMargin, bottom: cellMargin, right: cellMargin)
        
        // Add the waterfall layout to your collection view
        self.collectionView().collectionViewLayout = layout
        
        (self.collectionView().collectionViewLayout as? CHTCollectionViewWaterfallLayout)?.columnCount = 2
        
        // Collection view attributes
        self.collectionView().autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
        self.collectionView().alwaysBounceVertical = true
    }
    
    //** Size for the cells in the Waterfall Layout */
    func collectionView(_ collectionView: UICollectionView!, layout collectionViewLayout: UICollectionViewLayout!, sizeForItemAt indexPath: IndexPath!) -> CGSize {
        var size = self.lastCellSize // Default size for product
        
        if let product = self.fetchedResults?[indexPath.row] as? Product,
            let images = product.images as? NSArray,
            let imageURLString = images.firstObject as? String,
            let imageURL = URL(string: imageURLString),
            let image = SDImageCache.shared().imageFromCache(forKey: SDWebImageManager.shared().cacheKey(for: imageURL)) {
            let cellHeight = self.cellWidth * image.size.height / image.size.width + bottomMargin
            size = CGSize(width: self.cellWidth, height: cellHeight)
            self.lastCellSize = size
        }
        return size
    }
}

// MARK: Pull to load more
extension ProductsViewController {
    
    func setupLoadMoreControl() {        
        guard let footer = MJRefreshAutoStateFooter(refreshingBlock: { () -> Void in
            self.loadMore({ offset, resultCount in
                self.endRefreshing(resultCount)
            })
            self.beginRefreshing()
        }) else { return }
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_idle"), for: .idle)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_pulling"), for: .pulling)
        footer.setTitle(NSLocalizedString("pull_to_refresh_footer_refreshing"), for: .refreshing)
        footer.setTitle(NSLocalizedString("pull_to_refresh_no_more_data"), for: .noMoreData)
        self.collectionView().mj_footer = footer
    }
    
    func beginRefreshing() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func endRefreshing(_ resultCount: Int) {
        DispatchQueue.main.async {
            if resultCount > 0 {
                self.collectionView().mj_footer.endRefreshing()
            } else {
                self.collectionView().mj_footer.endRefreshingWithNoMoreData()
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func resetNoMoreDataStatus() {
        self.collectionView().mj_footer.resetNoMoreData()
    }
}

// MARK: Actions
extension ProductsViewController {
    
    @IBAction func favProduct(_ sender: UIButton) {
        let position = sender.convert(CGPoint.zero, to: self.collectionView())
        guard let indexPath = self.collectionView().indexPathForItem(at: position) else { return }
        UserManager.shared.loginOrDo() { () -> () in
            if let product = self.fetchedResults?[indexPath.row] as? Product {
                product.toggleFavorite({ (data: Any?) -> () in
                    self.collectionView().reloadItems(at: [indexPath])
                })
            }
        }
    }
}

// MARK: FetchedResultsController
extension ProductsViewController {
    
    func searchFinished(_ offset: Int, _ resultCount: Int, _ completion: ((Int, Int) -> Void)?) {
        // New search, reset no more data status
        self.resetNoMoreDataStatus()
        // Scrolls to top
        self.collectionView().setContentOffset(CGPoint(x: 0, y: -self.collectionView().contentInset.top), animated: false)
        
        // Original completion
        completion?(offset, resultCount)
        
        // After searching is completed, if there are results, hide the indicator
        if self.fetchedResults?.count ?? 0 > 0 {
            self.isLoadingViewVisible = false
        } else {
            // If one of the searches has 0 result, the other one will continue the search
            // So we have to check if it's the 1st result or the 2nd
            // If it's the 1st, keep displaying "Loading", if it's the 2nd, display "No Data"
            if self.lastFinishedSearchOffset == nil || self.lastFinishedSearchOffset != offset {
                self.lastFinishedSearchOffset = offset
            } else {
                self.lastFinishedSearchOffset = nil
                // If it's not searching but there's no data, it means data isn't ready
                if !self.searchKeywordsIsEmpty() {
                    self.showNoDataMessage()
                }
            }
        }
    }
    
    fileprivate func queryServer(_ completion: ((Int, Int) -> Void)?) {
        // The offset for current fetch
        let offset = self.fetchOffset
        // Delete all old memory objects before a new search
        if offset == 0 {
            DataManager.shared.memoryContext().runBlockAndWait({ (localContext) in
                Product.mr_deleteAll(matching: FmtPredicate("1==1"), in: localContext)
            })
        }
        
        // Query parameters
        let queryString = self.searchKeywords?.joined(separator: " ")
        let brandID = self.brandID
        let categoryID = self.categoryID
        let pageIndex = self.fetchLimit != 0 ? offset/self.fetchLimit : 0
        
        DataManager.shared.searchProducts(queryString, brandID, categoryID, pageIndex) { (responseObject, error) in
            if !self.hasAppendedFetchedResultsForOffset(offset) {
                if let results = responseObject as? [Product] {
                    self.appendFetchedResults(results)
                    DispatchQueue.main.async {
                        // Reload UI
                        self.reloadUI()
                        // Completed
                        completion?(offset, results.count)
                    }
                }
            }
        }
    }
    
    // Load data from server and local, we use the one who comes first
    override func reloadData(_ completion: ((Int, Int) -> Void)?) {
        // If the results were not empty
        if self.fetchedResults?.count ?? 0 > 0 {
            // Stop image caching, as all the cells are reloaded, the old completion block will reload non-existing cells
            SDWebImageManager.shared().cancelAll()
        }
        // Show indicator
        if self.isSearchResultsViewController && self.searchKeywordsIsEmpty() {
            self.showTapToSearchMessage()
        } else {
            self.showLoadingMessage()
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
    override func loadMore(_ completion: ((Int, Int) -> Void)?) {
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
    
    func showTapToSearchMessage() {
        _loadingViewLabel.text = NSLocalizedString("products_vc_tap_search")
        self.isLoadingViewVisible = true
    }
    
    func showNoDataMessage() {
        _loadingViewLabel.text = NSLocalizedString("products_vc_no_data")
        self.isLoadingViewVisible = true
    }
    
    func showLoadingMessage() {
        _loadingViewLabel.text = NSLocalizedString("products_vc_loading")
        self.isLoadingViewVisible = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // Avoid hiding the searchResultsController if search text field is empty
        if self.fetchedResults?.count ?? 0 > 0 {
            searchController.searchResultsController?.view.isHidden = false
        }
        
        var newSearchKeywords: [String]?
        if searchController.isActive {
            newSearchKeywords = self.getSearchKeywords(searchController.searchBar.text)
        } else {
            newSearchKeywords = nil
        }
        
        let oldSearchKeywords = self.searchKeywords
        self.searchKeywords = newSearchKeywords
        
        if newSearchKeywords == nil && oldSearchKeywords == nil {
            // Same, no need to search
            return
        } else if let newSearchKeywords = newSearchKeywords, let oldSearchKeywords = oldSearchKeywords {
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
    
    func getSearchKeywords(_ searchText: String?) -> [String]? {
        if let searchText = searchText {
            let searchKeywords = searchText.components(separatedBy: " ")
            return searchKeywords.map({Product.normalizedSearchText($0).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)})
        } else {
            return nil
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchKeywords = self.getSearchKeywords(searchBar.text)
        self.reloadData(nil)
    }
}

// MARK: SearchControler
extension ProductsViewController: UISearchControllerDelegate {
    
    func setupRightBarButtonItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(ProductsViewController.showSearchController))
    }
    
    @objc func showSearchController() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.setRightBarButton(nil, animated: false)
        let searchBar = self.searchController!.searchBar
        if #available(iOS 11.0, *) {
            let searchBarContainer = SearchBarContainerView(searchBar: searchBar)
            searchBarContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
            self.navigationItem.titleView = searchBarContainer
        } else {
            self.navigationItem.titleView = searchBar
        }
        self.searchController!.searchBar.becomeFirstResponder()
    }
    
    func hideSearchController() {
        self.setupRightBarButtonItem()
        self.navigationItem.titleView = nil
    }
    
    func setupSearchController() {
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
        self.searchController!.searchBar.showsCancelButton = false
        self.searchController!.hidesNavigationBarDuringPresentation = false
        
        self.setupRightBarButtonItem()
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
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
            self.collectionView().reloadItems(at: self.collectionView().indexPathsForVisibleItems)
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
                self.updateFavoriteButton(isFavorite != nil && isFavorite!)
            } else {
                isFavorite = false
            }
        }
    }
    
    func updateFavoriteButton(_ isFavorite: Bool) {
        self.btnFav.setImage(UIImage(named: isFavorite ? "img_heart_shadow_selected" : "img_heart_shadow"), for: UIControlState.normal)
    }
}
