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
    
    convenience init() {
        self.init(news: nil, image: nil)
    }
    
    init(news: News?, image: UIImage?) {
        self.news = news
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // UIViewController
        self.edgesForExtendedLayout = UIRectEdge.None
        self.extendedLayoutIncludesOpaqueBars = false
        self.automaticallyAdjustsScrollViewInsets = true
    }
    
    override func loadView() {
        super.loadView()
        
        self.webView = UIWebView(frame: self.view.bounds)
        self.view = self.webView!
        
        if let image = self.image {
            self.webView?.scrollView.addTwitterCoverWithImage(image, withImageSize: CGSizeMake(image.size.width, min(image.size.height, 200)))
        }
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
    }
    
}

// MARK: - RMPZoomTransitionAnimating/RMPZoomTransitionDelegate
extension NewsDetailViewController: RMPZoomTransitionAnimating, RMPZoomTransitionDelegate {
    
    func imageViewFrame() -> CGRect {
        if let fgImageView = self.webView?.scrollView.twitterCoverView {
            return fgImageView.convertRect(fgImageView.frame, toView: self.view)
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
        return UIColor.whiteColor()
    }
    
    func transitionDestinationImageViewFrame() -> CGRect {
        return imageViewFrame()
    }
    
    func zoomTransitionAnimator(animator: RMPZoomTransitionAnimator!, didCompleteTransition didComplete: Bool, animatingSourceImageView imageView: UIImageView!) {
        
    }
}