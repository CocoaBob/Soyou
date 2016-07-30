//
//  InfoDetailBaseViewController.swift
//  Soyou
//
//  Created by CocoaBob on 02/06/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

class InfoDetailBaseViewController: UIViewController {
    
    // Header/Webview Data
    var headerImage: UIImage?
    var webViewImageURLs: [String] = [String]()
    var webViewPhotos: [IDMPhoto] = [IDMPhoto]()
    
    // Info Data
    var info: AnyObject?
    var infoTitle: String!
    var infoID: NSNumber!
    
    // For next item
    var delegate: SwitchPrevNextItemDelegate?
    var infoIndex: Int?
    var nextInfo: AnyObject?
    var nextInfoIndex: Int?
    var nextInfoBarButtonItem: UIBarButtonItem?
    
    // Properties
    var isEdgeSwiping: Bool = false // Use edge swiping instead of custom animator if interactivePopGestureRecognizer is trigered
    
    // Toolbar
    var btnLike: UIButton = UIButton(type: .System)
    var btnFav: UIButton = UIButton(type: .System)
    var btnComment: UIButton = UIButton(type: .System)
    
    // Status Bar Cover
    var isStatusBarCoverVisible = false
    let statusBarCover = UIView(frame:
        CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.width, height: UIApplication.sharedApplication().statusBarFrame.height)
    )
    
    @IBOutlet var webView: UIWebView?
    var scrollView: UIScrollView? {
        return self.webView?.scrollView
    }
    
    // Class methods
    class func instantiate() -> InfoDetailBaseViewController {
        return (UIStoryboard(name: "InfoViewController", bundle: nil).instantiateViewControllerWithIdentifier("InfoDetailBaseViewController") as? InfoDetailBaseViewController)!
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
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(InfoDetailBaseViewController.tapHandler(_:)))
        tapGR.numberOfTapsRequired = 1
        tapGR.numberOfTouchesRequired = 1
        tapGR.delegate = self // shouldRecognizeSimultaneouslyWithGestureRecognizer
        self.webView?.addGestureRecognizer(tapGR)
        
        // Status Bar Cover
        self.statusBarCover.backgroundColor = UIColor.whiteColor()
        
        // Toolbar buttons
        self.btnLike.titleLabel?.font = UIFont.systemFontOfSize(10)
        self.btnLike.titleEdgeInsets = UIEdgeInsets(top: -20, left: 0, bottom: 1, right: 0)
        self.btnLike.backgroundColor = UIColor.clearColor()
        self.btnLike.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        self.btnLike.setImage(UIImage(named: "img_thumb"), forState: .Normal)
        self.btnLike.imageEdgeInsets = UIEdgeInsets(top: -1, left: 0, bottom: 1, right: 0) // Adjust image position
        self.btnLike.addTarget(self, action: #selector(InfoDetailBaseViewController.like(_:)), forControlEvents: .TouchUpInside)
        
        self.btnFav.backgroundColor = UIColor.clearColor()
        self.btnFav.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        self.btnFav.setImage(UIImage(named: "img_heart"), forState: .Normal)
        self.btnFav.addTarget(self, action: #selector(InfoDetailBaseViewController.star(_:)), forControlEvents: .TouchUpInside)
        
        self.btnComment.titleLabel?.font = UIFont.systemFontOfSize(10)
        self.btnComment.titleLabel?.layer.cornerRadius = 3
        self.btnComment.titleLabel?.clipsToBounds = true
        self.btnComment.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.btnComment.titleEdgeInsets = UIEdgeInsets(top: -20, left: 0, bottom: 1, right: 0)
        self.btnComment.backgroundColor = UIColor.clearColor()
        self.btnComment.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        self.btnComment.setImage(UIImage(named: "img_comments"), forState: .Normal)
        self.btnComment.addTarget(self, action: #selector(InfoDetailBaseViewController.comment(_:)), forControlEvents: .TouchUpInside)
        self.btnComment.titleLabel?.backgroundColor = UIColor(rgba:Cons.UI.colorComment)
        
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: Selector())
        let next = UIBarButtonItem(image: UIImage(named:"img_arrow_down"), style: .Plain, target: self, action: #selector(ProductViewController.next(_:)))
        let fav = UIBarButtonItem(customView: self.btnFav)
        let like = UIBarButtonItem(customView: self.btnLike)
        let comment = UIBarButtonItem(customView: self.btnComment)
        self.toolbarItems = [ space, next, space, fav, space, like, space, comment, space]
        let _ = self.toolbarItems?.map() { $0.width = 64 }
        
        // Setup next button
        next.enabled = false
        self.nextInfoBarButtonItem = next
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.webView!.scrollView, self.scrollView?.parallaxHeader.height ?? 0, false, false, true, false)
        
        // Load content
        self.loadData()
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
        // Make sure interactive gesture's delegate is nil before disappearing
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        // Hide HUD indicator if exists
        MBProgressHUD.hideLoader(self.view)
        // Set WebView scroll view
        self.scrollView?.delegate = nil
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Reset isEdgeSwiping to false, if interactive transition is cancelled
        self.isEdgeSwiping = false
        
        // Update favorite/like/comments
        self.updateExtraInfo()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return isStatusBarCoverVisible ? UIStatusBarStyle.Default : UIStatusBarStyle.LightContent
    }
    
    // For subclasses
    // MARK: Extra info like likeNumber, isFavorite, commentNumber
    func updateExtraInfo() {}
    
    // MARK: Bar button items
    func share() {}
    func like() {}
    func star() {}
    func comment() {}
}

