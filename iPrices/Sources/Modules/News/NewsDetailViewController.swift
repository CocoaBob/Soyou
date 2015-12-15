//
//  NewsDetailViewController.swift
//  iPrices
//
//  Created by CocoaBob on 24/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class NewsDetailViewController: UIViewController {
    var news: News?
    var image: UIImage?
    var newsTitle: String!
    var newsId: Int!
    var btnLike: UIButton?
    
    var webView: UIWebView?
    var scrollView: UIScrollView? {
        return self.webView?.scrollView
    }
    
    init(news: News?, image: UIImage?) {
        self.news = news
        self.image = image

        self.newsTitle = self.news?.title
        self.newsId = self.news?.id as! Int
            
        super.init(nibName: nil, bundle: nil)
        
        // Hide tabs
        self.hidesBottomBarWhenPushed = true
    }
    
    convenience init() {
        self.init(news: nil, image: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        super.loadView()
        
        self.webView = UIWebView(frame: self.view.bounds)
        self.view = self.webView!
        
        let tapGR = UITapGestureRecognizer(target: self, action: "tapHandler:")
        tapGR.numberOfTapsRequired = 1
        tapGR.numberOfTouchesRequired = 1
        tapGR.delegate = self
        self.webView?.addGestureRecognizer(tapGR)
        
        if let image = self.image {
            self.webView?.scrollView.addTwitterCoverWithImage(image, coverHeight: 200, noBlur: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fix scroll view insets
        self.updateScrollViewInset(self.webView!.scrollView, toolbarIsVisible: true)
        
        // Toolbar
        self.btnLike = UIButton(type: .System)
        self.toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: ""),
            UIBarButtonItem(image: UIImage(named:"img_share"), style: .Plain, target: self, action: "share:"),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: ""),
            UIBarButtonItem(customView: self.btnLike!),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: ""),
            UIBarButtonItem(image: UIImage(named:"img_heart"), style: .Plain, target: self, action: "star:"),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: "")]
        
        self.btnLike?.titleEdgeInsets = UIEdgeInsetsMake(-20, -0, 1, 0)
        self.btnLike?.backgroundColor = UIColor.clearColor()
        self.btnLike?.frame = CGRectMake(0, 0, 64, 32)
        self.btnLike?.setImage(UIImage(named: "img_thumb"), forState: .Normal)
        self.btnLike?.imageEdgeInsets = UIEdgeInsetsMake(-1, -0, 1, 0) // Adjust image position
        self.btnLike?.addTarget(self, action: "like:", forControlEvents: .TouchUpInside)
        
        // Load content
        loadNews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.showToolbar()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animateAlongsideTransition({ (context) -> Void in
            self.webView?.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, 9999)
            }, completion: nil);
    }

}

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
            if let cssContent = cssContent, var htmlContent = htmlContent {
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
        
        // Update like number
        if let likeNumber = news.likeNumber {
            self.btnLike?.setTitle((likeNumber.integerValue > 0) ? "\(likeNumber)" : "", forState: .Normal)
        }
    }
    
    private func loadNewsData(newsData: NSDictionary?, inContext context: NSManagedObjectContext?) {
        guard let newsData = newsData else { return }
        
        let loadNewsDataClosure: (NSDictionary, NSManagedObjectContext) -> () = { (newsData, context) -> () in
            if let news = News.importData(newsData, context) {
                self.loadNews(news);
            }
        }
        
        if let context = context {
            loadNewsDataClosure(newsData, context)
        } else {
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                loadNewsDataClosure(newsData, localContext)
            })
        }
    }
    
    private func handleRequestNewsSuccess(responseObject: AnyObject?) {
        guard let responseObject = responseObject as? Dictionary<String, AnyObject> else { return }
        let newsData = responseObject["data"] as? NSDictionary
        self.loadNewsData(newsData, inContext: nil)
    }
    
    private func handleRequestNewsError(error: NSError?) {
        print("\(error)")
    }
    
    func loadNews() {
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if let localNews = self.news?.MR_inContext(localContext) {
                if localNews.content != nil {
                    self.loadNews(localNews)
                } else {
                    if let newsID = localNews.id {
                        ServerManager.shared.requestNews("\(newsID)",
                            { (responseObject: AnyObject?) -> () in self.handleRequestNewsSuccess(responseObject) },
                            { (error: NSError?) -> () in self.handleRequestNewsError(error) }
                        );
                    }
                }
            }
        })
    }
    
}

// MARK: - RMPZoomTransitionAnimating/RMPZoomTransitionDelegate
extension NewsDetailViewController: RMPZoomTransitionAnimating, RMPZoomTransitionDelegate {
    
    func imageViewFrame() -> CGRect {
        if let fgImageView = self.webView?.scrollView.twitterCoverView {
            return fgImageView.convertRect(fgImageView.bounds, toView: self.view.window)
        }
        return CGRectZero
    }
    
    func transitionSourceImageView() -> UIImageView! {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.userInteractionEnabled = false
        imageView.contentMode = .ScaleAspectFill
        imageView.frame = imageViewFrame()
        imageView.image = self.webView?.scrollView.twitterCoverView!.image
        return imageView
    }
    
    func transitionSourceBackgroundColor() -> UIColor! {
        return self.view.backgroundColor
    }
    
    func transitionDestinationImageViewFrame() -> CGRect {
        return imageViewFrame()
    }
    
    func zoomTransitionAnimator(animator: RMPZoomTransitionAnimator!, didCompleteTransition didComplete: Bool, animatingSourceImageView imageView: UIImageView!) {
        
    }
}

// MARK: Actions
extension NewsDetailViewController {
    
    func share(sender: UIBarButtonItem) {
        let activityView = UIActivityViewController(
            activityItems: [self.image!, self.newsTitle!, NSURL(string: "\(Cons.Svr.shareBaseURL)/news?id=\(self.newsId)")!],
            applicationActivities: [WeChatSessionActivity(), WeChatMomentsActivity()])
        self.presentViewController(activityView,
            animated: true,
            completion: nil)
    }
    
    private func likeSuccessHandler(responseObject: AnyObject?) {
        guard let responseObject = responseObject as? Dictionary<String, AnyObject> else { return }
        if let likeNumber = responseObject["data"] as? Int {
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                if let localNews = self.news?.MR_inContext(localContext) {
                    self.loadNewsData(["id": localNews.id!, "likeNumber": likeNumber], inContext: nil)
                }
            })
        }
    }
    
    func like(sender: UIBarButtonItem) {
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if let localNews = self.news?.MR_inContext(localContext) {
                if localNews.isLiked == nil || localNews.isLiked!.boolValue {
                    localNews.isLiked = NSNumber(bool: false)
                    self.loadNewsData(["id": localNews.id!, "likeNumber": localNews.likeNumber!.integerValue - 1], inContext: nil)
                    
                    // TODO: Send request to -1
                } else {
                    localNews.isLiked = NSNumber(bool: true)
                    self.loadNewsData(["id": localNews.id!, "likeNumber": localNews.likeNumber!.integerValue + 1], inContext: nil)
                    
                    // Send request to +1
                    ServerManager.shared.likeNews(localNews.id!,
                        { (responseObject: AnyObject?) -> () in self.likeSuccessHandler(responseObject) },
                        { (error: NSError?) -> () in self.handleRequestNewsError(error) })
                }
            }
        })
    }
    
    func star(sender: UIBarButtonItem) {
        print("\(__FUNCTION__)")
    }

}