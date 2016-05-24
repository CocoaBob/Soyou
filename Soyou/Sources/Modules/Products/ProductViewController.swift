//
//  ProductViewController.swift
//  Soyou
//
//  Created by CocoaBob on 03/01/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

protocol ProductViewControllerDelegate {
    
    func getNextProduct(currentIndex: Int?) -> (Int?, Product?)?
    func didShowNextProduct(product: Product, index: Int)
}

class ProductViewController: UIViewController {
    
    // For next product
    var delegate: ProductViewControllerDelegate?
    var nextProductBarButtonItem: UIBarButtonItem?
    var productIndex: Int?
    var nextProduct: Product?
    var nextProductIndex: Int?
    
    // Properties
    var isEdgeSwiping: Bool = false // Use edge swiping instead of custom animator if interactivePopGestureRecognizer is trigered
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var subViewsContainer: UIView!
    @IBOutlet var carouselView: PFCarouselView!
    @IBOutlet var carouselViewHeight: NSLayoutConstraint?
    @IBOutlet var viewsContainerHeight: NSLayoutConstraint?
    
    var product: Product? // self.product could be in memory store, so we have to use its own menagedObjectContext instead of using default context
    // Images for Carousel
    var firstImage: UIImage?
    var imageViews: [UIImageView] = [UIImageView]()
    var carouselViewRatio: CGFloat = 1.1
    // Photos for IDMPhotoBrowser
    var photos: [IDMPhoto] = [IDMPhoto]()
    
    var productPricesViewController = ProductPricesViewController.instantiate()
    var productDescriptionsViewController = ProductDescriptionsViewController.instantiate()
    var descriptionViewHeight: CGFloat = 0
    
    // PageMenu
    var pageMenu: CAPSPageMenu?
    var pageMenuHeight: CGFloat = 30
    
    // Toolbar
    var btnLike: UIButton?
    let btnLikeActiveColor = UIColor(hex:Cons.UI.colorLike)
    let btnLikeInactiveColor = UIToolbar.appearance().tintColor
    var btnFav: UIButton?
    let btnFavActiveColor = UIColor(hex:Cons.UI.colorHeart)
    let btnFavInactiveColor = UIToolbar.appearance().tintColor
    
