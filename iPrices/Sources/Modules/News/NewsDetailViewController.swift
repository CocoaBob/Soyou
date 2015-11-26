//
//  NewsDetailViewController.swift
//  iPrices
//
//  Created by CocoaBob on 24/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class NewsDetailViewController: UIViewController {
    var webView: UIWebView?
    var news: News?
    var scrollView: UIScrollView? {
        return self.webView?.scrollView
    }
    
    convenience init() {
        self.init(news: nil)
    }
    
    init(news: News?) {
        self.news = news
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UIViewController
//        updateTitleViewImage(nil)
        
        self.edgesForExtendedLayout = UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = true
    }
    
    override func loadView() {
        super.loadView()
        
        self.webView = UIWebView(frame: self.view.bounds)
        self.view = self.webView!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNews()
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
        if let contentHTML = news.content {
            self.webView?.loadHTMLString(contentHTML, baseURL: nil)
        }
        
        // Load header image
        let cacheKey = SDWebImageManager.sharedManager().cacheKeyForURL(NSURL(string: news.image!))
        if let image = SDImageCache.sharedImageCache().imageFromDiskCacheForKey(cacheKey) {
            self.webView?.scrollView.addTwitterCoverWithImage(image, withImageSize: CGSizeMake(image.size.width, min(image.size.height, 200)))
        }
    }
    
}

// MARK: - RMPZoomTransitionAnimating
extension NewsDetailViewController: RMPZoomTransitionAnimating {

    func transitionSourceImageView() -> UIImageView! {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.userInteractionEnabled = false
        if let fgImageView = self.webView?.scrollView.twitterCoverView {
            imageView.frame = fgImageView.convertRect(fgImageView.frame, toView: self.view)
            imageView.image = fgImageView.image
            imageView.contentMode = fgImageView.contentMode
        }
        return imageView
    }
    
    func transitionSourceBackgroundColor() -> UIColor! {
        return UIColor.whiteColor()
    }
    
    func transitionDestinationImageViewFrame() -> CGRect {
        if let fgImageView = self.webView?.scrollView.twitterCoverView {
            return fgImageView.convertRect(fgImageView.frame, toView: self.view)
        }
        return CGRectZero
    }
}

extension NewsDetailViewController: RMPZoomTransitionDelegate {
    
    func zoomTransitionAnimator(animator: RMPZoomTransitionAnimator!, didCompleteTransition didComplete: Bool, animatingSourceImageView imageView: UIImageView!) {
        
    }
}