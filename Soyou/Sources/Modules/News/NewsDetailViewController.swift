//
//  NewsDetailViewController.swift
//  Soyou
//
//  Created by CocoaBob on 24/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

protocol NewsDetailViewControllerDelegate {
    
    func getNextNews(currentIndex: Int?) -> (Int?, BaseNews?)?
    func didShowNextNews(news: BaseNews, index: Int)
}

class NewsDetailViewController: UIViewController {
    
    // For next product
    var delegate: NewsDetailViewControllerDelegate?
    var nextNewsBarButtonItem: UIBarButtonItem?
    var newsIndex: Int?
    var nextNews: BaseNews?
    var nextNewsIndex: Int?
    
    // Properties
    var isEdgeSwiping: Bool = false // Use edge swiping instead of custom animator if interactivePopGestureRecognizer is trigered
    
    // Toolbar
    var btnLike: UIButton?
    let btnLikeActiveColor = UIColor(hex: Cons.UI.colorLike)
    let btnLikeInactiveColor = UIToolbar.appearance().tintColor
    var btnFav: UIButton?
    let btnFavActiveColor = UIColor(hex:Cons.UI.colorHeart)
    let btnFavInactiveColor = UIToolbar.appearance().tintColor
    
    // Status Bar Cover
    var isStatusBarCoverVisible = false
    let statusBarCover = UIView(frame:
        CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.width, height: UIApplication.sharedApplication().statusBarFrame.height)
    )
    
    // Data
    var news: BaseNews? {
        didSet {
            self.newsTitle = self.news?.title ?? ""
            self.newsID = self.news?.id as? Int ?? -1
        }
    }
    var headerImage: UIImage?
    var newsTitle: String!
    var newsID: NSNumber!
    var webViewImageURLs: [String] = [String]()
    var webViewPhotos: [IDMPhoto] = [IDMPhoto]()
    
    @IBOutlet var webView: UIWebView?
    var scrollView: UIScrollView? {
        return self.webView?.scrollView
    }
    
    // Class methods
    class func instantiate() -> NewsDetailViewController {
        return (UIStoryboard(name: "NewsViewController", bundle: nil).instantiateViewControllerWithIdentifier("NewsDetailViewController") as? NewsDetailViewController)!
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
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(NewsDetailViewController.tapHandler(_:)))
        tapGR.numberOfTapsRequired = 1
        tapGR.numberOfTouchesRequired = 1
        tapGR.delegate = self // shouldRecognizeSimultaneouslyWithGestureRecognizer
        self.webView?.addGestureRecognizer(tapGR)
        
        // Status Bar Cover
        statusBarCover.backgroundColor = UIColor.whiteColor()
        
        // Toolbar
        self.btnLike = UIButton(type: .System)
        self.btnFav = UIButton(type: .System)
        
        self.btnLike?.titleLabel?.font = UIFont.systemFontOfSize(10)
        self.btnLike?.titleEdgeInsets = UIEdgeInsets(top: -20, left: -0, bottom: 1, right: 0)
        self.btnLike?.backgroundColor = UIColor.clearColor()
        self.btnLike?.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        self.btnLike?.setImage(UIImage(named: "img_thumb"), forState: .Normal)
        self.btnLike?.imageEdgeInsets = UIEdgeInsets(top: -1, left: -0, bottom: 1, right: 0) // Adjust image position
        self.btnLike?.addTarget(self, action: #selector(NewsDetailViewController.like(_:)), forControlEvents: .TouchUpInside)
        
        self.btnFav?.backgroundColor = UIColor.clearColor()
        self.btnFav?.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        self.btnFav?.setImage(UIImage(named: "img_heart"), forState: .Normal)
        self.btnFav?.imageEdgeInsets = UIEdgeInsets(top: -1, left: -0, bottom: 1, right: 0) // Adjust image position
        self.btnFav?.addTarget(self, action: #selector(NewsDetailViewController.star(_:)), forControlEvents: .TouchUpInside)
        
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: Selector())
        let next = UIBarButtonItem(image: UIImage(named:"img_arrow_down"), style: .Plain, target: self, action: #selector(ProductViewController.next(_:)))
        let fav = UIBarButtonItem(customView: self.btnFav!)
        let like = UIBarButtonItem(customView: self.btnLike!)
        self.toolbarItems = [ space, next, space, fav, space, like, space]
        let _ = self.toolbarItems?.map() { $0.width = 64 }
        
        next.enabled = false
        self.nextNewsBarButtonItem = next

        // Fix scroll view insets
        self.updateScrollViewInset(self.webView!.scrollView, self.scrollView?.parallaxHeader.height ?? 0, false, false, true, false)
        
        // Load content
        self.loadNews()
    }
    
    override func viewWillAppear(animated: Bool) {
        // Hide navigation bar if it's visible again
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        // Reset isEdgeSwiping to false, if interactive transition is cancelled
        self.isEdgeSwiping = false
        // Make sure interactive gesture's delegate is self in case if interactive transition is cancelled
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        // Show tool bar if it's invisible again
        self.showToolbar(animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Update Status Bar Cover
        self.updateStatusBarCover()
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
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Reset isEdgeSwiping to false, if interactive transition is cancelled
        self.isEdgeSwiping = false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return isStatusBarCoverVisible ? UIStatusBarStyle.Default : UIStatusBarStyle.LightContent
    }

}

// MARK: Web image tap gesture handler
extension NewsDetailViewController {
    
    func tapHandler(tapGR: UITapGestureRecognizer) {
        guard let webView = self.webView else {
            return
        }
        
        var touchPoint = tapGR.locationInView(self.webView)
        var offset = CGPoint.zero
        if let xOffset = webView.stringByEvaluatingJavaScriptFromString("window.pageXOffset"),
            yOffset = webView.stringByEvaluatingJavaScriptFromString("window.pageYOffset") {
                offset.x = CGFloat((xOffset as NSString).doubleValue)
                offset.y = CGFloat((yOffset as NSString).doubleValue)
        }
        var windowSize = CGSize.zero
        if let width = webView.stringByEvaluatingJavaScriptFromString("window.innerWidth"),
            height = webView.stringByEvaluatingJavaScriptFromString("window.innerHeight") {
                windowSize.width = CGFloat((width as NSString).doubleValue)
                windowSize.height = CGFloat((height as NSString).doubleValue)
        }
        
        let factor = windowSize.width / webView.frame.width
        touchPoint.x *= factor
        touchPoint.y = (touchPoint.y - webView.scrollView.contentInset.top) * factor
        
        guard let tagName = webView.stringByEvaluatingJavaScriptFromString("document.elementFromPoint(\(touchPoint.x), \(touchPoint.y)).tagName") else {
            return
        }
        
        if "IMG".caseInsensitiveCompare(tagName) == .OrderedSame {
            if let imageURLString: String = webView.stringByEvaluatingJavaScriptFromString("document.elementFromPoint(\(touchPoint.x), \(touchPoint.y)).src"),
                photoIndex = self.webViewImageURLs.indexOf(imageURLString) {
                    IDMPhotoBrowser.present(self.webViewPhotos, index: UInt(photoIndex), view: nil, scaleImage: nil, viewVC: self)
            }
        }
    }
}

// MARK: Status Bar Cover
extension NewsDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Update Status Bar Cover
        self.updateStatusBarCover()
    }
    
    private func updateStatusBarCover() {
        guard let scrollView = self.scrollView else { return }
        if !isStatusBarCoverVisible && scrollView.contentOffset.y >= 0 {
            self.addStatusBarCover()
        } else if isStatusBarCoverVisible && scrollView.contentOffset.y < 0 {
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
        UIView.animateWithDuration(0.25, animations: { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
            self.statusBarCover.alpha = 0
            }, completion: { (finished) -> Void in
                self.statusBarCover.removeFromSuperview()
        })
    }
}