    // Status bar cover
    var isStatusBarCoverVisible = false
    let statusBarCover = UIView(frame:
        CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.width, height: UIApplication.sharedApplication().statusBarFrame.height)
    )
    
    // Class methods
    class func instantiate() -> ProductViewController {
        return (UIStoryboard(name: "ProductsViewController", bundle: nil).instantiateViewControllerWithIdentifier("ProductViewController") as? ProductViewController)!
    }
    
    // Life cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Hide tabs
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Status bar
        self.statusBarCover.backgroundColor = UIColor.whiteColor()
        
        // Toolbar
        self.btnLike = UIButton(type: .System)
        self.btnFav = UIButton(type: .System)
        
        self.btnLike?.titleLabel?.font = UIFont.systemFontOfSize(10)
        self.btnLike?.titleEdgeInsets = UIEdgeInsets(top: -20, left: -0, bottom: 1, right: 0)
        self.btnLike?.backgroundColor = UIColor.clearColor()
        self.btnLike?.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        self.btnLike?.setImage(UIImage(named: "img_thumb"), forState: .Normal)
        self.btnLike?.imageEdgeInsets = UIEdgeInsets(top: -1, left: -0, bottom: 1, right: 0) // Adjust image position
        self.btnLike?.addTarget(self, action: #selector(ProductViewController.like(_:)), forControlEvents: .TouchUpInside)
        
        self.btnFav?.backgroundColor = UIColor.clearColor()
        self.btnFav?.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        self.btnFav?.setImage(UIImage(named: "img_heart"), forState: .Normal)
        self.btnFav?.imageEdgeInsets = UIEdgeInsets(top: -1, left: -0, bottom: 1, right: 0) // Adjust image position
        self.btnFav?.addTarget(self, action: #selector(ProductViewController.star(_:)), forControlEvents: .TouchUpInside)
        
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: Selector())
        let next = UIBarButtonItem(image: UIImage(named:"img_arrow_down"), style: .Plain, target: self, action: #selector(ProductViewController.next(_:)))
        let fav = UIBarButtonItem(customView: self.btnFav!)
        let like = UIBarButtonItem(customView: self.btnLike!)
        self.toolbarItems = [ space, next, space, fav, space, like, space]
        let _ = self.toolbarItems?.map() { $0.width = 64 }
        
        next.enabled = false
        self.nextProductBarButtonItem = next
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.scrollView, 0, true, false, false, false)
        
        // Load content
        self.loadProduct(false)
    }
    
    override func viewWillAppear(animated: Bool) {
        // Hide navigation bar if it's visible again
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        // Reset isEdgeSwiping to false, if interactive transition is cancelled
        self.isEdgeSwiping = false
        // Make sure interactive gesture's delegate is self in case if interactive transition is cancelled
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        // Update statusbar cover
        self.addStatusBarCover()
        // Show tool bar if it's invisible again
        self.showToolbar(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeStatusBarCover()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        // Update Status Bar Cover
        self.removeStatusBarCover()
        // Reset isEdgeSwiping to false, if interactive transition is cancelled
        self.isEdgeSwiping = false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
}

// MARK: Load products
extension ProductViewController {
    
    func loadProduct(isNext: Bool) {
        // Setup images for carousel View
        self.setupCarouselView()
        // SubViewControllers
        self.setupSubViewControllers(isNext)
        // Like button status
        updateLikeNumber()
        // Favorite button status
        self.isFavorite = self.product?.isFavorite() ?? false
        // Prepare next product
        if let (index, product) = self.delegate?.getNextProduct(self.productIndex) {
            self.nextProductIndex = index
            self.nextProduct = product
        } else {
            self.nextProductIndex = nil
            self.nextProduct = nil
        }
        // Next button status
        self.nextProductBarButtonItem?.enabled = self.nextProduct != nil
    }
    
    func loadNextProduct() {
        if let nextProduct = self.nextProduct {
            self.product = nextProduct
            self.firstImage = nil
            self.productIndex = self.nextProductIndex
            self.loadProduct(true)
            let transition = CATransition()
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromTop
            self.view.layer .addAnimation(transition, forKey: "transition")
            self.delegate?.didShowNextProduct(nextProduct, index: self.productIndex ?? 0)
        }
    }
}

// MARK: Status Bar Cover
extension ProductViewController: UIScrollViewDelegate {
    
    private func addStatusBarCover() {
        isStatusBarCoverVisible = true
        self.tabBarController?.view.addSubview(self.statusBarCover)
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
            self.statusBarCover.alpha = 1
        })
    }
    
    private func removeStatusBarCover() {
        isStatusBarCoverVisible = false
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
            self.statusBarCover.alpha = 0
            }, completion: { (finished) -> Void in
                self.statusBarCover.removeFromSuperview()
        })
    }
}

// MARK: Carousel View
extension ProductViewController {
    
