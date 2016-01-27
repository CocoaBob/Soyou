//
//  NewsDetailViewController.swift
//  iPrices
//
//  Created by CocoaBob on 24/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class NewsDetailViewController: UIViewController {
    
    var isEdgeSwiping: Bool = false // Use edge swiping instead of custom animator if interactivePopGestureRecognizer is trigered
    
    // Toolbar
    var btnLike: UIButton?
    let btnLikeActiveColor = UIColor(rgba: Cons.UI.colorLike)
    let btnLikeInactiveColor = UIToolbar.appearance().tintColor
    var btnFav: UIButton?
    let btnFavActiveColor = UIColor(rgba:Cons.UI.colorHeart)
    let btnFavInactiveColor = UIToolbar.appearance().tintColor
    
    // To hide toolbar
    var lastScrollViewOffset: CGFloat = 0
    
    // Status Bar Cover
    var isStatusBarOverlyingCoverImage = true
    let statusBarCover = UIView(frame:
        CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: UIApplication.sharedApplication().statusBarFrame.size.height)
    )
    
    // Data
    var news: BaseNews? {
        didSet {
            self.newsTitle = self.news?.title ?? ""
            self.newsId = self.news?.id as? Int ?? -1
        }
    }
    var headerImage: UIImage?
    var newsTitle: String!
    var newsId: Int!
    var webViewImageURLs: [String] = [String]()
    var webViewPhotos: [IDMPhoto] = [IDMPhoto]()
    
    @IBOutlet var webView: UIWebView?
    var scrollView: UIScrollView? {
        return self.webView?.scrollView
    }
    
    // Class methods
    class func instantiate() -> NewsDetailViewController {
        return UIStoryboard(name: "NewsViewController", bundle: nil).instantiateViewControllerWithIdentifier("NewsDetailViewController") as! NewsDetailViewController
    }
    
    // Lif cycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Hide tabs
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tap gesture
        let tapGR = UITapGestureRecognizer(target: self, action: "tapHandler:")
        tapGR.numberOfTapsRequired = 1
        tapGR.numberOfTouchesRequired = 1
        tapGR.delegate = self
        self.webView?.addGestureRecognizer(tapGR)
        
        // Status Bar Cover
        statusBarCover.backgroundColor = UIColor.whiteColor()
        
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
        
        // Hide navigation bar at beginning for calculating topInset
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Parallax Header
        self.setupParallaxHeader()
        // Fix scroll view insets
        self.updateScrollViewInset(self.webView!.scrollView, self.scrollView?.parallaxHeader.height ?? 0, true, true)
        
        // Load content
        requestNews()
    }
    
    override func viewWillAppear(animated: Bool) {
        // Hide navigation bar if it's visible again
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        
        // Reset isEdgeSwiping to false, if interactive transition is cancelled
        self.isEdgeSwiping = false
        // Make sure interactive gesture's delegate is self in case if interactive transition is cancelled
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        // Update Status Bar Cover
        self.updateStatusBarCover()
        // Show tool bar if it's invisible again
        self.showToolbar(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Set WebView scroll view
        self.scrollView?.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Update Status Bar Cover
        self.removeStatusBarCover()
        // Hide HUD indicator if exists
        MBProgressHUD.hideLoader(self.view)
        // Set WebView scroll view
        self.scrollView?.delegate = nil
        // Remove the corresponding FavoriteNews if it's leaving without favorite status
        DLog(self.navigationController?.viewControllers)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Reset isEdgeSwiping to false, if interactive transition is cancelled
        self.isEdgeSwiping = false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return isStatusBarOverlyingCoverImage ? UIStatusBarStyle.LightContent : UIStatusBarStyle.Default
    }

}

// MARK: Web image tap gesture handler
extension NewsDetailViewController {
    