// MARK: Like button
extension NewsDetailViewController {
    
    private func updateLikeNumber() {
        DataManager.shared.requestNewsInfo(self.newsID) { responseObject, error in
            if let responseObject = responseObject as? [String:AnyObject],
                data = responseObject["data"] as? [String:AnyObject],
                likeNumber = data["likeNumber"] as? NSNumber {
                self.likeBtnNumber = likeNumber.integerValue
            }
        }
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
    
    private var isFavorite: Bool {
        set(newValue) {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if newValue == true {
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
            if var cssContent = cssContent,
                htmlContent = htmlContent {
                cssContent = cssContent.stringByReplacingOccurrencesOfString("__COVER_HEIGHT__", withString: "0")
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__TITLE__", withString: newsTitle)
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__CONTENT__", withString: newsContent)
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__CSS__", withString: cssContent)
                webView.loadHTMLString(htmlContent, baseURL: nil)
            }
        }
    }
    
    private func loadNews(news: BaseNews, context: NSManagedObjectContext) {
        // Load HTML
        self.loadPageContent(news)
        
        // Like button
        updateLikeBtnColor(news.isLiked())
        updateLikeNumber()
        
        // Favorite button
        self.isFavorite = news.isFavorite()
        
        // Cover Image
        if (self.headerImage == nil) {
            if let imageURLString = news.image, imageURL = NSURL(string: imageURLString) {
                let imageManager = SDWebImageManager.sharedManager()
                let cacheKey = imageManager.cacheKeyForURL(imageURL)
                var cachedImage: UIImage? = imageManager.imageCache.imageFromMemoryCacheForKey(cacheKey)
                if cachedImage == nil {
                    cachedImage = imageManager.imageCache.imageFromDiskCacheForKey(cacheKey)
                }
                if let cachedImage = cachedImage {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.headerImage = cachedImage
                        self.setupParallaxHeader()
                    }
                } else {
                    SDWebImageManager.sharedManager().downloadImageWithURL(
                        imageURL,
                        options: [.ContinueInBackground, .AllowInvalidSSLCertificates],
                        progress: { (receivedSize: NSInteger, expectedSize: NSInteger) -> Void in
                            
                        },
                        completed: { (image: UIImage!, error: NSError!, type: SDImageCacheType, finished: Bool, url: NSURL!) -> Void in
                            dispatch_async(dispatch_get_main_queue()) {
                                self.headerImage = image
                                self.setupParallaxHeader()
                            }
                            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                                if let localNews = self.news?.MR_inContext(localContext) {
                                    self.loadPageContent(localNews)
                                }
                            })
                    })
                }
            }
        }
    }
    
    func loadNews() {
        var needToLoad: Bool = false
        
        self.webView?.loadHTMLString("<html></html>", baseURL: nil)
        
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if let localNews = self.news?.MR_inContext(localContext) {
                if localNews.appIsUpdated == nil || !localNews.appIsUpdated!.boolValue {
                    needToLoad = true
                }
            }
        })
        
        if needToLoad {
            MBProgressHUD.showLoader(self.view)
            DataManager.shared.requestNewsByID(self.newsID) { responseObject, error in
                MBProgressHUD.hideLoader(self.view)
                if let responseObject = responseObject {
                    if let data = DataManager.getResponseData(responseObject) as? NSDictionary {
                        if self.news is News {
                            News.importData(data, true, nil)
                        } else if self.news is FavoriteNews {
                            FavoriteNews.importData(data, true, nil)
                        }
                    }
                    MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                        if let localNews = self.news?.MR_inContext(localContext) {
                            self.loadNews(localNews, context: localContext)
                        }
                    })
                }
            }
        } else {
            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                if let localNews = self.news?.MR_inContext(localContext) {
                    self.loadNews(localNews, context: localContext)
                }
            })
        }
        
        // Parallax Header
        self.setupParallaxHeader()
        
        // Prepare next news
        if let (index, news) = self.delegate?.getNextNews(self.newsIndex) {
            self.nextNewsIndex = index
            self.nextNews = news
        } else {
            self.nextNewsIndex = nil
            self.nextNews = nil
        }
        // Next button status
        self.nextNewsBarButtonItem?.enabled = self.nextNews != nil
    }
    
    func loadNextNews() {
        if let nextNews = self.nextNews {
            self.news = nextNews
            self.headerImage = nil
            self.newsIndex = self.nextNewsIndex
            self.loadNews()
            self.delegate?.didShowNextNews(nextNews, index: self.newsIndex ?? 0)
        }
    }
}

