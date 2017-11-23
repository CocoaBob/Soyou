//
//  FavoritesViewController.swift
//  Soyou
//
//  Created by CocoaBob on 19/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

enum FavoriteType: Int {
    case news
    case discounts
    case products
}

class FavoritesViewController: SyncedFetchedResultsViewController {
    
    // Override SyncedFetchedResultsViewController
    @IBOutlet var _tableView: UITableView!
    @IBOutlet var _emptyView: UIView!
    @IBOutlet var _emptyViewLabel: UILabel!
    
    var isEmptyViewVisible: Bool = true {
        didSet {
            self._emptyView.isHidden = !isEmptyViewVisible
        }
    }

    override func tableView() -> UITableView {
        return _tableView
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController<NSFetchRequestResult>? {
        switch (self.type) {
        case .news:
            return FavoriteNews.mr_fetchAllGrouped(by: nil, with: nil, sortedBy: "dateFavorite", ascending: false)
        case .discounts:
            return FavoriteDiscount.mr_fetchAllGrouped(by: nil, with: nil, sortedBy: "dateFavorite", ascending: false)
        case .products:
            return FavoriteProduct.mr_fetchAllGrouped(by: nil, with: nil, sortedBy: "dateFavorite", ascending: false)
        }
    }
    
    // Properties
    var type: FavoriteType = .products
    
    // Class methods
    class func instantiate() -> FavoritesViewController {
        return UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewController(withIdentifier: "FavoritesViewController") as! FavoritesViewController
    }
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Title
        switch (self.type) {
        case .news:
            self.title = NSLocalizedString("fav_vc_title_news")
        case .discounts:
            self.title = NSLocalizedString("fav_vc_title_discounts")
        case .products:
            self.title = NSLocalizedString("fav_vc_title_products")
        }
        _emptyViewLabel.text = NSLocalizedString("fav_vc_empty_label")
        
        // Setup table
        self.tableView().tableFooterView = UIView(frame: CGRect.zero)
        
        // Background Color
        self.tableView().backgroundColor = Cons.UI.colorBG
        
        // Setup refresh controls
        setupRefreshControls()
        
        if #available(iOS 11.0, *) {
            self.tableView().contentInsetAdjustmentBehavior = .always
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        
        // Make sure interactive gesture's delegate is self in case if interactive transition is cancelled
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.hideToolbar(false)
        
        // Reload data
        self.reloadData {
            self.tableView().reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Workaround to make sure navigation bar is visible even the slide-back gesture is cancelled.
        DispatchQueue.main.async {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Make sure interactive gesture's delegate is nil before disappearing
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}

// MARK: Table View
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var returnValue = 0
        if let sections = self.fetchedResultsController?.sections {
            returnValue = sections.count
        }
        self.isEmptyViewVisible = returnValue == 0
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        if let rows = self.fetchedResultsController?.sections?[section].numberOfObjects {
            returnValue = rows
        }
        self.isEmptyViewVisible = returnValue == 0
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        switch (self.type) {
        case .news:
            guard let _cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteInfosTableViewCell", for: indexPath) as? FavoriteInfosTableViewCell else { break }
            
            if let news = self.fetchedResultsController?.object(at: indexPath) as? FavoriteNews {
                // Title
                _cell.lblTitle.text = news.title
                // Image
                if let imageURLString = news.image,
                    let imageURL = URL(string: imageURLString) {
                    _cell.imgView.sd_setImage(with: imageURL,
                                              placeholderImage: UIImage(named: "img_placeholder_1_1_s"),
                                              options: [.continueInBackground, .allowInvalidSSLCertificates, .highPriority],
                                              completed: nil)
                }
            }
            
            cell = _cell
        case .discounts:
            guard let _cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteInfosTableViewCell", for: indexPath) as? FavoriteInfosTableViewCell else { break }
            
            if let discount = self.fetchedResultsController?.object(at: indexPath) as? FavoriteDiscount {
                // Title
                _cell.lblTitle.text = discount.title
                // Image
                if let imageURLString = discount.coverImage,
                    let imageURL = URL(string: imageURLString) {
                    _cell.imgView.sd_setImage(with: imageURL,
                                              placeholderImage: UIImage(named: "img_placeholder_1_1_s"),
                                              options: [.continueInBackground, .allowInvalidSSLCertificates, .highPriority],
                                              completed: nil)
                }
            }
            
            cell = _cell
        case .products:
            guard let _cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteProductsTableViewCell", for: indexPath) as? FavoriteProductsTableViewCell else { break }
            
            if let favoriteProduct = self.fetchedResultsController?.object(at: indexPath) as? FavoriteProduct {
                MagicalRecord.save(blockAndWait: { (localContext) -> Void in
                    if let localFavoriteProduct = favoriteProduct.mr_(in: localContext),
                        let product = localFavoriteProduct.relatedProduct(localContext) {
                            // Title
                            _cell.lblTitle?.text = product.title
                            // Brand
                            _cell.lblBrand?.text = product.brandLabel
                            // Price
                            _cell.lblPrice?.text = CurrencyManager.shared.cheapestFormattedPriceInUserCurrency(product.prices)
                            // Image
                            if let images = product.images as? NSArray,
                                let imageURLString = images.firstObject as? String,
                                let imageURL = URL(string: imageURLString) {
                                _cell.imgView?.sd_setImage(with: imageURL,
                                                           placeholderImage: UIImage(named: "img_placeholder_1_1_s"),
                                                           options: [.continueInBackground, .allowInvalidSSLCertificates],
                                                           completed: nil)
                        }
                    }
                })
            }
            
            cell = _cell
        }
        
        return (cell)!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var nextViewController: UIViewController?
        
        switch (self.type) {
        case .news:
            if let news = self.fetchedResultsController?.object(at: indexPath) as? FavoriteNews {
                // Prepare cover image
                var image: UIImage?
                if let imageURLString = news.image,
                    let imageURL = URL(string: imageURLString) {
                    let cacheKey = SDWebImageManager.shared().cacheKey(for: imageURL)
                    image = SDImageCache.shared().imageFromDiskCache(forKey: cacheKey)
                }
                
                // Prepare view controller
                let viewController = NewsDetailViewController.instantiate()
                viewController.delegate = self
                viewController.info = news
                viewController.infoIndex = indexPath.row
                viewController.headerImage = image
                
                nextViewController = viewController
            }
        case .discounts:
            if let discount = self.fetchedResultsController?.object(at: indexPath) as? FavoriteDiscount {
                // Prepare cover image
                var image: UIImage?
                if let imageURLString = discount.coverImage,
                    let imageURL = URL(string: imageURLString) {
                    let cacheKey = SDWebImageManager.shared().cacheKey(for: imageURL)
                    image = SDImageCache.shared().imageFromDiskCache(forKey: cacheKey)
                }
                
                // Prepare view controller
                let viewController = DiscountDetailViewController.instantiate()
                viewController.delegate = self
                viewController.info = discount
                viewController.infoIndex = indexPath.row
                viewController.headerImage = image
                
                nextViewController = viewController
            }
        case .products:
            if let favoriteProduct = self.fetchedResultsController?.object(at: indexPath) as? FavoriteProduct {
                let diskContext = NSManagedObjectContext.mr_default()
                diskContext.performAndWait({
                    if let localFavoriteProduct = favoriteProduct.mr_(in: diskContext),
                        let product = localFavoriteProduct.relatedProduct(diskContext) {
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
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            UserManager.shared.loginOrDo() { () -> () in
                switch (self.type) {
                case .news:
                    guard let favoriteNews = self.fetchedResultsController?.object(at: indexPath) as? FavoriteNews else {
                        return
                    }
                    MBProgressHUD.show(self.view)
                    DataManager.shared.favoriteNews(favoriteNews.id!, wasFavorite: true) { responseObject, error in
                        // If any error
                        if error != nil {
                            return
                        }
                        // If succeeded to delete
                        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
                            MBProgressHUD.hide(self.view)
                            if let localFavoriteNews = favoriteNews.mr_(in: localContext) {
                                localFavoriteNews.mr_deleteEntity(in: localContext)
                            }
                        })
                    }
                case .discounts:
                    guard let favoriteDiscount = self.fetchedResultsController?.object(at: indexPath) as? FavoriteDiscount else {
                        return
                    }
                    MBProgressHUD.show(self.view)
                    DataManager.shared.favoriteDiscount(favoriteDiscount.id!, wasFavorite: true) { responseObject, error in
                        // If any error
                        if error != nil {
                            return
                        }
                        // If succeeded to delete
                        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
                            MBProgressHUD.hide(self.view)
                            if let localFavoriteDiscount = favoriteDiscount.mr_(in: localContext) {
                                localFavoriteDiscount.mr_deleteEntity(in: localContext)
                            }
                        })
                    }
                case .products:
                    guard let favoriteProduct = self.fetchedResultsController?.object(at: indexPath) as? FavoriteProduct else {
                        return
                    }
                    MBProgressHUD.show(self.view)
                    MagicalRecord.save(blockAndWait: { (localContext) -> Void in
                        if let localFavoriteProduct = favoriteProduct.mr_(in: localContext),
                            let product = localFavoriteProduct.relatedProduct(localContext) {
                            product.toggleFavorite({ (data: Any?) -> () in
                                DispatchQueue.main.async {
                                    MBProgressHUD.hide(self.view)
                                }
                            })
                        } else {
                            MBProgressHUD.hide(self.view)
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
        guard let header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            switch (self.type) {
            case .news:
                DataManager.shared.requestNewsFavorites() { _, _ -> () in
                    self.endRefreshing(0)
                }
            case .discounts:
                DataManager.shared.requestDiscountFavorites() { _, _ -> () in
                    self.endRefreshing(0)
                }
            case .products:
                DataManager.shared.requestProductFavorites() { _, _ -> () in
                    self.endRefreshing(0)
                }
            }
            self.beginRefreshing()
        }) else {
            return
        }
        header.setTitle(NSLocalizedString("pull_to_refresh_header_idle"), for: .idle)
        header.setTitle(NSLocalizedString("pull_to_refresh_header_pulling"), for: .pulling)
        header.setTitle(NSLocalizedString("pull_to_refresh_header_refreshing"), for: .refreshing)
        header.setTitle(NSLocalizedString("pull_to_refresh_no_more_data"), for: .noMoreData)
        header.lastUpdatedTimeLabel?.isHidden = true
        self.tableView().mj_header = header
    }
    
    func beginRefreshing() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func endRefreshing(_ resultCount: Int) {
        DispatchQueue.main.async {
            self.tableView().mj_header.endRefreshing()
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

// MARK: UIGestureRecognizerDelegate
extension FavoritesViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: SwitchPrevNextItemDelegate
extension FavoritesViewController: SwitchPrevNextItemDelegate {
    
    func hasNextItem(_ indexPath: IndexPath, isNext: Bool) -> Bool {
        return self.fetchedResultsController?.fetchedObjects?.isEmpty == false
    }
    
    func getNextItem(_ indexPath: IndexPath, isNext: Bool, completion: ((_ indexPath: IndexPath?, _ item: Any?)->())?) {
        guard let completion = completion else { return }
        
        guard let fetchedResults = self.fetchedResultsController?.fetchedObjects else { return
            completion(nil, nil)
        }
        
        var newIndex = indexPath.row + (isNext ? 1 : -1)
        if newIndex < 0 {
            newIndex = fetchedResults.count - 1
        }
        if newIndex > fetchedResults.count - 1 {
            newIndex = 0
        }
        
        completion(IndexPath(row: newIndex, section: 0), fetchedResults[newIndex])
    }
    
    func didShowItem(_ indexPath: IndexPath, isNext: Bool) {
        self.tableView().scrollToRow(at: indexPath, at: isNext ? .top : .bottom, animated: false)
    }
}

// MARK: ProductViewControllerDelegate
extension FavoritesViewController: ProductViewControllerDelegate {
    
    func getNextProduct(_ currentIndex: Int?) -> (Int?, Product?)? {
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
    
    func didShowNextProduct(_ product: Product, index: Int) {
        self.tableView().scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: false)
    }
}

// MARK: - Custom cells
class FavoriteInfosTableViewCell: UITableViewCell {
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
