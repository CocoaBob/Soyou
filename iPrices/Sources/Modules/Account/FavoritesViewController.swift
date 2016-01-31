//
//  FavoritesViewController.swift
//  iPrices
//
//  Created by CocoaBob on 19/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

enum FavoriteType: Int {
    case News
    case Products
}

class FavoritesViewController: BaseViewController {
    
    // Override BaseViewController
    @IBOutlet var _tableView: UITableView!
    
    override func tableView() -> UITableView {
        return _tableView
    }
    
    override func createFetchedResultsController() -> NSFetchedResultsController? {
        switch (self.type) {
        case .News:
            return FavoriteNews.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "datePublication:false,id:false", ascending: false)
        case .Products:
            return Product.MR_fetchAllGroupedBy(nil, withPredicate: FmtPredicate("appIsFavorite == %@", NSNumber(bool: true)), sortedBy: "order,id", ascending: true)
        }
    }
    
    // Properties
    var type: FavoriteType = .Products
    
    // Class methods
    class func instantiate() -> FavoritesViewController {
        return UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewControllerWithIdentifier("FavoritesViewController") as! FavoritesViewController
    }
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Bars
        self.hidesBottomBarWhenPushed = true
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
        
        // Setup table
        self.tableView().tableFooterView = UIView(frame: CGRectZero)
        
        // Background Color
        self.tableView().backgroundColor = UIColor(rgba: Cons.UI.colorBG)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
        
        // Make sure interactive gesture's delegate is self in case if interactive transition is cancelled
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.hideToolbar(false);
        
        // Load favorites
        if UserManager.shared.isLoggedIn {
            switch (self.type) {
            case .News:
                DataManager.shared.requestNewsFavorites(nil)
            case .Products:
                DataManager.shared.requestProductFavorites(nil, nil)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Workaround to make sure navigation bar is visible even the slide-back gesture is cancelled.
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }
}

// MARK: Table View
extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let sections = self.fetchedResultsController.sections {
            return sections.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.sections![section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        switch (self.type) {
        case .News:
            let _cell = tableView.dequeueReusableCellWithIdentifier("FavoriteNewsTableViewCell", forIndexPath: indexPath) as! FavoriteNewsTableViewCell
            let news = self.fetchedResultsController.objectAtIndexPath(indexPath) as! FavoriteNews
            // Title
            _cell.lblTitle.text = news.title
            // Image
            if let imageURLString = news.image, let imageURL = NSURL(string: imageURLString) {
                _cell.imgView.sd_setImageWithURL(imageURL,
                    placeholderImage: UIImage.imageWithRandomColor(nil),
                    options: [.ContinueInBackground, .AllowInvalidSSLCertificates, .HighPriority],
                    completed: nil)
            }
            cell = _cell
        case .Products:
            let _cell = tableView.dequeueReusableCellWithIdentifier("FavoriteProductsTableViewCell", forIndexPath: indexPath) as! FavoriteProductsTableViewCell
            let product = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Product
            // Title
            _cell.lblTitle?.text = product.title
            // Brand
            _cell.lblBrand?.text = product.brandLabel
            // Price
            _cell.lblPrice?.text = CurrencyManager.shared.cheapestFormattedPriceInCHY(product.prices as? [NSDictionary])
            // Image
            if let images = product.images as? NSArray, let imageURLString = images.firstObject as? String, let imageURL = NSURL(string: imageURLString) {
                _cell.imgView?.sd_setImageWithURL(imageURL,
                    placeholderImage: UIImage.imageWithRandomColor(nil),
                    options: [.ContinueInBackground, .AllowInvalidSSLCertificates],
                    completed: nil)
            }
            cell = _cell
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var nextViewController: UIViewController?
        
        switch (self.type) {
        case .News:
            let news = self.fetchedResultsController.objectAtIndexPath(indexPath) as! FavoriteNews
            // Prepare cover image
            var image: UIImage?
            if let imageURLString = news.image, let imageURL = NSURL(string: imageURLString) {
                let cacheKey = SDWebImageManager.sharedManager().cacheKeyForURL(imageURL)
                image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(cacheKey)
            }
            
            // Prepare view controller
            let viewController = NewsDetailViewController.instantiate()
            viewController.news = news
            viewController.headerImage = image
            
            nextViewController = viewController
        case .Products:
            let product = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Product
            
            let viewController = ProductViewController.instantiate()
            viewController.product = product
            
            nextViewController = viewController
        }
        
        // Push view controller
        self.navigationController?.pushViewController(nextViewController!, animated: true)
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
                    let news = self.fetchedResultsController.objectAtIndexPath(indexPath) as! FavoriteNews
                    MBProgressHUD.showLoader(self.view)
                    DataManager.shared.favoriteNews(news.id!, wasFavorite: true) { responseObject, error in
                        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                            MBProgressHUD.hideLoader(self.view)
                            if let localNews = news.MR_inContext(localContext) {
                                localNews.MR_deleteEntity()
                            }
                        })
                    }
                case .Products:
                    let product = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Product
                    MBProgressHUD.showLoader(self.view)
                    product.doFavorite({ (data: AnyObject?) -> () in
                        MBProgressHUD.hideLoader(self.view)
                    })
                }
            }
        }
    }
    
}

// MARK: UIGestureRecognizerDelegate
extension FavoritesViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - Custom cells
class FavoriteNewsTableViewCell: UITableViewCell {
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
    }
    
    override func prepareForReuse() {
        lblBrand.text = nil
        lblTitle.text = nil
        lblPrice.text = nil
    }
}