//
//  NewsDetailViewController.swift
//  Soyou
//
//  Created by CocoaBob on 24/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class NewsDetailViewController: InfoDetailBaseViewController {
    
    // News Data
    var news: News? {
        get {
            return self.info as? News
        }
    }
    
    // Class methods
    override class func instantiate() -> NewsDetailViewController {
        let instance = super.instantiate()
        object_setClass(instance, NewsDetailViewController.self)
        return (instance as? NewsDetailViewController)!
    }
    
    override var infoTitle: String! {
        get {
            var returnValue = ""
            MagicalRecord.save(blockAndWait: { (localContext) in
                let news = self.info as? News
                returnValue = news?.mr_(in: localContext)?.title ?? ""
            })
            return returnValue
        }
        set {
        }
    }
    
    override var infoID: NSNumber! {
        get {
            var returnValue = NSNumber(value: -1)
            MagicalRecord.save(blockAndWait: { (localContext) in
                let news = self.info as? News
                returnValue = news?.mr_(in: localContext)?.id ?? -1
            })
            return returnValue
        }
        set {
        }
    }
    
    // MARK: Like button
    override func updateExtraInfo() {
        DataManager.shared.requestNewsInfo(self.infoID) { responseObject, error in
            if let responseObject = responseObject as? [String:AnyObject],
                let data = responseObject["data"] as? [String:AnyObject] {
                let json = JSON(data)
                self.likeBtnNumber = json["likeNumber"].int
//                let isFavorite = json["isFavorite"].boolValue
                self.commentBtnNumber = json["commentNumber"].int
                self.updateLikeBtnColor(json["isLiked"].boolValue)
            }
        }
    }
    
    // MARK: Bar button items
    override func share() {
        MBProgressHUD.show(self.view)
        
        var htmlString: String?
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
            if let localNews = self.news?.mr_(in: localContext) {
                htmlString = localNews.content
            }
        })
        var descriptions: String?
        if let htmlString = htmlString,
            let htmlData = htmlString.data(using: String.Encoding.utf8) {
            do {
                let attributedString = try NSAttributedString(data: htmlData,
                                                              options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                                                                        NSAttributedString.DocumentReadingOptionKey.characterEncoding: NSNumber(value: String.Encoding.utf8.rawValue)],
                                                              documentAttributes: nil)
                var contentString = attributedString.string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if contentString.count > 256 {
                    contentString = String(contentString[..<contentString.index(contentString.startIndex, offsetBy: 256)])
                }
                descriptions = contentString
            } catch {
                
            }
        }
        var items = [Any]()
        if let item = self.headerImage {
            items.append(item)
        }
        if var item = self.infoTitle {
            if item.count > 128 {
                item = String(item[..<item.index(item.startIndex, offsetBy: 128)])
            }
            items.append(item as AnyObject)
        }
        if let item = self.infoID {
            items.append(item)
        }
        if let item = descriptions {
            items.append(item as AnyObject)
        }
        if let infoID = self.infoID, let item = URL(string: "\(Cons.Svr.shareBaseURL)/news?id=\(infoID)") {
            items.append(item)
        }
        Utils.shareItems(items, completion: { () -> Void in
            MBProgressHUD.hide(self.view)
        })
    }
    
    override func like() {
        self.news?.toggleLike() { (likeNumber: Any?) -> () in
            // Update like number
            if let likeNumber = likeNumber as? NSNumber {
                self.likeBtnNumber = likeNumber.intValue
            }
            
            // Update like color
            MagicalRecord.save({ (localContext: NSManagedObjectContext!) in
                let isLiked = self.news?.mr_(in: localContext)?.isLiked()
                DispatchQueue.main.async {
                    self.updateLikeBtnColor(isLiked ?? false)
                }
            })
        }
    }
    
    override func star() {
        UserManager.shared.loginOrDo() { () -> () in
            News.toggleFavorite(self.infoID) { (_) -> () in
                // Toggle the value of isFavorite
                self.isFavorite = !self.isFavorite
            }
        }
    }
    
    override func comment() {
        let commentsViewController = InfoCommentsViewController.instantiate()
        commentsViewController.infoID = self.infoID
        commentsViewController.dataProvider = { (relativeID: Int?, completion: @escaping ((_ data: Any?) -> ())) -> () in
            DataManager.shared.requestCommentsForNews(self.infoID, Cons.Svr.commentRequestSize, relativeID as NSNumber?, { (data: Any?, error: NSError?) in
                completion(data)
            })
        }
        commentsViewController.commentCreator = { (id: NSNumber, commentId: NSNumber, comment: String, completion: @escaping CompletionClosure) -> () in
            DataManager.shared.createCommentForNews(id, commentId, comment, completion)
        }
        self.navigationController?.pushViewController(commentsViewController, animated: true)
    }
}

