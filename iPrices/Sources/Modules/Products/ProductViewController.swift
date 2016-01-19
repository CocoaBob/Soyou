//
//  ProductViewController.swift
//  iPrices
//
//  Created by CocoaBob on 03/01/16.
//  Copyright © 2016 iPrices. All rights reserved.
//

class ProductViewController: UIViewController {
    
    var isEdgeSwiping: Bool = false // Use edge swiping instead of custom animator if interactivePopGestureRecognizer is trigered
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var subViewsContainer: UIView!

    var product: Product?
    var firstImage: UIImage?
    var imageViews: [UIImageView] = [UIImageView]()
    var imageRatio: CGFloat = 1.1
    
    var productPricesViewController: ProductPricesViewController?
    var productDescriptionsViewController: ProductDescriptionsViewController?
    var descriptionViewHeight: CGFloat = 0
    var viewsContainerHeight: NSLayoutConstraint?
    
    // PageMenu
    var pageMenu: CAPSPageMenu?
    var pageMenuHeight: CGFloat = 30
    
    // Toolbar
    var btnLike: UIButton?
    let btnLikeActiveColor = UIColor(rgba: Cons.UI.colorMain)
    let btnLikeInactiveColor = UIToolbar.appearance().tintColor
    var btnFav: UIButton?
    let btnFavActiveColor = UIColor(rgba:Cons.UI.colorHeart)
    let btnFavInactiveColor = UIToolbar.appearance().tintColor
    
    // Status bar cover
    var isStatusBarOverlyingCoverImage = true
    let statusBarCover = UIView(frame:
        CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: UIApplication.sharedApplication().statusBarFrame.size.height)
    )
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Hide tabs
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Status bar
        statusBarCover.backgroundColor = UIColor.whiteColor()
        
        // Hide navigation bar at beginning for calculating topInset
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Parallax Header & Carousel View
        self.setupParallaxHeader()
        // Fix scroll view insets
        self.updateScrollViewInset(self.scrollView, self.scrollView.parallaxHeader.height ?? 0, false, true)
        self.scrollView.contentInset.bottom = 0 // Workaround: Fix contentInset.bottom...
        self.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero // Workaround: Fix scrollIndicatorInsets...
        self.scrollView.scrollIndicatorInsets.top = UIApplication.sharedApplication().statusBarFrame.size.height
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
        initLikeBtnAndFavBtn()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Reset isEdgeSwiping to false, if interactive transition is cancelled
        self.isEdgeSwiping = false
        // Make sure interactive gesture's delegate is self in case if interactive transition is cancelled
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        // Hide navigation bar if it's visible again
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
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
        return UIStatusBarStyle.Default//isStatusBarOverlyingCoverImage ? UIStatusBarStyle.LightContent : UIStatusBarStyle.Default
    }
}

// MARK: Status Bar Cover
extension ProductViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.updateStatusBarCover()
    }
    
    private func updateStatusBarCover() {
        if isStatusBarOverlyingCoverImage && self.scrollView.contentOffset.y >= 0 {
            isStatusBarOverlyingCoverImage = false
            self.addStatusBarCover()
        } else if !isStatusBarOverlyingCoverImage && self.scrollView.contentOffset.y < 0 {
            isStatusBarOverlyingCoverImage = true
            self.removeStatusBarCover()
        }
    }
    
    private func addStatusBarCover() {
        self.tabBarController?.view.addSubview(self.statusBarCover)
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
            self.statusBarCover.alpha = 1
        })
    }
    
    private func removeStatusBarCover() {
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

// MARK: Parallax Header & Carousel View
extension ProductViewController {
    
    private func setupCarouselView() -> PFCarouselView {
        // Prepare data
        self.imageViews.removeAll()
        var images: [String]?
        var title: String?
        if let product = self.product {
            MagicalRecord.saveWithBlockAndWait { (localContext: NSManagedObjectContext!) -> Void in
                let localProduct = product.MR_inContext(localContext)
                images = localProduct.images as? [String]
                title = localProduct.title
            }
        }
        if let images = images {
            // Add 1st image
            let firstImageView = UIImageView(image: self.firstImage)
            firstImageView.contentMode = .ScaleAspectFit
            self.imageViews.append(firstImageView)
            // Add other images
            if images.count > 1 {
                let count = images.count - 1
                let restImages = Array(images[1..<count])
                for imageURLString in restImages {
                    if let imageURL = NSURL(string: imageURLString) {
                        let imageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width))
                        imageView.contentMode = .ScaleAspectFit
                        imageView.sd_setImageWithURL(imageURL,
                            placeholderImage: UIImage.imageWithRandomColor(nil),
                            options: [.ContinueInBackground, .AllowInvalidSSLCertificates],
                            completed: nil)
                        self.imageViews.append(imageView)
                    }
                }
            }
        }
        
        // Setup UI
        let carouselView = PFCarouselView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width / self.imageRatio))
        carouselView.delegate = self
        if let title = title {
            carouselView.textLabel.numberOfLines = 0
            carouselView.textLabel.font = UIFont.boldSystemFontOfSize(17)
            carouselView.textLabelShow = true
            carouselView.textString = title;
            carouselView.textInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        } else {
            carouselView.textLabelShow = false
        }
        carouselView.refresh()
        
        return carouselView
    }
    
    private func setupParallaxHeader() {
        let carouselView = self.setupCarouselView()
        self.scrollView.parallaxHeader.height = self.view.frame.size.width / self.imageRatio
        self.scrollView.parallaxHeader.view = carouselView
        self.scrollView.parallaxHeader.mode = .Bottom
    }
}

// MARK: Sub View Controllers
extension ProductViewController {
    
