//
//  ProductViewController.swift
//  Soyou
//
//  Created by CocoaBob on 03/01/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

class ProductViewController: UIViewController {
    
    // Properties
    var isEdgeSwiping: Bool = false // Use edge swiping instead of custom animator if interactivePopGestureRecognizer is trigered
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var subViewsContainer: UIView!
    @IBOutlet var carouselView: PFCarouselView!
    @IBOutlet var carouselViewHeight: NSLayoutConstraint?
    @IBOutlet var viewsContainerHeight: NSLayoutConstraint?
    
    var product: Product?
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
    let btnLikeActiveColor = UIColor(rgba: Cons.UI.colorLike)
    let btnLikeInactiveColor = UIToolbar.appearance().tintColor
    var btnFav: UIButton?
    let btnFavActiveColor = UIColor(rgba:Cons.UI.colorHeart)
    let btnFavInactiveColor = UIToolbar.appearance().tintColor
    
    // Status bar cover
    var isStatusBarCoverVisible = false
    let statusBarCover = UIView(frame:
        CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: UIApplication.sharedApplication().statusBarFrame.size.height)
    )
    
    // Class methods
    class func instantiate() -> ProductViewController {
        return UIStoryboard(name: "ProductsViewController", bundle: nil).instantiateViewControllerWithIdentifier("ProductViewController") as! ProductViewController
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
        statusBarCover.backgroundColor = UIColor.whiteColor()
        
        // Carousel View
        self.setupCarouselView()
        // Fix scroll view insets
        self.updateScrollViewInset(self.scrollView, 0, true, false, false, false)
        // SubViewControllers
        self.setupSubViewControllers()
        
        // Toolbar
        self.btnLike = UIButton(type: .System)
        self.btnFav = UIButton(type: .System)
        
        self.btnLike?.titleLabel?.font = UIFont.systemFontOfSize(10)
        self.btnLike?.titleEdgeInsets = UIEdgeInsetsMake(-20, -0, 1, 0)
        self.btnLike?.backgroundColor = UIColor.clearColor()
        self.btnLike?.frame = CGRectMake(0, 0, 64, 32)
        self.btnLike?.setImage(UIImage(named: "img_thumb"), forState: .Normal)
        self.btnLike?.imageEdgeInsets = UIEdgeInsetsMake(-1, -0, 1, 0) // Adjust image position
        self.btnLike?.addTarget(self, action: "like:", forControlEvents: .TouchUpInside)
        
        self.btnFav?.backgroundColor = UIColor.clearColor()
        self.btnFav?.frame = CGRectMake(0, 0, 64, 32)
        self.btnFav?.setImage(UIImage(named: "img_heart"), forState: .Normal)
        self.btnFav?.imageEdgeInsets = UIEdgeInsetsMake(-1, -0, 1, 0) // Adjust image position
        self.btnFav?.addTarget(self, action: "star:", forControlEvents: .TouchUpInside)
        
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: "")
        let back = UIBarButtonItem(image: UIImage(named:"img_nav_back"), style: .Plain, target: self, action: "back:")
        let like = UIBarButtonItem(customView: self.btnLike!)
        let fav = UIBarButtonItem(customView: self.btnFav!)
        let share = UIBarButtonItem(image: UIImage(named:"img_share"), style: .Plain, target: self, action: "share:")
        (back.width, share.width, like.width, fav.width) = (64, 64, 64, 64)
        
        self.toolbarItems = [ space, back, space, like, space, fav, space, share, space]
        
        // Load content
        updateLikeNumber()
        self.isFavorite = self.product?.isFavorite() ?? false
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
        self.updateStatusBarCover()
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

// MARK: Status Bar Cover
extension ProductViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.updateStatusBarCover()
    }
    
    private func updateStatusBarCover() {
        if !isStatusBarCoverVisible && self.scrollView.contentOffset.y >= 0 {
            self.addStatusBarCover()
        } else if isStatusBarCoverVisible && self.scrollView.contentOffset.y < 0 {
            self.removeStatusBarCover()
        }
    }
    
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
        UIView.animateWithDuration(0.25, animations:
            { () -> Void in
                self.setNeedsStatusBarAppearanceUpdate()
                self.statusBarCover.alpha = 0
            }, completion:
            { (finished) -> Void in
                self.statusBarCover.removeFromSuperview()
            }
        )
    }
}