// MARK: Data
extension NewsDetailViewController {
    
    fileprivate func loadNews(_ news: News, context: NSManagedObjectContext) {
        // Load HTML
        self.loadWebView(title: news.title, content: news.content)
        
        // Like button
        self.updateLikeBtnColor(news.isLiked())
        
        // Like/Comments
        self.updateExtraInfo()
        
        // Favorite button
        self.isFavorite = news.isFavorite()
        
        // Cover Image
        if (self.headerImage == nil) {
            if let imageURLString = news.image,
                let imageURL = URL(string: imageURLString)
            {
                let imageManager = SDWebImageManager.shared()
                let cacheKey = imageManager.cacheKey(for: imageURL)
                var cachedImage: UIImage? = imageManager.imageCache?.imageFromMemoryCache(forKey: cacheKey)
                if cachedImage == nil {
                    cachedImage = imageManager.imageCache?.imageFromDiskCache(forKey: cacheKey)
                }
                if let cachedImage = cachedImage {
                    DispatchQueue.main.async {
                        self.headerImage = cachedImage
                        self.setupParallaxHeader()
                    }
                } else {
                    SDWebImageManager.shared().imageDownloader?.downloadImage(
                        with: imageURL,
                        options: [.continueInBackground, .allowInvalidSSLCertificates],
                        progress: nil,
                        completed: { (image, data, error, finished) -> Void in
                            DispatchQueue.main.async {
                                self.headerImage = image
                                self.setupParallaxHeader()
                            }
                            MagicalRecord.save({ (localContext: NSManagedObjectContext!) in
                                if let localNews = self.news?.mr_(in: localContext) {
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
        
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
            if let localNews = self.news?.mr_(in: localContext) {
                if localNews.appIsUpdated == nil || !localNews.appIsUpdated!.boolValue {
                    needsToLoad = true
                }
            }
        })
        
        if needsToLoad {
            MBProgressHUD.show(self.view)
            DataManager.shared.requestNewsByID(self.infoID) { responseObject, error in
                MBProgressHUD.hide(self.view)
                if let responseObject = responseObject {
                    if let data = DataManager.getResponseData(responseObject) as? NSDictionary {
                        if self.news is FavoriteNews {
                            FavoriteNews.importData(data, true, nil)
                        } else {
                            News.importData(data, true, nil)
                        }
                    }
                    MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
                        if let localNews = self.news?.mr_(in: localContext) {
                            self.loadNews(localNews, context: localContext)
                        }
                    })
                }
            }
        } else {
            MagicalRecord.save({ (localContext: NSManagedObjectContext!) in
                if let localNews = self.news?.mr_(in: localContext) {
                    self.loadNews(localNews, context: localContext)
                }
            })
        }
        
        // Parallax Header
        self.setupParallaxHeader()
        
        // Prepare next news
        self.delegate?.getNextItem(IndexPath(row: self.infoIndex ?? 0, section: 0), isNext: true, completion: { (indexPath, item) in
            if let index = indexPath?.row, let news = item as? News {
                self.nextInfoIndex = index
                self.nextInfo = news
            } else {
                self.nextInfoIndex = nil
                self.nextInfo = nil
            }
            // Next button status
            self.nextInfoBarButtonItem?.isEnabled = self.nextInfo != nil
        })
    }
}
