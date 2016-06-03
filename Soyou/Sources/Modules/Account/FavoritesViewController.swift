//
//  FavoritesViewController.swift
//  Soyou
//
//  Created by CocoaBob on 19/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

enum FavoriteType: Int {
    case News
    case Products
}

class FavoritesViewController: SyncedFetchedResultsViewController {
    
    // Override SyncedFetchedResultsViewController
    @IBOutlet var _tableView: UITableView!
    @IBOutlet var _emptyView: UIView!
    @IBOutlet var _emptyViewLabel: UILabel!
    
    var isEmptyViewVisible: Bool = true {
        didSet {
            self._emptyView.hidden = !isEmptyViewVisible
        }
    }

    override func tableView() -> UITableView {
        return _tableView
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        switch (self.type) {
        case .News:
            return FavoriteNews.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "dateFavorite", ascending: false)
        case .Products:
            return FavoriteProduct.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "dateFavorite", ascending: false)
        }
    }
    
    // Properties
    var type: FavoriteType = .Products
    
    // Class methods
    class func instantiate() -> FavoritesViewController {
        return (UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewControllerWithIdentifier("FavoritesViewController") as? FavoritesViewController)!
    }
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title
        switch (self.type) {
        case .News:
            self.title = NSLocalizedString("fav_vc_title_news")
        case .Products:
            self.title = NSLocalizedString("fav_vc_title_products")
        }
        _emptyViewLabel.text = NSLocalizedString("fav_vc_empty_label")
        
        // Setup table
        self.tableView().tableFooterView = UIView(frame: CGRect.zero)
        
        // Background Color
        self.tableView().backgroundColor = UIColor(hex: Cons.UI.colorBG)
        
        // Setup refresh controls
        setupRefreshControls()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        
        // Make sure interactive gesture's delegate is self in case if interactive transition is cancelled
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.hideToolbar(false)
        
        // Reload data
        self.reloadData { resultCount in
            self.tableView().reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Workaround to make sure navigation bar is visible even the slide-back gesture is cancelled.
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Make sure interactive gesture's delegate is nil before disappearing
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}

// MARK: Table View
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var returnValue = 0
        if let sections = self.fetchedResultsController?.sections {
            returnValue = sections.count
        }
        self.isEmptyViewVisible = returnValue == 0
        return returnValue
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        if let rows = self.fetchedResultsController?.sections?[section].numberOfObjects {
            returnValue = rows
        }
        self.isEmptyViewVisible = returnValue == 0
        return returnValue
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        switch (self.type) {
        case .News:
            guard let _cell = tableView.dequeueReusableCellWithIdentifier("FavoriteNewsTableViewCell", forIndexPath: indexPath) as? FavoriteNewsTableViewCell else { break }
            
            if let news = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? FavoriteNews {
                // Title
                _cell.lblTitle.text = news.title
                // Image
                if let imageURLString = news.image,
                    imageURL = NSURL(string: imageURLString) {
                    _cell.imgView.sd_setImageWithURL(imageURL,
                        placeholderImage: UIImage(named: "img_placeholder_1_1_s"),
                        options: [.ContinueInBackground, .AllowInvalidSSLCertificates, .HighPriority],
                        completed: nil)
                }
            }
            
            cell = _cell
        case .Products:
            guard let _cell = tableView.dequeueReusableCellWithIdentifier("FavoriteProductsTableViewCell", forIndexPath: indexPath) as? FavoriteProductsTableViewCell else { break }
            
            if let favoriteProduct = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? FavoriteProduct {
                MagicalRecord.saveWithBlockAndWait({ (localContext) -> Void in
                    if let localFavoriteProduct = favoriteProduct.MR_inContext(localContext),
                        product = localFavoriteProduct.relatedProduct(localContext) {
                            // Title
                            _cell.lblTitle?.text = product.title
                            // Brand
                            _cell.lblBrand?.text = product.brandLabel
                            // Price
                            _cell.lblPrice?.text = CurrencyManager.shared.cheapestFormattedPriceInUserCurrency(product.prices)
                            // Image
                            if let images = product.images as? NSArray,
                                imageURLString = images.firstObject as? String,
                                imageURL = NSURL(string: imageURLString) {
                                _cell.imgView?.sd_setImageWithURL(imageURL,
                                    placeholderImage: UIImage(named: "img_placeholder_1_1_s"),
                                    options: [.ContinueInBackground, .AllowInvalidSSLCertificates],
                                    completed: nil)
                            }
                    }
                })
            }
            
            cell = _cell
        }
        
        return (cell)!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var nextViewController: UIViewController?
        
        switch (self.type) {
        case .News:
            if let news = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? FavoriteNews {
                // Prepare cover image
                var image: UIImage?
                if let imageURLString = news.image,
                    imageURL = NSURL(string: imageURLString) {
                    let cacheKey = SDWebImageManager.sharedManager().cacheKeyForURL(imageURL)
                    image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(cacheKey)
                }
                
                // Prepare view controller
                let viewController = NewsDetailViewController.instantiate()
                viewController.delegate = self
                viewController.info = news
                viewController.infoIndex = indexPath.row
                viewController.headerImage = image
                
                nextViewController = viewController
            }
        case .Products:
            if let favoriteProduct = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? FavoriteProduct {
                let diskContext = NSManagedObjectContext.MR_defaultContext()
                diskContext.performBlockAndWait({
                    if let localFavoriteProduct = favoriteProduct.MR_inContext(diskContext),
                        product = localFavoriteProduct.relatedProduct(diskContext) {
                        let viewController = ProductViewController.instantiate()
                        viewController.product = product
                        viewController.productIndex = indexPath.row
                        viewController.delegate = self
                        nextViewController = viewController
                    }
                })
            }
        }
        
        // Push view controller
        if let nextViewController = nextViewController {
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    
    // Delete favorites
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            UserManager.shared.loginOrDo() { () -> () in
                switch (self.type) {
                case .News:
                    guard let favoriteNews = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? FavoriteNews else {
                        return
                    }
                    MBProgressHUD.showLoader(self.view)
                    DataManager.shared.favoriteNews(favoriteNews.id!, wasFavorite: true) { responseObject, error in
                        // If any error
                        if error != nil {
                            return
                        }
                        // If succeeded to delete
                        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                            MBProgressHUD.hideLoader(self.view)
                            if let localFavoriteNews = favoriteNews.MR_inContext(localContext) {
                                localFavoriteNews.MR_deleteEntityInContext(localContext)
                            }
                        })
                    }
                case .Products:
                    guard let favoriteProduct = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? FavoriteProduct else {
                        return
                    }
                    MBProgressHUD.showLoader(self.view)
                    MagicalRecord.saveWithBlockAndWait({ (localContext) -> Void in
                        if let localFavoriteProduct = favoriteProduct.MR_inContext(localContext),
                            product = localFavoriteProduct.relatedProduct(localContext) {
                            product.toggleFavorite({ (data: AnyObject?) -> () in
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    MBProgressHUD.hideLoader(self.view)
                                })
                            })
                        } else {
                            MBProgressHUD.hideLoader(self.view)
                        }
                    })
                }
            }
        }
    }
}

