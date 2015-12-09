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
    
    var webView: UIWebView?
    var scrollView: UIScrollView? {
        return self.webView?.scrollView
    }
    
    init(news: News?, image: UIImage?) {
        self.news = news
        self.image = image
        super.init(nibName: nil, bundle: nil)
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
        
        // Load content
        loadNews()
        
        // Toolbar
        self.toolbarItems = [
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: ""),
            UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: nil, action: ""),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: ""),
            UIBarButtonItem(barButtonSystemItem: .Organize, target: nil, action: ""),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: ""),
            UIBarButtonItem(barButtonSystemItem: .Action, target: nil, action: ""),
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: "")]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.showToolbar()
        self.hideTabBar(true)
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
    
    private func handleSuccess(responseObject: AnyObject?) {
        guard let responseObject = responseObject as? Dictionary<String, AnyObject> else { return }
        let newsData = responseObject["data"] as? NSDictionary
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            News.importData(newsData, localContext)
            
            if let localNews = self.news?.MR_inContext(localContext) {
                if localNews.content != nil {
                    self.loadPageContent(localNews)
                }
            }
        })
    }
    
    private func handleError(error: NSError?) {
        print("\(error)")
    }
    
    func loadNews() {
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if let localNews = self.news?.MR_inContext(localContext) {
                
                if localNews.content != nil {
                    self.loadPageContent(localNews)
                } else {
                    if let newsID = localNews.id {
                        ServerManager.shared.requestNews("\(newsID)",
                            { (responseObject: AnyObject?) -> () in self.handleSuccess(responseObject) },
                            { (error: NSError?) -> () in self.handleError(error) }
                        );
                    }
                }
            }
        })
    }
    
    func loadPageContent(news: News) {
        // Load HTML
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