    private func setupCarouselView() {
        // Update the frame of carousel view
        let carouselViewHeight = self.view.frame.width / self.carouselViewRatio
        self.carouselViewHeight?.constant = carouselViewHeight
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        // Prepare data
        self.imageViews.removeAll()
        var images: [String]?
        var title: String?
        self.product?.managedObjectContext?.runBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            guard let localProduct = self.product?.MR_inContext(localContext) else { return }
            images = localProduct.images as? [String]
            title = localProduct.title
        })
        let imageViewFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: carouselViewHeight)
        if let images = images {
            // Reset self.photos
            self.photos = Array(count: images.count, repeatedValue: IDMPhoto())
            // Add 1st image
            if let firstImage = self.firstImage {
                // ImageView for Carousel
                let firstImageView = UIImageView(frame: imageViewFrame)
                firstImageView.contentMode = .ScaleAspectFit
                firstImageView.image = firstImage
                self.imageViews.append(firstImageView)
                // Photo for IDMPhotoBrowser
                self.photos[0] = IDMPhoto(image: firstImage)
            } else {
                self.firstImage = nil
            }
            // Add other images
            if self.firstImage == nil || images.count > 1 {
                for index in (self.firstImage != nil) ? (1..<images.count) : (0..<images.count) {
                    let imageURLString = images[index]
                    if let imageURL = NSURL(string: imageURLString) {
                        // Photo for IDMPhotoBrowser
                        self.photos[index] = IDMPhoto(URL: imageURL)
                        // ImageView for Carousel
                        let placeholder = UIImage(named: "img_placeholder_1_1_m")
                        let imageView = UIImageView(frame: imageViewFrame)
                        imageView.contentMode = .ScaleAspectFit
                        imageView.sd_setImageWithURL(
                            imageURL,
                            placeholderImage: placeholder,
                            options: [.ContinueInBackground, .AllowInvalidSSLCertificates],
                            completed: { (image, error, cacheType, url) -> Void in
                                let photo = IDMPhoto(image: image ?? placeholder)
                                self.photos[index] = photo
                        })
                        self.imageViews.append(imageView)
                    }
                }
            }
        }
        
        // Setup UI
        self.carouselView.delegate = self
        if let title = title {
            self.carouselView.textLabel.numberOfLines = 0
            self.carouselView.textLabel.font = UIFont.boldSystemFontOfSize(17)
            self.carouselView.textLabelShow = true
            self.carouselView.textString = title
            self.carouselView.textInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        } else {
            self.carouselView.textLabelShow = false
        }
        self.carouselView.refresh()
    }
    
}

// MARK: Sub View Controllers
extension ProductViewController {
    
    func setupSubViewControllers(isNext: Bool) {
        guard let product = self.product else { return }
        
        // Add page menu to the scroll view's subViewsContainer
        if self.pageMenu == nil {
            // Prepare childViewControllers
            var viewControllers = [UIViewController]()
            // Prices VC
            self.productPricesViewController.productViewController = self
            self.productPricesViewController.title = NSLocalizedString("product_prices_vc_title")
            self.productPricesViewController.view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
            viewControllers.append(self.productPricesViewController)
            
            // Descriptions VC
            self.productDescriptionsViewController.productViewController = self
            self.productDescriptionsViewController.title = NSLocalizedString("product_descriptions_vc_title")
            self.productDescriptionsViewController.webViewHeightDelegate = self
            self.productDescriptionsViewController.view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
            
            viewControllers.append(self.productDescriptionsViewController)
            
            // Customize menu (Optional)
            let parameters: [String: AnyObject] = [
                CAPSPageMenuOptionMenuItemSeparatorWidth: NSNumber(double: 0),
                CAPSPageMenuOptionScrollMenuBackgroundColor: UIColor.whiteColor(),
                CAPSPageMenuOptionSelectionIndicatorColor: UIColor.darkGrayColor(),
                CAPSPageMenuOptionSelectedMenuItemLabelColor: UIColor.darkGrayColor(),
                CAPSPageMenuOptionUnselectedMenuItemLabelColor: UIColor.lightGrayColor(),
                CAPSPageMenuOptionUseMenuLikeSegmentedControl: NSNumber(bool: true),
                CAPSPageMenuOptionCenterMenuItems: NSNumber(bool: true),
                CAPSPageMenuOptionMenuItemFont: UIFont.systemFontOfSize(13),
                CAPSPageMenuOptionMenuMargin: NSNumber(double: 10.0),
                CAPSPageMenuOptionMenuHeight: self.pageMenuHeight,
                CAPSPageMenuOptionAddBottomMenuHairline: NSNumber(bool: true),
                CAPSPageMenuOptionBottomMenuHairlineColor: UIColor.whiteColor()
            ]
            
            // Create CAPSPageMenu
            self.pageMenu = CAPSPageMenu(
                viewControllers: viewControllers,
                frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: self.view.frame.height),
                options: parameters)
            
            // Add CAPSPageMenu
            if let pageMenu = self.pageMenu {
                pageMenu.view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
                self.subViewsContainer.addSubview(pageMenu.view)
                pageMenu.view.frame = CGRect(x: 0, y: 0, width: self.subViewsContainer.frame.width, height: self.subViewsContainer.frame.height)
            }
        }
        