    func tapHandler(tapGR: UITapGestureRecognizer) {
        guard let webView = self.webView else {
            return
        }
        
        var touchPoint = tapGR.locationInView(self.webView)
        var offset = CGPointZero
        if let xOffset = webView.stringByEvaluatingJavaScriptFromString("window.pageXOffset"),
            yOffset = webView.stringByEvaluatingJavaScriptFromString("window.pageYOffset") {
                offset.x = CGFloat((xOffset as NSString).doubleValue)
                offset.y = CGFloat((yOffset as NSString).doubleValue)
        }
        var windowSize = CGSizeZero
        if let width = webView.stringByEvaluatingJavaScriptFromString("window.innerWidth"),
            height = webView.stringByEvaluatingJavaScriptFromString("window.innerHeight") {
                windowSize.width = CGFloat((width as NSString).doubleValue)
                windowSize.height = CGFloat((height as NSString).doubleValue)
        }
        
        let factor = windowSize.width / CGRectGetWidth(webView.frame)
        touchPoint.x *= factor
        touchPoint.y = (touchPoint.y - webView.scrollView.contentInset.top) * factor
        
        guard let tagName = webView.stringByEvaluatingJavaScriptFromString("document.elementFromPoint(\(touchPoint.x), \(touchPoint.y)).tagName") else {
            return
        }
        
        if "IMG".caseInsensitiveCompare(tagName) == .OrderedSame {
            if let imageURLString: String = webView.stringByEvaluatingJavaScriptFromString("document.elementFromPoint(\(touchPoint.x), \(touchPoint.y)).src"),
                let photoIndex = self.webViewImageURLs.indexOf(imageURLString) {
                    let photoBrowser = IDMPhotoBrowser(photos: self.webViewPhotos)
                    photoBrowser.displayToolbar = true
                    photoBrowser.displayActionButton = true
                    photoBrowser.displayArrowButton = true
                    photoBrowser.displayCounterLabel = true
                    photoBrowser.displayDoneButton = true
                    photoBrowser.usePopAnimation = false
                    photoBrowser.useWhiteBackgroundColor = false
                    photoBrowser.disableVerticalSwipe = false
                    photoBrowser.forceHideStatusBar = false
                    
                    photoBrowser.setInitialPageIndex(UInt(photoIndex))
                    
                    self.presentViewController(photoBrowser, animated: true, completion: nil)
            }
        }
    }
}