// MARK: Carousel View
extension ProductViewController {
    
    private func setupCarouselView() {
        // Update the frame of carousel view
        let carouselViewHeight = self.view.frame.size.width / self.carouselViewRatio
        self.carouselViewHeight?.constant = carouselViewHeight
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        // Prepare data
        self.imageViews.removeAll()
        var images: [String]?
        var title: String?
        if let product = self.product {
            MagicalRecord.saveWithBlockAndWait { (localContext: NSManagedObjectContext!) -> Void in
                guard let localProduct = product.MR_inContext(localContext) else { return }
                images = localProduct.images as? [String]
                title = localProduct.title
            }
        }
        let imageViewFrame = CGRectMake(0, 0, self.view.frame.size.width, carouselViewHeight)
        if let images = images {
            // Add 1st image
            if let firstImage = self.firstImage {
                // ImageView for Carousel
                let firstImageView = UIImageView(frame: imageViewFrame)
                firstImageView.contentMode = .ScaleAspectFit
                firstImageView.image = firstImage
                self.imageViews.append(firstImageView)
                // Photo for IDMPhotoBrowser
                self.photos.append(IDMPhoto(image: firstImage))
            } else {
                self.firstImage = nil
            }
            // Add other images
            if self.firstImage == nil || images.count > 1 {
                let restImages = (self.firstImage != nil) ? Array(images[1..<images.count]) : images
                for imageURLString in restImages {
                    if let imageURL = NSURL(string: imageURLString) {
                        // ImageView for Carousel
                        let imageView = UIImageView(frame: imageViewFrame)
                        imageView.contentMode = .ScaleAspectFit
                        imageView.sd_setImageWithURL(
                            imageURL,
                            placeholderImage: UIImage(named: "img_placeholder_1_1_m"),
                            options: [.ContinueInBackground, .AllowInvalidSSLCertificates],
                            completed: { (image, error, cacheType, url) -> Void in
                                if image == nil {
                                    return
                                }
                                for (index, photo) in self.photos.enumerate() {
                                    if photo.underlyingImage() == nil && photo.photoURL == url {
                                        self.photos[index] = IDMPhoto(image: image)
                                        return
                                    }
                                }
                        })
                        self.imageViews.append(imageView)
                        // Photo for IDMPhotoBrowser
                        self.photos.append(IDMPhoto(URL: imageURL))
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
            self.carouselView.textString = title;
            self.carouselView.textInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        } else {
            self.carouselView.textLabelShow = false
        }
        self.carouselView.refresh()
    }
    
}

// MARK: Sub View Controllers
extension ProductViewController {
    
    func setupSubViewControllers() {
        guard let product = self.product else { return }
        var hasPrices = true
        // Prepare childViewControllers
        var viewControllers = [UIViewController]()
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            guard let localProduct = product.MR_inContext(localContext) else { return }
            // Prices VC
            self.productPricesViewController.productViewController = self
            self.productPricesViewController.title = NSLocalizedString("product_prices_vc_title")
            self.productPricesViewController.prices = localProduct.prices as? [[String: AnyObject]]
            self.productPricesViewController.view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
            viewControllers.append(self.productPricesViewController)
            // Descriptions VC
            self.productDescriptionsViewController.productViewController = self
            self.productDescriptionsViewController.title = NSLocalizedString("product_descriptions_vc_title")
            self.productDescriptionsViewController.descriptions = localProduct.descriptions
            self.productDescriptionsViewController.surname = localProduct.surname
            self.productDescriptionsViewController.brand = localProduct.brandLabel
            self.productDescriptionsViewController.reference = localProduct.reference
            self.productDescriptionsViewController.dimension = localProduct.dimension
            self.productDescriptionsViewController.id = localProduct.id
            self.productDescriptionsViewController.webViewHeightDelegate = self
            self.productDescriptionsViewController.view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
            viewControllers.append(self.productDescriptionsViewController)
            // Check if prices is empty
            if localProduct.prices == nil || (localProduct.prices as? [[String: AnyObject]])!.count == 0 {
                hasPrices = false
            }
        })
        
        // Customize menu (Optional)
        let parameters: [CAPSPageMenuOption] = [
            .MenuItemSeparatorWidth(0),
            .ScrollMenuBackgroundColor(UIColor.whiteColor()),
            .SelectionIndicatorColor(UIColor.darkGrayColor()),
            .SelectedMenuItemLabelColor(UIColor.darkGrayColor()),
            .UnselectedMenuItemLabelColor(UIColor.lightGrayColor()),
            .UseMenuLikeSegmentedControl(true),
            .CenterMenuItems(true),
            .MenuItemFont(UIFont.systemFontOfSize(13)),
            .MenuMargin(10.0),
            .MenuHeight(self.pageMenuHeight),
            .AddBottomMenuHairline(true),
            .BottomMenuHairlineColor(UIColor.whiteColor())
        ]
        
        // Load views
        for viewController in viewControllers {
            let _ = viewController.view
        }
        
        // Add page menu to the scroll view's subViewsContainer
        self.pageMenu = CAPSPageMenu(
            viewControllers: viewControllers,
            frame: CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height),
            pageMenuOptions: parameters)
        if let pageMenu = self.pageMenu  {
            pageMenu.view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
            self.subViewsContainer.addSubview(pageMenu.view)
            pageMenu.view.frame = CGRectMake(0, 0, self.subViewsContainer.frame.size.width, self.subViewsContainer.frame.size.height)
        }
        
        // Update height
        self.updateViewsContainerHeight(false)
        
        // Preselect sub view
        if !hasPrices {
            self.pageMenu?.moveToPage(1)
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
        if (self.imageViews.count > 0) {
            let imageView = self.imageViews[0]
            let returnImageView = UIImageView(image: imageView.image)
            returnImageView.contentMode = imageView.contentMode
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
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if let localProduct = self.product?.MR_inContext(localContext) {
                self.updateLikeBtnColor(localProduct.appIsLiked?.boolValue)
                if let productID = localProduct.id {
                    DataManager.shared.requestProductInfo("\(productID)") { responseObject, error in
                        guard let data = responseObject?["data"] else { return }
                        
                        if let likeNumber = data?["likeNumber"] as? NSNumber {
                            self.likeBtnNumber = likeNumber.integerValue
                        }
                    }
                }
            }
        })
    }
    