        self.productPricesViewController.product = product
        self.productDescriptionsViewController.product = product
        
        // Update height
        self.updateViewsContainerHeight(false)
                
        // Reload data
        if isNext {
            self.productPricesViewController.reloadData()
            self.productDescriptionsViewController.reloadData()
        }
        
        // Preselect sub view
        if let noPrices = self.productPricesViewController.prices?.isEmpty {
            if noPrices {
                self.pageMenu?.moveToPage(1)
            }
        }
    }
}

// MARK: Control view height
extension ProductViewController: WebViewHeightDelegate {

    func webView(webView: UIWebView, didChangeHeight height: CGFloat) {
        descriptionViewHeight = height
        self.updateViewsContainerHeight(true)
    }
    
    func updateViewsContainerHeight(animated: Bool) {
        let pricesViewHeight = self.productPricesViewController.tableView.contentSize.height ?? 0
        let descriptionsViewHeight = descriptionViewHeight
        let maxHeight = max(descriptionsViewHeight, pricesViewHeight)
        self.viewsContainerHeight?.constant = maxHeight + self.pageMenuHeight + 20 // Bottom margin 20
        self.view.setNeedsLayout()
        if animated {
            UIView.animateWithDuration(0.3) { () -> Void in
                self.view.layoutIfNeeded()
            }
        } else {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: PFCarouselView
extension ProductViewController: PFCarouselViewDelegate {
    
    func numberOfPagesInCarouselView(carouselView: PFCarouselView!) -> Int {
        return self.imageViews.count
    }
    
    func carouselView(carouselView: PFCarouselView!, setupContentViewAtIndex index: Int) -> UIView! {
        let imageView = self.imageViews[index]
        imageView.frame = carouselView.bounds
        return imageView
    }
    
    func carouselView(carouselView: PFCarouselView!, didSelectViewAtIndex index: Int) {
        let imageView = self.imageViews[index]
        IDMPhotoBrowser.present(self.photos, index: UInt(index), view: imageView, scaleImage: imageView.image, viewVC: self)
    }
}

// MARK: UIGestureRecognizerDelegate
extension ProductViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
            self.isEdgeSwiping = true
        }
        return true
    }
}

// MARK: ZoomInteractiveTransition
extension ProductViewController: ZoomTransitionProtocol {
    
    func viewForZoomTransition(isSource: Bool) -> UIView? {
        return self.imageViews.first
    }
    
    func initialZoomViewSnapshotFromProposedSnapshot(snapshot: UIImageView!) -> UIImageView? {
        if (!self.imageViews.isEmpty) {
            let imageView = self.imageViews[0]
            let returnImageView = UIImageView(image: imageView.image)
            returnImageView.contentMode = imageView.contentMode
            returnImageView.clipsToBounds = imageView.clipsToBounds
            return returnImageView
        }
        return nil
    }
    
    func shouldAllowZoomTransitionForOperation(operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController!, toViewController toVC: UIViewController!) -> Bool {
        // No zoom transition when edge swiping
        if self.isEdgeSwiping {
            return false
        }
        // Only available for opening a product from products view controller
        if ((operation == .Push && fromVC is ProductsViewController && toVC === self) ||
            (operation == .Pop && fromVC === self && toVC is ProductsViewController)) {
                return true
        }
        return false
    }
}

// MARK: Like button
extension ProductViewController {
    