// MARK: UIScrollViewDelegate
extension NewsDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Update Status Bar Cover
        self.updateStatusBarCover()
        
        // To hide toolbar
        if (scrollView.contentOffset.y > self.lastScrollViewOffset) {
            // Only if the header+content height is obviously larger than the scrollView height
            if (scrollView.contentInset.top + scrollView.contentSize.height - scrollView.frame.height > 64) {
                self.hideToolbar(true)
                scrollView.contentInset.bottom = 0
                scrollView.scrollIndicatorInsets = scrollView.contentInset
            }
        } else if (scrollView.contentOffset.y < 0) {
            self.showToolbar(true)
            if let toolbar = self.navigationController?.toolbar {
                scrollView.contentInset.bottom = toolbar.frame.size.height
                scrollView.scrollIndicatorInsets = scrollView.contentInset
            }
        }
    }
    
    // To hide toolbar
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (decelerate && scrollView.contentOffset.y < self.lastScrollViewOffset) {
            self.showToolbar(true)
            if let toolbar = self.navigationController?.toolbar {
                scrollView.contentInset.bottom = toolbar.frame.size.height
                scrollView.scrollIndicatorInsets = scrollView.contentInset
            }
        }
    }
    
    // To hide toolbar
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.lastScrollViewOffset = scrollView.contentOffset.y
    }
    
    private func updateStatusBarCover() {
        guard let scrollView = self.scrollView else { return }
        if isStatusBarOverlyingCoverImage && scrollView.contentOffset.y >= 0 {
            isStatusBarOverlyingCoverImage = false
            self.addStatusBarCover()
        } else if !isStatusBarOverlyingCoverImage && scrollView.contentOffset.y < 0 {
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

// MARK: Like button
extension NewsDetailViewController {
    
    private func initLikeBtnAndFavBtn() {
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if let localNews = self.news?.MR_inContext(localContext) {
                if let newsID = localNews.id {
                    DataManager.shared.loadNewsInfo(newsID, { (data: AnyObject?) -> () in
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
extension NewsDetailViewController {
    
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


// MARK: Data
extension NewsDetailViewController {
    
    // Load HTML
    private func loadPageContent(news: BaseNews) {
        if let webView = self.webView, newsContent = news.content, newsTitle = news.title {
            var cssContent: String?
            var htmlContent: String?
            do {
                cssContent = try String(contentsOfFile: NSBundle.mainBundle().pathForResource("news", ofType: "css")!)
                htmlContent = try String(contentsOfFile: NSBundle.mainBundle().pathForResource("news", ofType: "html")!)
            } catch {
                
            }
            if var cssContent = cssContent, var htmlContent = htmlContent {
                cssContent = cssContent.stringByReplacingOccurrencesOfString("__COVER_HEIGHT__", withString: "0")
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__TITLE__", withString: newsTitle)
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__CONTENT__", withString: newsContent)
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__CSS__", withString: cssContent)
                webView.loadHTMLString(htmlContent, baseURL: nil)
            }
        }
    }
    
    private func requestNews(news: BaseNews) {
        // Load HTML
        self.loadPageContent(news)
        
        // Like button
        if let appIsLiked = news.appIsLiked {
            updateLikeBtnColor(appIsLiked.boolValue)
        }
        initLikeBtnAndFavBtn()
        
        // Cover Image
        if let imageURLString = news.image,
            let imageURL = NSURL(string: imageURLString) {
                if !SDWebImageManager.sharedManager().cachedImageExistsForURL(imageURL) {
                    SDWebImageManager.sharedManager().downloadImageWithURL(
                        imageURL,
                        options: [.ContinueInBackground, .AllowInvalidSSLCertificates],
                        progress: { (receivedSize: NSInteger, expectedSize: NSInteger) -> Void in
                            
                        },
                        completed: { (image: UIImage!, error: NSError!, type: SDImageCacheType, finished: Bool, url: NSURL!) -> Void in
                            self.headerImage = image
                            self.setupParallaxHeader()
                            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                                if let localNews = self.news?.MR_inContext(localContext) {
                                    self.loadPageContent(localNews)
                                }
                            })
                        }
                    )
                }
        }
    }
    
    func requestNews() {
        var newsID: NSNumber? = nil
        var needToLoad: Bool = false
        
        self.webView?.loadHTMLString("<html></html>", baseURL: nil)
        
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if let localNews = self.news?.MR_inContext(localContext) {
                if localNews.appIsUpdated == nil || !localNews.appIsUpdated!.boolValue {
                    newsID = localNews.id
                    needToLoad = true
                }
            }
        })
        
        if needToLoad {
            if let newsID = newsID {
                MBProgressHUD.showLoader(self.view)
                DataManager.shared.requestNewsByID(newsID, { () -> () in
                    MBProgressHUD.hideLoader(self.view)
                    MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                        if let localNews = self.news?.MR_inContext(localContext) {
                            self.requestNews(localNews)
                        }
                    })
                })
            }
        } else {
            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                if let localNews = self.news?.MR_inContext(localContext) {
                    self.requestNews(localNews)
                }
            })
        }
    }
}

// MARK: Images
extension NewsDetailViewController {
    
    func loadAllImagesFromWebView(webView: UIWebView) {
        if let imageURLsJSONString = webView.stringByEvaluatingJavaScriptFromString("(function() {var images=document.querySelectorAll(\"img\");var imageUrls=[];[].forEach.call(images, function(el) { imageUrls[imageUrls.length] = el.src;}); return JSON.stringify(imageUrls);})()"),
            let imageURLs = GetObjectFromJSONString(imageURLsJSONString) {
                // All URLs
                self.webViewImageURLs = imageURLs as! [String];
                
                // All IDMPhotos
                var webViewPhotos = [IDMPhoto]()
                for strURL in self.webViewImageURLs {
                    if let imageURL = NSURL(string: strURL) {
                        if let imageResponse = NSURLCache.sharedURLCache().cachedResponseForRequest(NSURLRequest(URL: imageURL)),
                            let image = UIImage(data: imageResponse.data) {
                                webViewPhotos.append(IDMPhoto(image:image))
                        } else {
                            webViewPhotos.append(IDMPhoto(URL: imageURL))
                        }
                    } else {
                        self.webViewImageURLs.removeAtIndex(self.webViewImageURLs.indexOf(strURL)!)
                    }
                }
                self.webViewPhotos = webViewPhotos
        }
    }
}

// MARK: UIWebViewDelegate
extension NewsDetailViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.loadAllImagesFromWebView(webView)
    }
}