// MARK: - Refreshing
extension FavoritesViewController {
    
    func setupRefreshControls() {
        let header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            switch (self.type) {
            case .News:
                DataManager.shared.requestNewsFavorites() { _, _ -> () in
                    self.endRefreshing()
                }
            case .Products:
                DataManager.shared.requestProductFavorites() { _, _ -> () in
                    self.endRefreshing()
                }
            }
            self.beginRefreshing()
        })
        header.setTitle(NSLocalizedString("pull_to_refresh_header_idle"), forState: .Idle)
        header.setTitle(NSLocalizedString("pull_to_refresh_header_pulling"), forState: .Pulling)
        header.setTitle(NSLocalizedString("pull_to_refresh_header_refreshing"), forState: .Refreshing)
        header.setTitle(NSLocalizedString("pull_to_refresh_no_more_data"), forState: .NoMoreData)
        header.lastUpdatedTimeLabel?.hidden = true
        self.tableView().mj_header = header
    }
    
    func beginRefreshing() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func endRefreshing() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView().mj_header.endRefreshing()
        })
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

// MARK: UIGestureRecognizerDelegate
extension FavoritesViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: SwitchPrevNextItemDelegate
extension FavoritesViewController: SwitchPrevNextItemDelegate {
    
    func hasNextItem(indexPath: NSIndexPath, isNext: Bool) -> Bool {
        return self.fetchedResultsController?.fetchedObjects?.isEmpty == false
    }
    
    func getNextItem(indexPath: NSIndexPath, isNext: Bool, completion: ((indexPath: NSIndexPath?, item: Any?)->())?) {
        guard let completion = completion else { return }
        
        guard let fetchedResults = self.fetchedResultsController?.fetchedObjects else { return
            completion(indexPath: nil, item: nil)
        }
        
        var newIndex = indexPath.row + (isNext ? 1 : -1)
        if newIndex < 0 {
            newIndex = fetchedResults.count - 1
        }
        if newIndex > fetchedResults.count - 1 {
            newIndex = 0
        }
        
        completion(indexPath: NSIndexPath(forRow: newIndex, inSection: 0), item: fetchedResults[newIndex])
    }
    
    func didShowItem(indexPath: NSIndexPath, isNext: Bool) {
        self.tableView().scrollToRowAtIndexPath(indexPath, atScrollPosition: isNext ? .Top : .Bottom, animated: false)
    }
}

// MARK: ProductViewControllerDelegate
extension FavoritesViewController: ProductViewControllerDelegate {
    
    func getNextProduct(currentIndex: Int?) -> (Int?, Product?)? {
        guard let fetchedResults = self.fetchedResultsController?.fetchedObjects else { return nil }
        
        var currentProductIndex = -1
        if let currentIndex = currentIndex {
            currentProductIndex = currentIndex
        }
        
        let nextProductIndex = currentProductIndex + 1
        if nextProductIndex < fetchedResults.count {
            if let favoriteProduct =  fetchedResults[nextProductIndex] as? FavoriteProduct {
                let product = favoriteProduct.relatedProduct(nil)
                return (nextProductIndex, product)
            }
        }
        
        return nil
    }
    
    func didShowNextProduct(product: Product, index: Int) {
        self.tableView().scrollToRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), atScrollPosition: .Top, animated: false)
    }
}

// MARK: - Custom cells
class FavoriteNewsTableViewCell: UITableViewCell {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        imgView.image = nil
        lblTitle.text = nil
    }
}

class FavoriteProductsTableViewCell: UITableViewCell {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblBrand: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
    }
    
    override func prepareForReuse() {
        lblBrand.text = nil
        lblTitle.text = nil
        lblPrice.text = nil
    }
}