// MARK: Web image tap gesture handler
extension InfoDetailBaseViewController {
    
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
extension InfoDetailBaseViewController: UIScrollViewDelegate {
    
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

// MARK: Fav button
extension InfoDetailBaseViewController {
    
    var isFavorite: Bool {
        set(newValue) {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                if newValue == true {
                    self.btnFav.setImage(UIImage(named: "img_heart_selected"), forState: .Normal)
                    self.btnFav.tintColor = UIColor(rgba:Cons.UI.colorHeart)
                } else {
                    self.btnFav.setImage(UIImage(named: "img_heart"), forState: .Normal)
                    self.btnFav.tintColor = UIToolbar.appearance().tintColor
                }
            }
        }
        get {
            return self.btnFav.tintColor == UIColor(rgba:Cons.UI.colorHeart)
        }
    }
}

// MARK: Like button
extension InfoDetailBaseViewController {
    
    func updateLikeBtnColor(appIsLiked: Bool?) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if appIsLiked != nil && appIsLiked!.boolValue {
                self.btnLike.tintColor = UIColor(rgba: Cons.UI.colorLike)
            } else {
                self.btnLike.tintColor = UIToolbar.appearance().tintColor
            }
        }
    }
    
    var likeBtnNumber: Int? {
        set(newValue) {
            if newValue != nil && newValue! > 0 {
                self.btnLike.setTitle("\(newValue!)", forState: .Normal)
            } else {
                self.btnLike.setTitle("", forState: .Normal)
            }
        }
        get {
            if let title = self.btnLike.titleForState(.Normal) {
                return Int(title)
            } else {
                return 0
            }
        }
    }
}

// MARK: Comment button
extension InfoDetailBaseViewController {
    
    var commentBtnNumber: Int? {
        set(newValue) {
            if newValue != nil && newValue! >= 0 {
                self.btnComment.setTitle(" \(newValue!) ", forState: .Normal)
            } else {
                self.btnComment.setTitle("", forState: .Normal)
            }
        }
        get {
            if let title = self.btnComment.titleForState(.Normal) {
                return Int(title)
            } else {
                return 0
            }
        }
    }
}

// MARK: Data
extension InfoDetailBaseViewController {
    
    func loadData() {
    }
    
    func loadNextData() {
        if let nextInfo = self.nextInfo {
            self.info = nextInfo
            self.headerImage = nil
            self.infoIndex = self.nextInfoIndex
            self.loadData()
            let transition = CATransition()
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromTop
            self.view.layer .addAnimation(transition, forKey: "transition")
            self.delegate?.didShowItem(NSIndexPath(forRow: self.infoIndex ?? 0, inSection: 0), isNext: true)
        }
    }
    
    func loadWebView(title title: String?, content: String?) {
        if let webView = self.webView, content = content, title = title {
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
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__TITLE__", withString: title)
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__CONTENT__", withString: content)
                htmlContent = htmlContent.stringByReplacingOccurrencesOfString("__CSS__", withString: cssContent)
                webView.loadHTMLString(htmlContent, baseURL: nil)
            }
        }
    }
}

// MARK: Images
extension InfoDetailBaseViewController {
    
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
extension InfoDetailBaseViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.loadAllImagesFromWebView(webView)
    }
}

// MARK: Parallax Header
extension InfoDetailBaseViewController {
    
    func setupParallaxHeader() {
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
extension InfoDetailBaseViewController: UIGestureRecognizerDelegate {
    
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
extension InfoDetailBaseViewController: ZoomTransitionProtocol {
    
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
        if ((operation == .Push && fromVC is InfoViewController && toVC === self)) {
            return true
        } else if ((operation == .Pop && fromVC === self && toVC is InfoViewController)) {
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
extension InfoDetailBaseViewController {
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func next(sender: AnyObject) {
        self.loadNextData()
    }
    
    @IBAction func share(sender: AnyObject) {
        self.share()
    }
    
    @IBAction func like(sender: AnyObject) {
        self.like()
    }
    
    @IBAction func star(sender: AnyObject) {
        self.star()
    }
    
    @IBAction func comment(sender: AnyObject) {
        self.comment()
    }
}
