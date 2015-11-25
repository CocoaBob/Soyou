//
//  NewsDetailViewController.swift
//  iPrices
//
//  Created by CocoaBob on 24/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class NewsDetailViewController: UIViewController {
    var webView: WKWebView?
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
        
        self.webView = WKWebView(frame: self.view.bounds)
        self.view = self.webView!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestNews()
    }

}

// MARK: Data
extension NewsDetailViewController {
    
    private func handleSuccess(responseObject: AnyObject?) {
        guard let responseObject = responseObject as? Dictionary<String, AnyObject> else { return }
        let newsData = responseObject["data"] as? NSDictionary
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            News.importData(newsData, localContext)
            
            let localNews = self.news?.MR_inContext(localContext)
            if let contentHTML = localNews?.content {
                self.webView?.loadHTMLString(contentHTML, baseURL: nil)
            }
        })
    }
    
    private func handleError(error: NSError?) {
        print("\(error)")
    }
    
    func requestNews() {
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if let localNews = self.news?.MR_inContext(localContext) {
                
                if let contentHTML = localNews.content {
                    self.webView?.loadHTMLString(contentHTML, baseURL: nil)
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
    
}