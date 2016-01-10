//
//  NewsDetailViewController.swift
//  iPrices
//
//  Created by CocoaBob on 24/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class NewsDetailViewController: UIViewController {
    let btnActiveColor = UIColor(rgba:"#10ABFE")
    let btnInactiveColor = UIToolbar.appearance().tintColor
    var coverHeight:CGFloat = 200.0
    
    // Used only when no internet connection
    var likeBtnToggle: Bool = false
    
    var isStatusBarOverlyingCoverImage = true
    let statusBarCover = UIView(frame:
        CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.size.width, height: UIApplication.sharedApplication().statusBarFrame.size.height)
    )
    
    var activityView: UIActivityViewController? {
        if let image = self.image, newsTitle = self.newsTitle, newsID = self.newsId {
            let _activityView = UIActivityViewController(
                activityItems: [image, newsTitle, NSURL(string: "\(Cons.Svr.shareBaseURL)/news?id=\(newsID)")!],
                applicationActivities: [WeChatSessionActivity(), WeChatMomentsActivity()])
            _activityView.excludedActivityTypes = SharingProvider.excludedActivityTypes
            return _activityView
        }
        return nil
    }
    
    var news: News? {
        didSet {
            self.newsTitle = self.news?.title ?? ""
            self.newsId = self.news?.id as? Int ?? -1
        }
    }
    var image: UIImage?
    var newsTitle: String!
    var newsId: Int!
    var btnLike: UIButton?
    var btnFav: UIButton?
    
    @IBOutlet var webView: UIWebView?
    var scrollView: UIScrollView? {
        return self.webView?.scrollView
    }
    
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
        
        // Set WebView scroll delegate
        self.scrollView?.delegate = self
        
        // Twitter cover view
        self.updateTwitterCoverView()
        
        // Status bar
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
        let share = UIBarButtonItem(image: UIImage(named:"img_share"), style: .Plain, target: self, action: "share:")
        let like = UIBarButtonItem(customView: self.btnLike!)
        let fav = UIBarButtonItem(customView: self.btnFav!)
        (back.width, share.width, like.width, fav.width) = (64, 64, 64, 64)
        
        self.toolbarItems = [ space, back, space, share, space, like, space, fav, space]
        
        // Load content
        loadNews()
        
        // Hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Fix scroll view insets
        self.updateScrollViewInset(self.webView!.scrollView, true, true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide navigation bar if it's visible again
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        // Show tool bar if it's invisible again
        self.showToolbar()
        // Update statusbar cover
        self.updateStatusBarCover()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeStatusBarCover()
        MBProgressHUD.hideLoader(self.view)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition( { (context) -> Void in
            self.scrollView?.contentSize = CGSizeMake(self.view.frame.size.width, 9999)
        }, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return isStatusBarOverlyingCoverImage ? UIStatusBarStyle.LightContent : UIStatusBarStyle.Default
    }

}

