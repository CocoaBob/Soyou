//
//  NewsDetailViewController.swift
//  Soyou
//
//  Created by CocoaBob on 24/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class NewsDetailViewController: InfoDetailBaseViewController {
    
    // News Data
    var news: BaseNews? {
        get {
            return self.info as? News
        }
    }
    var newsTitle: String! {
        get {
            return (self.info as? BaseNews)?.title ?? ""
        }
    }
    var newsID: NSNumber! {
        get {
            return (self.info as? BaseNews)?.id ?? -1
        }
    }
    
    // Subclass overridden
    
    // Class methods
    override class func instantiate() -> NewsDetailViewController {
        let instance = super.instantiate()
        object_setClass(instance, NewsDetailViewController.self)
        return (instance as? NewsDetailViewController)!
    }
    
    // MARK: Like button
    override func updateLikeNumber() {
        DataManager.shared.requestNewsInfo(self.newsID) { responseObject, error in
            if let responseObject = responseObject as? [String:AnyObject],
                data = responseObject["data"] as? [String:AnyObject],
                likeNumber = data["likeNumber"] as? NSNumber {
                self.likeBtnNumber = likeNumber.integerValue
            }
        }
    }
    
    override func updateLikeBtnColor(appIsLiked: Bool?) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if appIsLiked != nil && appIsLiked!.boolValue {
                self.btnLike?.tintColor = self.btnLikeActiveColor
            } else {
                self.btnLike?.tintColor = self.btnLikeInactiveColor
            }
        }
    }
    
    override var likeBtnNumber: Int? {
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
    
    // MARK: Bar button items
    override func share() {
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
    
    override func like() {
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
    
    override func star() {
        UserManager.shared.loginOrDo() { () -> () in
            BaseNews.toggleFavorite(self.newsID) { (_) -> () in
                // Toggle the value of isFavorite
                self.isFavorite = !self.isFavorite
            }
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
    
    override func loadData() {
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
        self.delegate?.getNextItem(NSIndexPath(forRow: self.infoIndex ?? 0, inSection: 0), isNext: true, completion: { (indexPath, item) in
            if let index = indexPath?.row, news = item as? News {
                self.nextInfoIndex = index
                self.nextInfo = news
            } else {
                self.nextInfoIndex = nil
                self.nextInfo = nil
            }
            // Next button status
            self.nextInfoBarButtonItem?.enabled = self.nextInfo != nil
        })
    }
    
    override func loadNextData() {
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
}
