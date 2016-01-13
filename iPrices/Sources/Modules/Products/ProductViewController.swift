//
//  ProductViewController.swift
//  iPrices
//
//  Created by CocoaBob on 03/01/16.
//  Copyright © 2016 iPrices. All rights reserved.
//

class ProductViewController: UIViewController {
    
    var isEdgeSwiping: Bool = false // Use edge swiping instead of custom animator if interactivePopGestureRecognizer is trigered
    
    @IBOutlet var carouselView: PFCarouselView?
    @IBOutlet var carouselViewHeight: NSLayoutConstraint?
    @IBOutlet var scrollView: UIScrollView?
    
    var product: Product?
    var imageViews: [UIImageView] = [UIImageView]()
    var imageRatio: CGFloat = 1.5 {
        didSet {
            self.carouselViewHeight?.constant = self.view.frame.size.width / imageRatio
        }
    }
    
    // Toolbar
    var btnLike: UIButton?
    let btnLikeActiveColor = UIColor(rgba:"#F21E8C")
    let btnLikeInactiveColor = UIToolbar.appearance().tintColor
    var btnFav: UIButton?
    let btnFavActiveColor = UIColor(rgba:"#FFB751")
    let btnFavInactiveColor = UIToolbar.appearance().tintColor
    
    // Status bar cover
    var isStatusBarOverlyingCoverImage = true
    let statusBarCover = UIView(frame:
        CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: UIApplication.sharedApplication().statusBarFrame.size.height)
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Status bar
        statusBarCover.backgroundColor = UIColor.whiteColor()
        
        // Toolbar
        self.btnLike = UIButton(type: .System)
        self.btnFav = UIButton(type: .System)
        
        self.btnLike?.titleLabel?.font = UIFont.systemFontOfSize(10)
        self.btnLike?.titleEdgeInsets = UIEdgeInsetsMake(-20, -0, 1, 0)
        self.btnLike?.backgroundColor = UIColor.clearColor()
        self.btnLike?.frame = CGRectMake(0, 0, 64, 32)
        self.btnLike?.setImage(UIImage(named: "img_heart"), forState: .Normal)
        self.btnLike?.imageEdgeInsets = UIEdgeInsetsMake(-1, -0, 1, 0) // Adjust image position
        self.btnLike?.addTarget(self, action: "like:", forControlEvents: .TouchUpInside)
        
        self.btnFav?.backgroundColor = UIColor.clearColor()
        self.btnFav?.frame = CGRectMake(0, 0, 64, 32)
        self.btnFav?.setImage(UIImage(named: "img_star"), forState: .Normal)
        self.btnFav?.imageEdgeInsets = UIEdgeInsetsMake(-1, -0, 1, 0) // Adjust image position
        self.btnFav?.addTarget(self, action: "star:", forControlEvents: .TouchUpInside)
        
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: "")
        let back = UIBarButtonItem(image: UIImage(named:"img_nav_back"), style: .Plain, target: self, action: "back:")
        let like = UIBarButtonItem(customView: self.btnLike!)
        let fav = UIBarButtonItem(customView: self.btnFav!)
        let share = UIBarButtonItem(image: UIImage(named:"img_share"), style: .Plain, target: self, action: "share:")
        (back.width, share.width, like.width, fav.width) = (64, 64, 64, 64)
        
        self.toolbarItems = [ space, back, space, like, space, fav, space, share, space]
        
        // Carousel
        self.setupCarouselView()
        // Hide navigation bar at beginning for calculating topInset
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Carousel
        self.carouselView?.resume()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeStatusBarCover()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        // Reset isEdgeSwiping to false, if interactive transition is cancelled
        self.isEdgeSwiping = false
        // Carousel
        self.carouselView?.pause()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return isStatusBarOverlyingCoverImage ? UIStatusBarStyle.LightContent : UIStatusBarStyle.Default
    }
}

