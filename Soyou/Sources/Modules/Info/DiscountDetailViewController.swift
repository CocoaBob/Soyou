//
//  DiscountDetailViewController.swift
//  Soyou
//
//  Created by CocoaBob on 03/06/16.
//  Copyright © 2016 Soyou. All rights reserved.
//

class DiscountDetailViewController: InfoDetailBaseViewController {
    
    // Discount Data
    var discount: Discount? {
        get {
            return self.info as? Discount
        }
    }
    
    // Class methods
    override class func instantiate() -> DiscountDetailViewController {
        let instance = super.instantiate()
        object_setClass(instance, DiscountDetailViewController.self)
        return (instance as? DiscountDetailViewController)!
    }
    
    // Subclass overridden
    override var infoTitle: String! {
        get {
            var returnValue = ""
            MagicalRecord.save(blockAndWait: { (localContext) in
                let discount = self.info as? Discount
                returnValue = discount?.mr_(in: localContext)?.title ?? ""
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
                let discount = self.info as? Discount
                returnValue = discount?.mr_(in: localContext)?.id as? Int ?? -1
            })
            return returnValue
        }
        set {
        }
    }
    
    // MARK: Like button
    override func updateExtraInfo() {
        DataManager.shared.requestDiscountInfo(self.infoID) { responseObject, error in
            if let responseObject = responseObject as? [String:AnyObject],
                let data = responseObject["data"] as? [String:AnyObject] {
                let json = JSON(data)
                self.likeBtnNumber = json["likeNumber"].int
                let isFavorite = json["isFavorite"].boolValue
                if isFavorite != self.isFavorite {
                    self.isFavorite = isFavorite
                    Discount.updateFavorite(self.infoID, isFavorite: isFavorite)
                }
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
        let isSTGMode = UserDefaults.boolForKey(Cons.App.isSTGMode)
        let shareBaseURL = isSTGMode ? Cons.Svr.shareBaseURLSTG : Cons.Svr.shareBaseURLPROD
        if let infoID = self.infoID, let item = URL(string: "\(shareBaseURL)/discounts?id=\(infoID)") {
            items.append(item)
        }
        Utils.shareItems(items: items, completion: { () -> Void in
            MBProgressHUD.hide(self.view)
        })
        DataManager.shared.analyticsShareNews(id: self.discount?.id?.intValue ?? -1)
    }
    
    override func like() {
        UserManager.shared.loginOrDo() { () -> () in
            let wasLiked = self.likeBtnIsLiked
            DataManager.shared.likeDiscount(self.infoID, wasLiked: wasLiked) { responseObject, error in
                guard let responseObject = responseObject as? [String: AnyObject] else { return }
                guard let data = responseObject["data"] else { return }
                
                // Update like number
                if let likeNumber = data as? NSNumber {
                    self.likeBtnNumber = likeNumber.intValue
                }
                
                self.updateLikeBtnColor(!wasLiked)
            }
        }
    }
    
    override func star() {
        UserManager.shared.loginOrDo() { () -> () in
            Discount.toggleFavorite(self.infoID) { (_) -> () in
                // Toggle the value of isFavorite
                self.isFavorite = !self.isFavorite
            }
        }
    }
    
    override func comment() {
        let commentsViewController = CommentsViewController.instantiate()
        commentsViewController.infoID = self.infoID
        commentsViewController.dataProvider = { (relativeID: Int?, completion: @escaping ((_ data: Any?) -> ())) -> () in
            DataManager.shared.requestCommentsForDiscount(self.infoID, Cons.Svr.commentRequestSize, relativeID, { (data: Any?, error: Error?) in
                completion(data)
            })
        }
        commentsViewController.commentCreator = { (id: Int, commentId: Int?, comment: String, completion: @escaping CompletionClosure) -> () in
            DataManager.shared.createCommentForDiscount(id, commentId, comment, completion)
        }
        commentsViewController.commentDeletor = { (commentID: Int, completion: @escaping CompletionClosure) -> () in
            DataManager.shared.deleteCommentsForDiscount([commentID], completion)
        }
        self.navigationController?.pushViewController(commentsViewController, animated: true)
    }
    
    override func didDismissPhotoPicker(with tlphAssets: [TLPHAsset]) {
        guard tlphAssets.count > 0 else { return }
        MBProgressHUD.show(self.view)
        let images = tlphAssets.flatMap() { $0.fullResolutionImage?.resizedImage(byMagick: "854x854") }
        Utils.shareToWeChat(from: self, items: images, completion: { (succeed) -> Void in
            MBProgressHUD.hide(self.view)
            if succeed {
                DataManager.shared.analyticsShareNews(id: self.discount?.id?.intValue ?? -1)
            }
        })
    }
}

// MARK: Data
extension DiscountDetailViewController {
    
    fileprivate func loadDiscount(_ discount: Discount, context: NSManagedObjectContext) {
        // Load HTML
        self.loadWebView(title: discount.title, content: discount.content)
        
        // Like/Comments
        self.updateExtraInfo()
        
        // Favorite button
        self.isFavorite = discount.isFavorite()
        
        // Cover Image
        if (self.headerImage == nil) {
            if let imageURLString = discount.coverImage, let imageURL = URL(string: imageURLString) {
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
                                if let localDiscount = self.discount?.mr_(in: localContext) {
                                    self.loadWebView(title: localDiscount.title, content: localDiscount.content)
                                }
                            })
                    })
                }
            }
        }
        
        // Analytics
        DataManager.shared.analyticsViewDiscount(id: discount.id?.intValue ?? -1)
    }
    
    override func loadData() {
        var needsToLoad: Bool = false
        
        self.webView?.loadHTMLString("<html></html>", baseURL: nil)
        
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
            if let localDiscount = self.discount?.mr_(in: localContext) {
                if localDiscount.appIsUpdated == nil || !localDiscount.appIsUpdated!.boolValue {
                    needsToLoad = true
                }
            }
        })
        
        if needsToLoad {
            MBProgressHUD.show(self.view)
            DataManager.shared.requestDiscountByID(self.infoID) { responseObject, error in
                MBProgressHUD.hide(self.view)
                if let responseObject = responseObject {
                    if let data = DataManager.getResponseData(responseObject) as? NSDictionary {
                        if self.discount is FavoriteDiscount {
                            FavoriteDiscount.importData(data, true, nil)
                        } else {
                            Discount.importData(data, true, nil)
                        }
                    }
                    MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
                        if let localDiscount = self.discount?.mr_(in: localContext) {
                            self.loadDiscount(localDiscount, context: localContext)
                        }
                    })
                }
            }
        } else {
            MagicalRecord.save({ (localContext: NSManagedObjectContext!) in
                if let localDiscount = self.discount?.mr_(in: localContext) {
                    self.loadDiscount(localDiscount, context: localContext)
                }
            })
        }
        
        // Parallax Header
        self.setupParallaxHeader()
    }
}