    private func updateLikeNumber() {
        self.product?.managedObjectContext?.runBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if let localProduct = self.product?.MR_inContext(localContext) {
                // Update like number
                guard let productID = localProduct.id else { return }
                DataManager.shared.requestProductInfo("\(productID)") { responseObject, error in
                    if let responseObject = responseObject as? [String:AnyObject],
                        data = responseObject["data"] as? [String:AnyObject],
                        likeNumber = data["likeNumber"] as? NSNumber {
                        self.likeBtnNumber = likeNumber.integerValue
                    }
                }
                
                // Update like button color
                let diskContext = NSManagedObjectContext.MR_defaultContext()
                diskContext.performBlockAndWait({
                    guard let diskProduct = Product.MR_findFirstByAttribute("id", withValue: productID, inContext: diskContext) else { return }
                    self.updateLikeBtnColor(diskProduct.appIsLiked?.boolValue)
                })
            }
        })
    }
    
    private func updateLikeBtnColor(isLiked: Bool?) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if isLiked != nil && isLiked!.boolValue {
                self.btnLike?.tintColor = self.btnLikeActiveColor
            } else {
                self.btnLike?.tintColor = self.btnLikeInactiveColor
            }
        }
    }
    
    private var likeBtnNumber: Int? {
        set(newValue) {
            if newValue != nil && newValue! > 0 {
                self.btnLike?.setTitle("\(newValue!)", forState: .Normal)
            } else {
                self.btnLike?.setTitle("", forState: .Normal)
            }
        }
        get {
            if let title = self.btnLike?.titleForState(.Normal) {
                return Int(title)
            } else {
                return 0
            }
        }
    }
}

// MARK: Fav button
extension ProductViewController {
    
    private var isFavorite: Bool {
        set(newValue) {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.btnFav?.setImage(UIImage(named: newValue ? "img_heart_selected" : "img_heart"), forState: .Normal)
                self.btnFav?.tintColor = newValue ? self.btnFavActiveColor : self.btnFavInactiveColor
            }
        }
        get {
            return self.btnFav?.tintColor == btnFavActiveColor
        }
    }
}

// MARK: Actions
extension ProductViewController {
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func next(sender: AnyObject) {
        self.loadNextProduct()
    }
    
    @IBAction func share(sender: AnyObject) {
        MBProgressHUD.showLoader(self.view)
        
        var productID: String?
        var title: String?
        var htmlString: String?
        let userCurrency = CurrencyManager.shared.userCurrency
        
        self.product?.managedObjectContext?.runBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            let localProduct = self.product?.MR_inContext(localContext)
            // If there's no SKU
            if let oldID = localProduct?.id {
                productID = "\(oldID)"
            }
            // If SKU exists, use SKU
            if let objectData = localProduct?.sku,
                object = Utils.decrypt(objectData) as? String {
                productID = object
            }
            if let descriptions = localProduct?.descriptions {
                htmlString = descriptions
            }
            title = localProduct?.title
        })
        
        // Descriptions
        var descriptions: String?
        if let htmlString = htmlString,
            htmlData = htmlString.dataUsingEncoding(NSUTF8StringEncoding) {
                do {
                    let attributedString = try NSAttributedString(data: htmlData,
                        options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                            NSCharacterEncodingDocumentAttribute:NSNumber(unsignedInteger: NSUTF8StringEncoding)],
                        documentAttributes: nil)
                    var contentString = attributedString.string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    if contentString.characters.count > 256 {
                        contentString = contentString.substringToIndex(contentString.startIndex.advancedBy(256))
                    }
                    descriptions = contentString
                } catch {
                    
                }
        }
        
        // Title
        if let strTitle = title {
            if strTitle.characters.count > 128 {
                title = strTitle.substringToIndex(strTitle.startIndex.advancedBy(128))
            }
        }
        
        var items = [AnyObject]()
        if let item = self.imageViews.first?.image {
            items.append(item)
        }
        if let item = title {
            items.append(item)
        }
        if let item = descriptions {
            items.append(item)
        }
        if let productID = productID, item = NSURL(string: "\(Cons.Svr.shareBaseURL)/product?id=\(productID)&targetCurrency=\(userCurrency)") {
            items.append(item)
        }
        Utils.shareItems(items, completion: { () -> Void in
            MBProgressHUD.hideLoader(self.view)
        })
    }
    
    func like(sender: AnyObject) {
        self.product?.doLike({ (likeNumber: NSNumber, isLiked: NSNumber) -> () in
            // Update like color
            self.updateLikeBtnColor(isLiked.boolValue)
            // Update like number
            self.likeBtnNumber = likeNumber.integerValue
        })
    }
    
    func star(sender: AnyObject) {
        UserManager.shared.loginOrDo() { () -> () in
            self.product?.toggleFavorite({ (data: AnyObject?) -> () in
                // Toggle the value of isFavorite
                self.isFavorite = !self.isFavorite
            })
        }
    }
}