// MARK: Web image tap gesture handler
extension NewsDetailViewController: UIGestureRecognizerDelegate {
    
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
            if let imageDataBase64: String = webView.stringByEvaluatingJavaScriptFromString(
                "var img = document.elementFromPoint(\(touchPoint.x), \(touchPoint.y));" +
                "var canvas = document.createElement('canvas'); " +
                "var context = canvas.getContext('2d');" +
                "canvas.width = img.naturalWidth;" +
                "canvas.height = img.naturalHeight;" +
                "context.drawImage(img, 0, 0, img.naturalWidth, img.naturalHeight);" +
                "canvas.toDataURL('image/png');"),
                imageData = imageDataBase64.substringFromIndex(imageDataBase64.startIndex.advancedBy(22)).base64DecodedData(),
                image = UIImage(data: imageData)
            {
                let photoBrowser = IDMPhotoBrowser(photos: [IDMPhoto(image:image)])
                photoBrowser.backgroundAlphaMax = 0.7
                photoBrowser.displayActionButton = false
                photoBrowser.displayArrowButton = false
                photoBrowser.displayCounterLabel = false
                photoBrowser.displayDoneButton = false
                photoBrowser.displayToolbar = false
                photoBrowser.usePopAnimation = false
                photoBrowser.useWhiteBackgroundColor = false
                photoBrowser.disableVerticalSwipe = false
                photoBrowser.forceHideStatusBar = true
                self.presentViewController(photoBrowser, animated: true, completion: nil)
                
                let tapGR = UITapGestureRecognizer(target: photoBrowser, action: "doneButtonPressed:")
                tapGR.numberOfTapsRequired = 1
                tapGR.numberOfTouchesRequired = 1
                photoBrowser.view.addGestureRecognizer(tapGR)
            }
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: Status Bar Cover
extension NewsDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.updateStatusBarCover()
    }
    
    private func updateStatusBarCover() {
        guard let scrollView = self.scrollView else { return }
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        if isStatusBarOverlyingCoverImage && scrollView.contentOffset.y >= (coverHeight - statusBarHeight) {
            isStatusBarOverlyingCoverImage = false
            self.addStatusBarCover()
            
        } else if !isStatusBarOverlyingCoverImage && scrollView.contentOffset.y < (coverHeight - statusBarHeight){
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
    
    private func initLikeBtnNumberAndFavBtnStatus() {
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if let localNews = self.news?.MR_inContext(localContext) {
                if let newsID = localNews.id {
                    DataManager.shared.loadNewsInfo("\(newsID)", { (data: AnyObject?) -> () in
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
        self.btnLike?.tintColor = (appIsLiked != nil && appIsLiked!.boolValue) ? btnActiveColor : btnInactiveColor
        self.likeBtnToggle = !likeBtnToggle
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
    
    private func updateFavBtnColor(appIsLiked: Bool?) {
        self.btnFav?.tintColor = (appIsLiked != nil && appIsLiked!.boolValue) ? btnActiveColor : btnInactiveColor
    }
    
    private var isFavorite: Bool? {
        set(newValue) {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if newValue != nil && newValue == true {
                    self.btnFav?.setImage(UIImage(named: "img_heart_selected"), forState: .Normal)
                    self.btnFav?.tintColor = self.btnActiveColor
                } else {
                    self.btnFav?.setImage(UIImage(named: "img_heart"), forState: .Normal)
                    self.btnFav?.tintColor = self.btnInactiveColor
                }
            }
        }
        get {
            return self.btnFav?.tintColor == btnActiveColor
        }
    }
}


// MARK: Data
extension NewsDetailViewController {
    
    // Load HTML
    private func loadPageContent(news: News) {
        if let webView = self.webView, newsContent = news.content, newsTitle = news.title {
            var cssContent: String?
            var htmlContent: String?
            do {
                cssContent = try String(contentsOfFile: NSBundle.mainBundle().pathForResource("news", ofType: "css")!)
                htmlContent = try String(contentsOfFile: NSBundle.mainBundle().pathForResource("news", ofType: "html")!)
            } catch {
                
            }
            if var cssContent = cssContent, var htmlContent = htmlContent {
                cssContent = cssContent.stringByReplacingOccurrencesOfString("__COVER_HEIGHT__", withString: "\(coverHeight)")
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__TITLE__", withString: newsTitle)
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__CONTENT__", withString: newsContent)
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__CSS__", withString: cssContent)
                webView.loadHTMLString(htmlContent, baseURL: nil)
            }
        }
    }
    
    private func loadNews(news: News) {
        // Load HTML
        self.loadPageContent(news)
        
        // Like button
        if let appIsLiked = news.appIsLiked {
            self.likeBtnToggle = !appIsLiked.boolValue
            updateLikeBtnColor(appIsLiked.boolValue)
        }
        initLikeBtnNumberAndFavBtnStatus()
        
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
                            self.image = image
                            self.updateTwitterCoverView()
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
    
    func loadNews() {
        var newsID: NSNumber? = nil
        var needToLoad: Bool = false
        
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
                DataManager.shared.loadNews("\(newsID)", { () -> () in
                    MBProgressHUD.hideLoader(self.view)
                    MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                        if let localNews = self.news?.MR_inContext(localContext) {
                            self.loadNews(localNews)
                        }
                    })
                })
            }
        } else {
            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                if let localNews = self.news?.MR_inContext(localContext) {
                    self.loadNews(localNews)
                }
            })
        }
    }
}

// MARK: Twitter Cover View
extension NewsDetailViewController {
    
    private func updateTwitterCoverView() {
        if let image = self.image {
            self.coverHeight = self.view.bounds.size.width * image.size.height / image.size.width
            self.scrollView?.addTwitterCoverWithImage(image, coverHeight: coverHeight, noBlur: true)
            self.scrollView?.twitterCoverView.noContentInset = true
        }
    }
}

// MARK: ZoomInteractiveTransition
extension NewsDetailViewController: ZoomTransitionProtocol {
    
    func viewForZoomTransition(isSource: Bool) -> UIView? {
        if let twitterCoverView = self.scrollView?.twitterCoverView {
            return twitterCoverView
        }
        return nil
    }
    
    func animationBlockForZoomTransition() -> ZoomAnimationBlock! {
        return { (animatedSnapshot: UIImageView!, sourceView: UIView!, destinationView: UIView!) -> Void in
            animatedSnapshot.transform = CGAffineTransformMakeScale(1.02, 1.02)
        }
    }
    
    func completionBlockForZoomTransition() -> ZoomCompletionBlock! {
        return { (animatedSnapshot: UIImageView!, sourceView: UIView!, destinationView: UIView!, completion: (() -> Void)?) -> Void in
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                animatedSnapshot.transform = CGAffineTransformIdentity
                }, completion: { (Bool) -> Void in
                    if let completion = completion {
                        completion()
                    }
            })
        }
    }
}

// MARK: Actions
extension NewsDetailViewController {
    
    func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func share(sender: UIBarButtonItem) {
        if let activityView = self.activityView {
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
                        DataManager.shared.newsFavorite(localNews.id!, isFavorite: isFavorite,
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