// MARK: Status Bar Cover
extension ProductViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.updateStatusBarCover()
    }
    
    private func updateStatusBarCover() {
        guard let scrollView = self.scrollView else { return }
        guard let carouselView = self.carouselView else { return }
        
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        if isStatusBarOverlyingCoverImage && scrollView.contentOffset.y >= (carouselView.frame.size.height - statusBarHeight) {
            isStatusBarOverlyingCoverImage = false
            self.addStatusBarCover()
            
        } else if !isStatusBarOverlyingCoverImage && scrollView.contentOffset.y < (carouselView.frame.size.height - statusBarHeight){
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

// MARK: PFCarouselView
extension ProductViewController: PFCarouselViewDelegate {
    
    private func setupCarouselView() {
        // Setup UI
        if let carouselView = self.carouselView {
            carouselView.duration = 2.0
            carouselView.delegate = self
            carouselView.textLabelShow = false
        }
        if let carouselViewHeight = self.carouselViewHeight {
            carouselViewHeight.constant = self.view.frame.size.width / self.imageRatio
        }
        // Prepare data
        self.imageViews.removeAll()
        var images: [String]?
        if let product = self.product {
            MagicalRecord.saveWithBlockAndWait { (localContext: NSManagedObjectContext!) -> Void in
                let localProduct = product.MR_inContext(localContext)
                images = localProduct.images as? [String]
            }
        }
        if let images = images {
            for imageURLString in images {
                if let imageURL = NSURL(string: imageURLString) {
                    let imageView = UIImageView(frame: CGRectMake(0, 0, 320, 240))
                    imageView.contentMode = .ScaleAspectFit
                    imageView.sd_setImageWithURL(imageURL,
                        placeholderImage: UIImage.imageWithRandomColor(nil),
                        options: [.ContinueInBackground, .AllowInvalidSSLCertificates])
                    self.imageViews.append(imageView)
                }
            }
        }
    }
    
    func numberOfPagesInCarouselView(carouselView: PFCarouselView!) -> Int {
        return self.imageViews.count
    }
    
    func carouselView(carouselView: PFCarouselView!, setupContentViewAtIndex index: Int) -> UIView! {
        let imageView = self.imageViews[index]
        if let carouselView = self.carouselView {
            imageView.frame = carouselView.bounds
        }
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
        return self.carouselView
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

// MARK: Actions
extension ProductViewController {
    
    func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func share(sender: UIBarButtonItem) {
//        if let headerImage = self.headerImage, newsTitle = self.newsTitle, newsID = self.newsId {
//            let activityView = UIActivityViewController(
//                activityItems: [headerImage, newsTitle, NSURL(string: "\(Cons.Svr.shareBaseURL)/news?id=\(newsID)")!],
//                applicationActivities: [WeChatSessionActivity(), WeChatMomentsActivity()])
//            activityView.excludedActivityTypes = SharingProvider.excludedActivityTypes
//            self.presentViewController(activityView, animated: true, completion: nil)
//        }
    }
    
    func like(sender: UIBarButtonItem) {
//        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
//            if let localNews = self.news?.MR_inContext(localContext) {
//                let appIsLiked = localNews.appIsLiked != nil && localNews.appIsLiked!.boolValue
//                
//                DataManager.shared.likeNews(localNews.id!, wasLiked: appIsLiked, { (data: AnyObject?) -> () in
//                    // Update like number
//                    if let likeNumber = data as? NSNumber {
//                        self.likeBtnNumber = likeNumber.integerValue
//                    }
//                    
//                    // Update like color
//                    self.updateLikeBtnColor(!appIsLiked)
//                    
//                    // Remember if it's liked or not
//                    MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
//                        if let localNews = self.news?.MR_inContext(localContext) {
//                            localNews.appIsLiked = NSNumber(bool: !appIsLiked)
//                        }
//                    })
//                })
//            }
//        })
    }
    
    func star(sender: UIBarButtonItem) {
//        if UserManager.shared.isLoggedIn {
//            if let isFavorite = self.isFavorite {
//                MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
//                    if let localNews = self.news?.MR_inContext(localContext) {
//                        DataManager.shared.newsFavorite(localNews.id!, wasFavorite: isFavorite,
//                            { (data: AnyObject?) -> () in
//                                // Toggle the value of isFavorite
//                                self.isFavorite = !isFavorite
//                        })
//                    }
//                })
//            }
//        } else {
//            let loginViewController = UIStoryboard(name: "UserViewController", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController")
//            loginViewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
//                barButtonSystemItem: .Done,
//                target:loginViewController,
//                action: "dismissSelf")
//            let navC = UINavigationController(rootViewController: loginViewController)
//            self.presentViewController(navC, animated: true, completion: nil)
//        }
    }
}