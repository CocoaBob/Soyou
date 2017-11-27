//
//  ProductViewController.swift
//  Soyou
//
//  Created by CocoaBob on 03/01/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

protocol ProductViewControllerDelegate {
    
    func getNextProduct(_ currentIndex: Int?) -> (Int?, Product?)?
    func didShowNextProduct(_ product: Product, index: Int)
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
    
    // Toolbar
    var btnLike: UIButton?
    var btnFav: UIButton?
    var btnComment: UIButton = UIButton(type: .system)
    
    // Status bar cover
    var isStatusBarCoverVisible = false
    let statusBarCover = UIView(frame:
        CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: UIApplication.shared.statusBarFrame.height)
    )
    
    // Class methods
    class func instantiate() -> ProductViewController {
        return UIStoryboard(name: "ProductsViewController", bundle: nil).instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
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
        self.statusBarCover.backgroundColor = UIColor.white
        
        // Toolbar
        self.btnLike = UIButton(type: .system)
        self.btnFav = UIButton(type: .system)
        
        self.btnLike?.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        self.btnLike?.titleEdgeInsets = UIEdgeInsets(top: -20, left: -0, bottom: 1, right: 0)
        self.btnLike?.backgroundColor = UIColor.clear
        self.btnLike?.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        self.btnLike?.setImage(UIImage(named: "img_thumb"), for: .normal)
        self.btnLike?.imageEdgeInsets = UIEdgeInsets(top: -1, left: -0, bottom: 1, right: 0) // Adjust image position
        self.btnLike?.addTarget(self, action: #selector(ProductViewController.like(_:)), for: .touchUpInside)
        
        self.btnFav?.backgroundColor = UIColor.clear
        self.btnFav?.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        self.btnFav?.setImage(UIImage(named: "img_heart"), for: .normal)
        self.btnFav?.imageEdgeInsets = UIEdgeInsets(top: -1, left: -0, bottom: 1, right: 0) // Adjust image position
        self.btnFav?.addTarget(self, action: #selector(ProductViewController.star(_:)), for: .touchUpInside)
        
        self.btnComment.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        self.btnComment.titleLabel?.layer.cornerRadius = 3
        self.btnComment.titleLabel?.clipsToBounds = true
        self.btnComment.setTitleColor(UIColor.white, for: .normal)
        self.btnComment.titleEdgeInsets = UIEdgeInsets(top: -20, left: 0, bottom: 1, right: 0)
        self.btnComment.backgroundColor = UIColor.clear
        self.btnComment.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        self.btnComment.setImage(UIImage(named: "img_comments"), for: .normal)
        self.btnComment.addTarget(self, action: #selector(InfoDetailBaseViewController.comment(_:)), for: .touchUpInside)
        self.btnComment.titleLabel?.backgroundColor = Cons.UI.colorComment
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let next = UIBarButtonItem(image: UIImage(named:"img_arrow_down"), style: .plain, target: self, action: #selector(ProductViewController.next(_:)))
        let fav = UIBarButtonItem(customView: self.btnFav!)
        let like = UIBarButtonItem(customView: self.btnLike!)
        let comment = UIBarButtonItem(customView: self.btnComment)
        self.toolbarItems = [ space, next, space, fav, space, like, space, comment, space]
        let _ = self.toolbarItems?.map() { $0.width = 64 }
        
        next.isEnabled = false
        self.nextProductBarButtonItem = next
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.scrollView, 0, true, false, false, false)
        
        // Load content
        self.loadProduct(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        // Like/Comment
        self.updateExtraInfo()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeStatusBarCover()
        // Make sure interactive gesture's delegate is nil before disappearing
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // Update Status Bar Cover
        self.removeStatusBarCover()
        // Reset isEdgeSwiping to false, if interactive transition is cancelled
        self.isEdgeSwiping = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
}

// MARK: Load products
extension ProductViewController {
    
    func loadProduct(_ isNext: Bool) {
        // Setup images for carousel View
        self.setupCarouselView()
        // SubViewControllers
        self.setupSubViewControllers(isNext)
        // Favorite button status
        self.isFavorite = self.product?.isFavorite() ?? false
        // Like/Comment
        self.updateExtraInfo()
        // Prepare next product
        if let (index, product) = self.delegate?.getNextProduct(self.productIndex) {
            self.nextProductIndex = index
            self.nextProduct = product
        } else {
            self.nextProductIndex = nil
            self.nextProduct = nil
        }
        // Next button status
        self.nextProductBarButtonItem?.isEnabled = self.nextProduct != nil
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
            self.view.layer .add(transition, forKey: "transition")
            self.delegate?.didShowNextProduct(nextProduct, index: self.productIndex ?? 0)
        }
    }
}

// MARK: Status Bar Cover
extension ProductViewController: UIScrollViewDelegate {
    
    fileprivate func addStatusBarCover() {
        isStatusBarCoverVisible = true
        self.tabBarController?.view.addSubview(self.statusBarCover)
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
            self.statusBarCover.alpha = 1
        })
    }
    
    fileprivate func removeStatusBarCover() {
        isStatusBarCoverVisible = false
        UIView.animate(withDuration: 0.25, animations: { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
            self.statusBarCover.alpha = 0
            }, completion: { (finished) -> Void in
                self.statusBarCover.removeFromSuperview()
        })
    }
}

// MARK: Carousel View
extension ProductViewController {
    
    fileprivate func setupCarouselView() {
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
            guard let localProduct = self.product?.mr_(in: localContext) else { return }
            images = localProduct.images as? [String]
            title = localProduct.title
        })
        let imageViewFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: carouselViewHeight)
        if let images = images {
            // Reset self.photos
            self.photos = Array(repeating: IDMPhoto(), count: images.count)
            // Add 1st image
            if let firstImage = self.firstImage {
                // ImageView for Carousel
                let firstImageView = UIImageView(frame: imageViewFrame)
                firstImageView.contentMode = .scaleAspectFit
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
                    if let imageURL = URL(string: imageURLString) {
                        // Photo for IDMPhotoBrowser
                        self.photos[index] = IDMPhoto(url: imageURL)
                        // ImageView for Carousel
                        let placeholder = UIImage(named: "img_placeholder_1_1_m")
                        let imageView = UIImageView(frame: imageViewFrame)
                        imageView.contentMode = .scaleAspectFit
                        imageView.sd_setImage(with: imageURL,
                                              placeholderImage: placeholder,
                                              options: [.continueInBackground, .allowInvalidSSLCertificates],
                                              completed: { (image, error, cacheType, url) -> Void in
                                                if let photo = IDMPhoto(image: image ?? placeholder) {
                                                    self.photos[index] = photo
                                                }
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
            self.carouselView.textLabel.font = UIFont.boldSystemFont(ofSize: 17)
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
    
    func setupSubViewControllers(_ isNext: Bool) {
        guard let product = self.product else { return }
        
        // Add page menu to the scroll view's subViewsContainer
        if self.pageMenu == nil {
            // Prepare childViewControllers
            var viewControllers = [UIViewController]()
            // Prices VC
            self.productPricesViewController.productViewController = self
            self.productPricesViewController.title = NSLocalizedString("product_prices_vc_title")
            self.productPricesViewController.view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
            viewControllers.append(self.productPricesViewController)
            
            // Descriptions VC
            self.productDescriptionsViewController.productViewController = self
            self.productDescriptionsViewController.title = NSLocalizedString("product_descriptions_vc_title")
            self.productDescriptionsViewController.webViewHeightDelegate = self
            self.productDescriptionsViewController.view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
            
            viewControllers.append(self.productDescriptionsViewController)
            
            // Customize menu (Optional)
            let parameters: [CAPSPageMenuOption] = [
                .menuItemSeparatorWidth(0),
                .scrollMenuBackgroundColor(UIColor.white),
                .selectionIndicatorColor(UIColor.darkGray),
                .selectedMenuItemLabelColor(UIColor.darkGray),
                .unselectedMenuItemLabelColor(UIColor.lightGray),
                .useMenuLikeSegmentedControl(true),
                .centerMenuItems(true),
                .menuItemFont(UIFont.systemFont(ofSize: 13)),
                .menuMargin(10.0),
                .menuHeight(Cons.UI.heightPageMenuProduct),
                .addBottomMenuHairline(true),
                .bottomMenuHairlineColor(UIColor.white)
            ]
            
            // Create CAPSPageMenu
            self.pageMenu = CAPSPageMenu(
                viewControllers: viewControllers,
                frame: CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height),
                pageMenuOptions: parameters)
            
            // Add CAPSPageMenu
            if let pageMenu = self.pageMenu {
                pageMenu.view.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleWidth]
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

    func webView(_ webView: UIWebView, didChangeHeight height: CGFloat) {
        descriptionViewHeight = height
        self.updateViewsContainerHeight(true)
    }
    
    func updateViewsContainerHeight(_ animated: Bool) {
        let pricesViewHeight = self.productPricesViewController.tableView.contentSize.height
        let descriptionsViewHeight = descriptionViewHeight
        let maxHeight = max(descriptionsViewHeight, pricesViewHeight)
        self.viewsContainerHeight?.constant = maxHeight + Cons.UI.heightPageMenuProduct + 20 // Bottom margin 20
        self.view.setNeedsLayout()
        if animated {
            UIView.animate(withDuration: 0.3) { () -> Void in
                self.view.layoutIfNeeded()
            }
        } else {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: PFCarouselView
extension ProductViewController: PFCarouselViewDelegate {
    
    func numberOfPages(in carouselView: PFCarouselView!) -> Int {
        return self.imageViews.count
    }
    
    func carouselView(_ carouselView: PFCarouselView!, setupContentViewAt index: Int) -> UIView! {
        let imageView = self.imageViews[index]
        imageView.frame = carouselView.bounds
        return imageView
    }
    
    func carouselView(_ carouselView: PFCarouselView!, didSelectViewAt index: Int) {
        let imageView = self.imageViews[index]
        IDMPhotoBrowser.present(self.photos, index: UInt(index), view: imageView, scaleImage: imageView.image, viewVC: self)
    }
}

// MARK: UIGestureRecognizerDelegate
extension ProductViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
            self.isEdgeSwiping = true
        }
        return true
    }
}

// MARK: ZoomInteractiveTransition
extension ProductViewController: ZoomTransitionProtocol {
    
    func view(forZoomTransition isSource: Bool) -> UIView? {
        return self.imageViews.first
    }
    
    func initialZoomViewSnapshot(fromProposedSnapshot snapshot: UIImageView!) -> UIImageView? {
        if (!self.imageViews.isEmpty) {
            let imageView = self.imageViews[0]
            let returnImageView = UIImageView(image: imageView.image)
            returnImageView.contentMode = imageView.contentMode
            returnImageView.clipsToBounds = imageView.clipsToBounds
            return returnImageView
        }
        return nil
    }
    
    func shouldAllowZoomTransition(for operation: UINavigationControllerOperation, from fromVC: UIViewController!, to toVC: UIViewController!) -> Bool {
        // No zoom transition when edge swiping
        if self.isEdgeSwiping {
            return false
        }
        // Only available for opening a product from products view controller
        if ((operation == .push && fromVC is ProductsViewController && toVC === self) ||
            (operation == .pop && fromVC === self && toVC is ProductsViewController)) {
                return true
        }
        return false
    }
}

// MARK: Like button
extension ProductViewController {
    
    fileprivate func updateExtraInfo() {
        self.product?.managedObjectContext?.runBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if let localProduct = self.product?.mr_(in: localContext) {
                // Update like number
                guard let productID = localProduct.id else { return }
                DataManager.shared.requestProductInfo("\(productID)") { responseObject, error in
                    if let responseObject = responseObject as? [String:AnyObject],
                        let data = responseObject["data"] as? [String:AnyObject] {
                        let json = JSON(data)
                        self.likeBtnNumber = json["likeNumber"].int
//                        let isFavorite = json["isFavorite"].boolValue
                        self.commentBtnNumber = json["commentNumber"].int
                        self.updateLikeBtnColor(json["isLiked"].boolValue)
                    }
                }
                
                // Update like button color
                let diskContext = NSManagedObjectContext.mr_default()
                diskContext.performAndWait({
                    guard let diskProduct = Product.mr_findFirst(byAttribute: "id", withValue: productID, in: diskContext) else { return }
                    self.updateLikeBtnColor(diskProduct.appIsLiked?.boolValue)
                })
            }
        })
    }
    
    fileprivate func updateLikeBtnColor(_ isLiked: Bool?) {
        DispatchQueue.main.async {
            self.btnLike?.tintColor = (isLiked ?? false) ? Cons.UI.colorLike : UIToolbar.appearance().tintColor
        }
    }
    
    fileprivate var likeBtnNumber: Int? {
        set(newValue) {
            if newValue != nil && newValue! > 0 {
                self.btnLike?.setTitle("\(newValue!)", for: .normal)
            } else {
                self.btnLike?.setTitle("", for: .normal)
            }
        }
        get {
            if let title = self.btnLike?.title(for: .normal) {
                return Int(title)
            } else {
                return 0
            }
        }
    }
}

// MARK: Fav button
extension ProductViewController {
    
    fileprivate var isFavorite: Bool {
        set(newValue) {
            DispatchQueue.main.async {
                self.btnFav?.setImage(UIImage(named: newValue ? "img_heart_selected" : "img_heart"), for: .normal)
                self.btnFav?.tintColor = newValue ? Cons.UI.colorHeart : UIToolbar.appearance().tintColor
            }
        }
        get {
            return self.btnFav?.tintColor == Cons.UI.colorHeart
        }
    }
}

// MARK: Comment button
extension ProductViewController {
    
    var commentBtnNumber: Int? {
        set(newValue) {
            if newValue != nil && newValue! >= 0 {
                self.btnComment.setTitle(" \(newValue!) ", for: .normal)
            } else {
                self.btnComment.setTitle("", for: .normal)
            }
        }
        get {
            if let title = self.btnComment.title(for: .normal) {
                return Int(title)
            } else {
                return 0
            }
        }
    }
}

// MARK: Actions
extension ProductViewController {
    
    @IBAction func back(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func next(_ sender: AnyObject) {
        self.loadNextProduct()
    }
    
    @IBAction func share(_ sender: AnyObject) {
        MBProgressHUD.show(self.view)
        
        var productID: String?
        var title: String?
        var htmlString: String?
        let userCurrency = CurrencyManager.shared.userCurrency
        
        self.product?.managedObjectContext?.runBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            let localProduct = self.product?.mr_(in: localContext)
            // If there's no SKU
            if let oldID = localProduct?.id {
                productID = "\(oldID)"
            }
            // If SKU exists, use SKU
            if let objectData = localProduct?.sku,
                let object = Utils.decrypt(objectData) as? String {
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
            let htmlData = htmlString.data(using: String.Encoding.utf8) {
                do {
                    let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                                   NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)] as [NSAttributedString.DocumentReadingOptionKey : Any]
                    let attributedString = try NSAttributedString(data: htmlData,
                                                                  options: options,
                                                                  documentAttributes: nil)
                    var contentString = attributedString.string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    if contentString.count > 256 {
                        contentString = String(contentString[..<contentString.index(contentString.startIndex, offsetBy: 256)])
                    }
                    descriptions = contentString
                } catch {
                    
                }
        }
        
        // Title
        if let strTitle = title {
            if strTitle.count > 128 {
                title = String(strTitle[..<strTitle.index(strTitle.startIndex, offsetBy: 128)])
            }
        }
        
        var items = [Any]()
        if let item = self.imageViews.first?.image {
            items.append(item)
        }
        if let item = title {
            items.append(item as AnyObject)
        }
        if let item = descriptions {
            items.append(item as AnyObject)
        }
        if let productID = productID, let item = URL(string: "\(Cons.Svr.shareBaseURL)/product?id=\(productID)&targetCurrency=\(userCurrency)") {
            items.append(item)
        }
        Utils.shareItems(items, completion: { () -> Void in
            MBProgressHUD.hide(self.view)
        })
    }
    
    @objc func like(_ sender: AnyObject) {
        self.product?.doLike({ (likeNumber: NSNumber, isLiked: NSNumber) -> () in
            // Update like color
            self.updateLikeBtnColor(isLiked.boolValue)
            // Update like number
            self.likeBtnNumber = likeNumber.intValue
        })
    }
    
    @objc func star(_ sender: AnyObject) {
        UserManager.shared.loginOrDo() { () -> () in
            self.product?.toggleFavorite({ (data: Any?) -> () in
                // Toggle the value of isFavorite
                self.isFavorite = !self.isFavorite
            })
        }
    }
    
    @objc func comment(_ sender: AnyObject) {
        self.product?.managedObjectContext?.runBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            let localProduct = self.product?.mr_(in: localContext)
            guard let productID = localProduct?.id else { return }
            let commentsViewController = InfoCommentsViewController.instantiate()
            commentsViewController.infoID = productID
            commentsViewController.dataProvider = { (relativeID: Int?, completion: @escaping ((_ data: Any?) -> ())) -> () in
                DataManager.shared.requestCommentsForProduct(productID, Cons.Svr.commentRequestSize, relativeID as NSNumber?, { (data: Any?, error: NSError?) in
                    completion(data)
                })
            }
            commentsViewController.commentCreator = { (id: NSNumber, commentId: NSNumber, comment: String, completion: @escaping CompletionClosure) -> () in
                DataManager.shared.createCommentForProduct(id, commentId, comment, completion)
            }
            self.navigationController?.pushViewController(commentsViewController, animated: true)
        })
    }
}