// MARK: Images
extension NewsDetailViewController {
    
    func loadAllImagesFromWebView(webView: UIWebView) {
        if let imageURLsJSONString = webView.stringByEvaluatingJavaScriptFromString("(function() {var images=document.querySelectorAll(\"img\");var imageUrls=[];[].forEach.call(images, function(el) { imageUrls[imageUrls.length] = el.src;}); return JSON.stringify(imageUrls);})()"),
            imageURLs = GetObjectFromJSONString(imageURLsJSONString) {
                // All URLs
                if let imageURLs = imageURLs as? [String] {
                    self.webViewImageURLs = imageURLs
                }
                
                // All IDMPhotos
                var webViewPhotos = [IDMPhoto]()
                for strURL in self.webViewImageURLs {
                    if let imageURL = NSURL(string: strURL) {
                        if let imageResponse = NSURLCache.sharedURLCache().cachedResponseForRequest(NSURLRequest(URL: imageURL)),
                            image = UIImage(data: imageResponse.data) {
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
        let headerHeight = self.view.bounds.width * image.size.height / image.size.width
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
    
    // To allow UIWebView's tap gesture recognizer work
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIScreenEdgePanGestureRecognizer {
            return false
        }
        return true
    }
    
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
        // Only available for opening/closing a news from/to news view controller
        if ((operation == .Push && fromVC is NewsViewController && toVC === self)) {
            return true
        } else if ((operation == .Pop && fromVC === self && toVC is NewsViewController)) {
            // If parallex header is invisible, no need of the zooming animation
            if let scrollView = self.scrollView {
                if scrollView.contentOffset.y >= 0 {
                    return false
                }
            }
            return true
        }
        return false
    }
}

// MARK: Actions
extension NewsDetailViewController {
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func next(sender: AnyObject) {
        self.loadNextNews()
    }
    
    @IBAction func share(sender: AnyObject) {
        MBProgressHUD.showLoader(self.view)
        
        var htmlString: String?
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if let localNews = self.news?.MR_inContext(localContext) {
                htmlString = localNews.content
            }
        })
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
        var items = [AnyObject]()
        if let item = self.headerImage {
            items.append(item)
        }
        if var item = self.newsTitle {
            if item.characters.count > 128 {
                item = item.substringToIndex(item.startIndex.advancedBy(128))
            }
            items.append(item)
        }
        if let item = self.newsID {
            items.append(item)
        }
        if let item = descriptions {
            items.append(item)
        }
        if let newsID = self.newsID, item = NSURL(string: "\(Cons.Svr.shareBaseURL)/news?id=\(newsID)") {
            items.append(item)
        }
        Utils.shareItems(items, completion: { () -> Void in
            MBProgressHUD.hideLoader(self.view)
        })
    }
    
    func like(sender: AnyObject) {
        self.news?.toggleLike() { (likeNumber: AnyObject?) -> () in
            // Update like number
            if let likeNumber = likeNumber as? NSNumber {
                self.likeBtnNumber = likeNumber.integerValue
            }
            
            // Update like color
            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                let isLiked = self.news?.MR_inContext(localContext)?.isLiked()
                dispatch_async(dispatch_get_main_queue(), {
                    self.updateLikeBtnColor(isLiked)
                })
            })
        }
    }
    
    func star(sender: AnyObject) {
        UserManager.shared.loginOrDo() { () -> () in
            BaseNews.toggleFavorite(self.newsID) { (_) -> () in
                // Toggle the value of isFavorite
                self.isFavorite = !self.isFavorite
            }
        }
    }
}
