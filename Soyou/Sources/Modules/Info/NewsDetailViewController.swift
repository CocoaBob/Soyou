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
    
    override var infoID: Int! {
        get {
            var returnValue = -1
            MagicalRecord.save(blockAndWait: { (localContext) in
                let news = self.info as? News
                returnValue = news?.mr_(in: localContext)?.id as? Int ?? -1
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
    override func shareURL() {
        MBProgressHUD.show(self.view)
        
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

        let shareBaseURL = Utils.isSTGMode() ? Cons.Svr.shareBaseURLSTG : Cons.Svr.shareBaseURLPROD
        if let infoID = self.infoID, let item = URL(string: "\(shareBaseURL)/news?id=\(infoID)") {
            items.append(item)
        }
        Utils.shareItems(items: items, completion: { () -> Void in
            MBProgressHUD.hide(self.view)
        })
        DataManager.shared.analyticsShareNews(id: self.news?.id?.intValue ?? -1)
    }
    
    override func like() {
        self.news?.toggleLike() { (likeNumber: Any?) -> () in
            // Update like number
            self.likeBtnNumber = likeNumber as? Int
            
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
        let commentsViewController = CommentsViewController.instantiate()
        commentsViewController.infoID = self.infoID
        commentsViewController.dataProvider = { (relativeID: Int?, completion: @escaping ((_ data: Any?) -> ())) -> () in
            DataManager.shared.requestCommentsForNews(self.infoID, Cons.Svr.commentRequestSize, relativeID, { (data: Any?, error: Error?) in
                completion(data)
            })
        }
        commentsViewController.commentCreator = { (id: Int, commentId: Int?, comment: String, completion: @escaping CompletionClosure) -> () in
            DataManager.shared.createCommentForNews(id, commentId, comment, completion)
        }
        commentsViewController.commentDeletor = { (commentID: Int, completion: @escaping CompletionClosure) -> () in
            DataManager.shared.deleteCommentsForNews([commentID], completion)
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
                    cachedImage = imageManager.imageCache?.imageFromCache(forKey: cacheKey)
                }
                if let cachedImage = cachedImage {
                    DispatchQueue.main.async {
                        self.headerImage = cachedImage
                        self.setupParallaxHeader()
                    }
                } else {
                    SDWebImageManager.shared().loadImage(
                        with: imageURL,
                        options: [.continueInBackground, .allowInvalidSSLCertificates],
                        progress: nil,
                        completed: { (image, data, error, type, finished, url) -> Void in
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
        
        // Analytics
        DataManager.shared.analyticsViewNews(id: news.id?.intValue ?? -1)
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
    }
}