    private func updateLikeBtnColor(appIsLiked: Bool?) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if appIsLiked != nil && appIsLiked!.boolValue {
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
    
    func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func share(sender: UIBarButtonItem) {
        var productID: NSNumber?
        var title: String?
        
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            let localProduct = self.product?.MR_inContext(localContext)
            productID = localProduct?.id
            title = localProduct?.title
        })
        
        if let image = self.imageViews.first?.image, productID = productID {
            let activityView = UIActivityViewController(
                activityItems: [image, title ?? "", NSURL(string: "\(Cons.Svr.shareBaseURL)/product?id=\(productID)")!],
                applicationActivities: [WeChatSessionActivity(), WeChatMomentsActivity()])
            activityView.excludedActivityTypes = SharingProvider.excludedActivityTypes
            self.presentViewController(activityView, animated: true, completion: nil)
        }
    }
    
    func like(sender: UIBarButtonItem) {
        self.product?.doLike({ (data: AnyObject?) -> () in
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                if let localProduct = self.product?.MR_inContext(localContext) {
                    // Update like color
                    self.updateLikeBtnColor(localProduct.appIsLiked?.boolValue)
                    // Update like number
                    if let likeNumber = data as? NSNumber {
                        self.likeBtnNumber = likeNumber.integerValue
                    }
                }
            })
        })
    }
    
    func star(sender: UIBarButtonItem) {
        UserManager.shared.loginOrDo() { () -> () in
            self.product?.toggleFavorite({ (data: AnyObject?) -> () in
                // Toggle the value of isFavorite
                self.isFavorite = !self.isFavorite
            })
        }
    }
}