// MARK: Parallax Header
extension NewsDetailViewController {
    
    private func setupParallaxHeader() {
        // Image
        guard let image = self.headerImage else { return }
        // Height
        let headerHeight = self.view.bounds.size.width * image.size.height / image.size.width
        // Header View
        let headerView = UIImageView(image: image)
        headerView.contentMode = .ScaleAspectFill
        // Parallax View
        if let scrollView = self.scrollView {
            scrollView.parallaxHeader.height = headerHeight
            scrollView.parallaxHeader.view = headerView
            scrollView.parallaxHeader.mode = .Fill
        }
    }
}

// MARK: UIGestureRecognizerDelegate
extension NewsDetailViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
            self.isEdgeSwiping = true
        }
        return true
    }
}

// MARK: ZoomInteractiveTransition
extension NewsDetailViewController: ZoomTransitionProtocol {
    
    private func imageViewForZoomTransition() -> UIImageView? {
        if let parallaxHeaderView = self.scrollView?.parallaxHeader.view {
            parallaxHeaderView.setNeedsLayout()
            parallaxHeaderView.layoutIfNeeded()
            return parallaxHeaderView as? UIImageView
        }
        return nil
    }
    
    func viewForZoomTransition(isSource: Bool) -> UIView? {
        return self.imageViewForZoomTransition()
    }
    
    func initialZoomViewSnapshotFromProposedSnapshot(snapshot: UIImageView!) -> UIImageView? {
        if let imageView = self.imageViewForZoomTransition() {
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
        return true
    }
}

// MARK: Actions
extension NewsDetailViewController {
    
    func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func share(sender: UIBarButtonItem) {
        if let headerImage = self.headerImage, newsTitle = self.newsTitle, newsID = self.newsId {
            let activityView = UIActivityViewController(
                activityItems: [headerImage, newsTitle, NSURL(string: "\(Cons.Svr.shareBaseURL)/news?id=\(newsID)")!],
                applicationActivities: [WeChatSessionActivity(), WeChatMomentsActivity()])
            activityView.excludedActivityTypes = SharingProvider.excludedActivityTypes
            self.presentViewController(activityView, animated: true, completion: nil)
        }
    }
    
    func like(sender: UIBarButtonItem) {
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if let localNews = self.news?.MR_inContext(localContext) {
                let appIsLiked = localNews.appIsLiked != nil && localNews.appIsLiked!.boolValue
                
                DataManager.shared.likeNews(localNews.id!, wasLiked: appIsLiked, { (data: AnyObject?) -> () in
                    // Update like number
                    if let likeNumber = data as? NSNumber {
                        self.likeBtnNumber = likeNumber.integerValue
                    }
                    
                    // Update like color
                    self.updateLikeBtnColor(!appIsLiked)
                    
                    // Remember if it's liked or not
                    MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                        if let localNews = self.news?.MR_inContext(localContext) {
                            localNews.appIsLiked = NSNumber(bool: !appIsLiked)
                        }
                    })
                })
            }
        })
    }
    
    func star(sender: UIBarButtonItem) {
        if UserManager.shared.isLoggedIn {
            if let isFavorite = self.isFavorite {
                MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                    if let localNews = self.news?.MR_inContext(localContext) {
                        DataManager.shared.favoriteNews(localNews.id!, wasFavorite: isFavorite,
                            { (data: AnyObject?) -> () in
                                // Toggle the value of isFavorite
                                self.isFavorite = !isFavorite
                        })
                    }
                })
            }
        } else {
            let loginViewController = LoginViewController.instantiate(.Login)
            let navC = UINavigationController(rootViewController: loginViewController)
            self.presentViewController(navC, animated: true, completion: nil)
        }
    }
}