    func setupSubViewControllers() {
        guard let product = self.product else { return }
        
        var viewControllers = [UIViewController]()
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            let localProduct = product.MR_inContext(localContext)
            // Prices VC
            self.productPricesViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProductPricesViewController") as? ProductPricesViewController
            if let productPricesViewController = self.productPricesViewController {
                productPricesViewController.title = NSLocalizedString("product_prices_vc_title")
                productPricesViewController.prices = localProduct.prices as? [[String: AnyObject]]
                viewControllers.append(productPricesViewController)
            }
            // Descriptions VC
            self.productDescriptionsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProductDescriptionsViewController") as? ProductDescriptionsViewController
            if let productDescriptionsViewController = self.productDescriptionsViewController {
                productDescriptionsViewController.title = NSLocalizedString("product_descriptions_vc_title")
                productDescriptionsViewController.descriptions = localProduct.descriptions
                productDescriptionsViewController.surname = localProduct.surname
                productDescriptionsViewController.brand = localProduct.brandLabel
                productDescriptionsViewController.reference = localProduct.reference
                productDescriptionsViewController.id = localProduct.id
                productDescriptionsViewController.webViewHeightDelegate = self
                viewControllers.append(productDescriptionsViewController)
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
            // Add the missing height constraint, so the red warning in the InterfaceBuilder will disapplear at running time
            self.viewsContainerHeight = NSLayoutConstraint(
                item: self.subViewsContainer,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1,
                constant: 1000)
            if let constraint = self.viewsContainerHeight {
                self.subViewsContainer.addConstraint(constraint)
            }
            pageMenu.view.frame = CGRectMake(0, 0, self.subViewsContainer.frame.size.width, self.subViewsContainer.frame.size.height)
        }
    }
}

// MARK: Control view height
extension ProductViewController: WebViewHeightDelegate {

    func webView(webView: UIWebView, didChangeHeight height: CGFloat) {
        descriptionViewHeight = height
        self.updateViewsContainerHeight()
    }
    
    func updateViewsContainerHeight() {
        let pricesViewHeight = self.productPricesViewController?.tableView.contentSize.height ?? 0
        let descriptionsViewHeight = descriptionViewHeight
        let maxHeight = max(descriptionsViewHeight, pricesViewHeight)
        self.viewsContainerHeight?.constant = maxHeight + self.pageMenuHeight + 20 // Bottom margin 20
        self.view.setNeedsLayout()
        UIView.animateWithDuration(0.3) { () -> Void in
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
        DLog("")
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
        return self.scrollView.parallaxHeader.view
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
        // No zoom transition from ProductVC to ProductsVC
        if operation == .Push && fromVC === self && toVC is ProductsViewController {
            return false
        }
        
        // No zoom transition when edge swiping
        if self.isEdgeSwiping {
            return false
        }
        return true
    }
}

// MARK: Like button
extension ProductViewController {
    
    private func initLikeBtnAndFavBtn() {
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if let localProduct = self.product?.MR_inContext(localContext) {
                self.updateLikeBtnColor(localProduct.appIsLiked?.boolValue)
                if let productID = localProduct.id {
                    DataManager.shared.loadProductInfo("\(productID)", { (data: AnyObject?) -> () in
                        if let likeNumber = data?["likeNumber"] as? NSNumber {
                            self.likeBtnNumber = likeNumber.integerValue
                        }
                        
                        if let isFavorite = data?["isFavorite"] as? Bool {
                            self.isFavorite = isFavorite
                        }
                    })
                }
            }
        })
    }
    
    private func updateLikeBtnColor(appIsLiked: Bool?) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if appIsLiked != nil && appIsLiked!.boolValue {
                self.btnLike?.setImage(UIImage(named: "img_thumb_selected"), forState: .Normal)
                self.btnLike?.tintColor = self.btnLikeActiveColor
            } else {
                self.btnLike?.setImage(UIImage(named: "img_thumb"), forState: .Normal)
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
    
    private var isFavorite: Bool? {
        set(newValue) {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if newValue != nil && newValue == true {
                    self.btnFav?.setImage(UIImage(named: "img_heart_selected"), forState: .Normal)
                    self.btnFav?.tintColor = self.btnFavActiveColor
                } else {
                    self.btnFav?.setImage(UIImage(named: "img_heart"), forState: .Normal)
                    self.btnFav?.tintColor = self.btnFavInactiveColor
                }
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
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if let localProduct = self.product?.MR_inContext(localContext) {
                if let image = self.firstImage, let id = localProduct.id{
                    let activityView = UIActivityViewController(
                        activityItems: [image, localProduct.title == nil ? "" : localProduct.title!, NSURL(string: "\(Cons.Svr.shareBaseURL)/product?id=\(id)")!], applicationActivities: [WeChatSessionActivity(), WeChatMomentsActivity()])
                    activityView.excludedActivityTypes = SharingProvider.excludedActivityTypes
                    self.presentViewController(activityView, animated: true, completion: nil)}
            }
        })
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
        if UserManager.shared.isLoggedIn {
            if let isFavorite = self.isFavorite {
                MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                    if let localProduct = self.product?.MR_inContext(localContext) {
                        DataManager.shared.productFavorite(localProduct.id!, isFavorite: isFavorite,
                            { (data: AnyObject?) -> () in
                                // Toggle the value of isFavorite
                                self.isFavorite = !isFavorite
                        })
                    }
                })
            }
        } else {
            let loginViewController = UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")
            loginViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .Done,
                target:loginViewController,
                action: "dismissSelf")
            let navC = UINavigationController(rootViewController: loginViewController)
            self.presentViewController(navC, animated: true, completion: nil)
        }
    }
}