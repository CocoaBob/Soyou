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
            return self.info as? BaseNews
        }
    }
    
    // Class methods
    override class func instantiate() -> NewsDetailViewController {
        let instance = super.instantiate()
        object_setClass(instance, NewsDetailViewController.self)
        return (instance as? NewsDetailViewController)!
    }
    
    // Subclass overridden
    override var infoTitle: String! {
        get {
            var returnValue = ""
            MagicalRecord.saveWithBlockAndWait { (localContext) in
                let news = self.info as? BaseNews
                returnValue = news?.MR_inContext(localContext)?.title ?? ""
            }
            return returnValue
        }
        set {
        }
    }
    
    override var infoID: NSNumber! {
        get {
            var returnValue = NSNumber(int: -1)
            MagicalRecord.saveWithBlockAndWait { (localContext) in
                let news = self.info as? BaseNews
                returnValue = news?.MR_inContext(localContext)?.id ?? -1
            }
            return returnValue
        }
        set {
        }
    }
    
    // MARK: Like button
    override func updateLikeNumber() {
        DataManager.shared.requestNewsInfo(self.infoID) { responseObject, error in
            if let responseObject = responseObject as? [String:AnyObject],
                data = responseObject["data"] as? [String:AnyObject],
                likeNumber = data["likeNumber"] as? NSNumber {
                self.likeBtnNumber = likeNumber.integerValue
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
        if var item = self.infoTitle {
            if item.characters.count > 128 {
                item = item.substringToIndex(item.startIndex.advancedBy(128))
            }
            items.append(item)
        }
        if let item = self.infoID {
            items.append(item)
        }
        if let item = descriptions {
            items.append(item)
        }
        if let infoID = self.infoID, item = NSURL(string: "\(Cons.Svr.shareBaseURL)/news?id=\(infoID)") {
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
            BaseNews.toggleFavorite(self.infoID) { (_) -> () in
                // Toggle the value of isFavorite
                self.isFavorite = !self.isFavorite
            }
        }
    }
}

// MARK: Data
extension NewsDetailViewController {
    
    private func loadNews(news: BaseNews, context: NSManagedObjectContext) {
        // Load HTML
        self.loadWebView(title: news.title, content: news.content)
        
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
                                    self.loadWebView(title: localNews.title, content: localNews.content)
                                }
                            })
                    })
                }
            }
        }
    }
    
    override func loadData() {
        var needsToLoad: Bool = false
        
        self.webView?.loadHTMLString("<html></html>", baseURL: nil)
        
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if let localNews = self.news?.MR_inContext(localContext) {
                if localNews.appIsUpdated == nil || !localNews.appIsUpdated!.boolValue {
                    needsToLoad = true
                }
            }
        })
        
        if needsToLoad {
            MBProgressHUD.showLoader(self.view)
            DataManager.shared.requestNewsByID(self.infoID) { responseObject, error in
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
            if let index = indexPath?.row, news = item as? BaseNews {
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
}
