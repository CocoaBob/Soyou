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
    
    // Properties
    var isEdgeSwiping: Bool = false // Use edge swiping instead of custom animator if interactivePopGestureRecognizer is trigered
    
    // Toolbar
    var btnLike: UIButton = UIButton(type: .system)
    var btnFav: UIButton = UIButton(type: .system)
    var btnComment: UIButton = UIButton(type: .system)
    
    // Status Bar Cover
    var isStatusBarCoverVisible = false
    let statusBarCover = UIView(frame:
        CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: Cons.UI.statusBarHeight)
    )
    
    @IBOutlet var webView: UIWebView?
    var scrollView: UIScrollView? {
        return self.webView?.scrollView
    }
    
    // Class methods
    class func instantiate() -> InfoDetailBaseViewController {
        return UIStoryboard(name: "InfoViewController", bundle: nil).instantiateViewController(withIdentifier: "InfoDetailBaseViewController") as! InfoDetailBaseViewController
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
        tapGR.delegate = self // shouldRecognizeSimultaneouslyWith
        self.webView?.addGestureRecognizer(tapGR)
        
        // Status Bar Cover
        self.statusBarCover.backgroundColor = UIColor.white
        
        // Toolbar buttons
        self.btnLike.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        self.btnLike.titleEdgeInsets = UIEdgeInsets(top: -20, left: 0, bottom: 1, right: 0)
        self.btnLike.backgroundColor = UIColor.clear
        self.btnLike.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        self.btnLike.setImage(UIImage(named: "img_thumb"), for: .normal)
        self.btnLike.imageEdgeInsets = UIEdgeInsets(top: -1, left: 0, bottom: 1, right: 0) // Adjust image position
        self.btnLike.addTarget(self, action: #selector(InfoDetailBaseViewController.like(_:)), for: .touchUpInside)
        
        self.btnFav.backgroundColor = UIColor.clear
        self.btnFav.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        self.btnFav.setImage(UIImage(named: "img_heart"), for: .normal)
        self.btnFav.addTarget(self, action: #selector(InfoDetailBaseViewController.star(_:)), for: .touchUpInside)
        
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
        let back = UIBarButtonItem(image: UIImage(named:"img_arrow_left"), style: .plain, target: self, action: #selector(InfoDetailBaseViewController.back(_:)))
        let fav = UIBarButtonItem(customView: self.btnFav)
        let like = UIBarButtonItem(customView: self.btnLike)
        let comment = UIBarButtonItem(customView: self.btnComment)
        let share = UIBarButtonItem(image: UIImage(named:"img_share"), style: .plain, target: self, action: #selector(InfoDetailBaseViewController.share(_:)))
        self.toolbarItems = [ space, back, space, fav, space, like, space, comment, space, share, space]
        let _ = self.toolbarItems?.map() { $0.width = 64 }
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.webView!.scrollView, self.scrollView?.parallaxHeader.height ?? 0, false, false, false, false)
        
        // Load content
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Hide navigation bar if it's visible again
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
        // Reset isEdgeSwiping to false, if interactive transition is cancelled
        self.isEdgeSwiping = false
        // Make sure interactive gesture's delegate is self in case if interactive transition is cancelled
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        // Show tool bar if it's invisible again
        self.showToolbar(animated)
        // Update favorite/like/comments
        self.updateExtraInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Update Status Bar Cover
        self.updateStatusBarCover()
        // Set WebView scroll view
        self.scrollView?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Update Status Bar Cover
        self.removeStatusBarCover()
        // Make sure interactive gesture's delegate is nil before disappearing
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
        // Hide HUD indicator if exists
        MBProgressHUD.hide(self.view)
        // Set WebView scroll view
        self.scrollView?.delegate = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Reset isEdgeSwiping to false, if interactive transition is cancelled
        self.isEdgeSwiping = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return isStatusBarCoverVisible ? UIStatusBarStyle.default : UIStatusBarStyle.lightContent
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
    
    @objc func tapHandler(_ tapGR: UITapGestureRecognizer) {
        guard let webView = self.webView else {
            return
        }
        
        var touchPoint = tapGR.location(in: self.webView)
        var offset = CGPoint.zero
        if let xOffset = webView.stringByEvaluatingJavaScript(from: "window.pageXOffset"),
            let yOffset = webView.stringByEvaluatingJavaScript(from: "window.pageYOffset") {
            offset.x = CGFloat((xOffset as NSString).doubleValue)
            offset.y = CGFloat((yOffset as NSString).doubleValue)
        }
        var windowSize = CGSize.zero
        if let width = webView.stringByEvaluatingJavaScript(from: "window.innerWidth"),
            let height = webView.stringByEvaluatingJavaScript(from: "window.innerHeight") {
            windowSize.width = CGFloat((width as NSString).doubleValue)
            windowSize.height = CGFloat((height as NSString).doubleValue)
        }
        
        let factor = windowSize.width / webView.frame.width
        touchPoint.x *= factor
        touchPoint.y = (touchPoint.y - webView.scrollView.contentInset.top) * factor
        
        guard let tagName = webView.stringByEvaluatingJavaScript(from: "document.elementFromPoint(\(touchPoint.x), \(touchPoint.y)).tagName") else {
            return
        }
        
        if "IMG".caseInsensitiveCompare(tagName) == .orderedSame {
            if let imageURLString: String = webView.stringByEvaluatingJavaScript(from: "document.elementFromPoint(\(touchPoint.x), \(touchPoint.y)).src"),
                let photoIndex = self.webViewImageURLs.index(of: imageURLString) {
                IDMPhotoBrowser.present(self.webViewPhotos, index: UInt(photoIndex), view: nil, scaleImage: nil, viewVC: self)
            }
        }
    }
}

// MARK: Status Bar Cover
extension InfoDetailBaseViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Update Status Bar Cover
        self.updateStatusBarCover()
    }
    
    fileprivate func updateStatusBarCover() {
        guard let scrollView = self.scrollView else { return }
        if !isStatusBarCoverVisible && scrollView.contentOffset.y >= 0 {
            self.addStatusBarCover()
        } else if isStatusBarCoverVisible && scrollView.contentOffset.y < 0 {
            self.removeStatusBarCover()
        }
    }
    
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

// MARK: Fav button
extension InfoDetailBaseViewController {
    
    var isFavorite: Bool {
        set(newValue) {
            DispatchQueue.main.async {
                self.btnFav.setImage(UIImage(named: newValue ? "img_heart_selected" : "img_heart"), for: .normal)
                self.btnFav.tintColor = newValue ? Cons.UI.colorHeart : UIToolbar.appearance().tintColor
            }
        }
        get {
            return self.btnFav.tintColor == Cons.UI.colorHeart
        }
    }
}

// MARK: Like button
extension InfoDetailBaseViewController {
    
    func updateLikeBtnColor(_ isLiked: Bool) {
        DispatchQueue.main.async {
            self.btnLike.tintColor = isLiked ? Cons.UI.colorLike : UIToolbar.appearance().tintColor
        }
    }
    
    var likeBtnIsLiked: Bool {
        return self.btnLike.tintColor == Cons.UI.colorLike
    }
    
    var likeBtnNumber: Int? {
        set(newValue) {
            if newValue != nil && newValue! > 0 {
                self.btnLike.setTitle("\(newValue!)", for: .normal)
            } else {
                self.btnLike.setTitle("", for: .normal)
            }
        }
        get {
            if let title = self.btnLike.title(for: .normal) {
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

// MARK: Data
extension InfoDetailBaseViewController {
    
    @objc func loadData() {
    }
    
    func loadWebView(title: String?, content: String?) {
        if let webView = self.webView, let content = content, let title = title {
            var cssContent: String?
            var htmlContent: String?
            do {
                cssContent = try String(contentsOfFile: Bundle.main.path(forResource: "news", ofType: "css")!)
                htmlContent = try String(contentsOfFile: Bundle.main.path(forResource: "news", ofType: "html")!)
            } catch {
                
            }
            if var cssContent = cssContent,
                var htmlContent = htmlContent {
                cssContent = cssContent.replacingOccurrences(of: "__COVER_HEIGHT__", with: "0")
                htmlContent = htmlContent.replacingOccurrences(of: "__TITLE__", with: title)
                htmlContent = htmlContent.replacingOccurrences(of: "__CONTENT__", with: content)
                htmlContent = htmlContent.replacingOccurrences(of: "__CSS__", with: cssContent)
                webView.loadHTMLString(htmlContent, baseURL: nil)
            }
        }
    }
}

// MARK: Images
extension InfoDetailBaseViewController {
    
    func loadAllImagesFromWebView(_ webView: UIWebView) {
        if let imageURLsJSONString = webView.stringByEvaluatingJavaScript(from: "(function() {var images=document.querySelectorAll(\"img\");var imageUrls=[];[].forEach.call(images, function(el) { imageUrls[imageUrls.length] = el.src;}); return JSON.stringify(imageUrls);})()"),
            let imageURLs = GetObjectFromJSONString(imageURLsJSONString) {
            // All URLs
            if let imageURLs = imageURLs as? [String] {
                self.webViewImageURLs = imageURLs
            }
            
            // All IDMPhotos
            var webViewPhotos = [IDMPhoto]()
            for strURL in self.webViewImageURLs {
                if let imageURL = URL(string: strURL) {
                    if let imageResponse = URLCache.shared.cachedResponse(for: URLRequest(url: imageURL)),
                        let image = UIImage(data: imageResponse.data) {
                        webViewPhotos.append(IDMPhoto(image:image))
                    } else {
                        webViewPhotos.append(IDMPhoto(url: imageURL))
                    }
                } else {
                    self.webViewImageURLs.remove(at: self.webViewImageURLs.index(of: strURL)!)
                }
            }
            self.webViewPhotos = webViewPhotos
        }
    }
}

// MARK: UIWebViewDelegate
extension InfoDetailBaseViewController: UIWebViewDelegate {
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
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
        headerView.contentMode = .scaleAspectFill
        // Parallax View
        if let scrollView = self.scrollView {
            scrollView.parallaxHeader.height = headerHeight
            scrollView.parallaxHeader.view = headerView
            scrollView.parallaxHeader.mode = .fill
        }
    }
}

// MARK: UIGestureRecognizerDelegate
extension InfoDetailBaseViewController: UIGestureRecognizerDelegate {
    
    // To allow UIWebView's tap gesture recognizer work
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIScreenEdgePanGestureRecognizer {
            return false
        }
        return true
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
            self.isEdgeSwiping = true
        }
        return true
    }
}

// MARK: ZoomInteractiveTransition
extension InfoDetailBaseViewController: ZoomTransitionProtocol {
    
    fileprivate func imageViewForZoomTransition() -> UIImageView? {
        if let parallaxHeaderView = self.scrollView?.parallaxHeader.view {
            parallaxHeaderView.setNeedsLayout()
            parallaxHeaderView.layoutIfNeeded()
            return parallaxHeaderView as? UIImageView
        }
        return nil
    }
    
    func view(forZoomTransition isSource: Bool) -> UIView? {
        return self.imageViewForZoomTransition()
    }
    
    func initialZoomViewSnapshot(fromProposedSnapshot snapshot: UIImageView!) -> UIImageView? {
        if let imageView = self.imageViewForZoomTransition() {
            let returnImageView = UIImageView(image: imageView.image)
            returnImageView.contentMode = imageView.contentMode
            return returnImageView
        }
        return nil
    }
    
    func shouldAllowZoomTransition(for operation: UINavigationControllerOperation, from fromVC: UIViewController!, to toVC: UIViewController!) -> Bool {
        // No zoom transition when edge swiping
        if self.isEdgeSwiping {
            return false
        }
        // Only available for opening/closing a news from/to news view controller
        if ((operation == .push && fromVC is InfoViewController && toVC === self)) {
            return true
        } else if ((operation == .pop && fromVC === self && toVC is InfoViewController)) {
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
    
    @IBAction func back(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func share(_ sender: AnyObject) {
        self.share()
    }
    
    @IBAction func like(_ sender: AnyObject) {
        self.like()
    }
    
    @IBAction func star(_ sender: AnyObject) {
        self.star()
    }
    
    @IBAction func comment(_ sender: AnyObject) {
        self.comment()
    }
}
