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
    
    override var infoID: NSNumber! {
        get {
            var returnValue = NSNumber(value: -1)
            MagicalRecord.save(blockAndWait: { (localContext) in
                let discount = self.info as? Discount
                returnValue = discount?.mr_(in: localContext)?.id ?? -1
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
    override func share() {
        MBProgressHUD.show(self.view)
        
        var htmlString: String?
        MagicalRecord.save(blockAndWait: { (localContext: NSManagedObjectContext!) in
            if let localDiscount = self.discount?.mr_(in: localContext) {
                htmlString = localDiscount.content
            }
        })
        var descriptions: String?
        if let htmlString = htmlString,
            let htmlData = htmlString.data(using: String.Encoding.utf8) {
            do {
                let attributedString = try NSAttributedString(data: htmlData,
                                                              options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                                                        NSCharacterEncodingDocumentAttribute:String.Encoding.utf8],
                                                              documentAttributes: nil)
                var contentString = attributedString.string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                if contentString.characters.count > 256 {
                    contentString = contentString[contentString.startIndex...contentString.index(contentString.startIndex, offsetBy: 256)]
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
            if item.characters.count > 128 {
                item = item[item.startIndex...item.index(item.startIndex, offsetBy: 128)]
            }
            items.append(item as AnyObject)
        }
        if let item = self.infoID {
            items.append(item)
        }
        if let item = descriptions {
            items.append(item as AnyObject)
        }
        if let infoID = self.infoID, let item = URL(string: "\(Cons.Svr.shareBaseURL)/discounts?id=\(infoID)") {
            items.append(item)
        }
        Utils.shareItems(items, completion: { () -> Void in
            MBProgressHUD.hide(self.view)
        })
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
        let commentsViewController = InfoCommentsViewController.instantiate()
        commentsViewController.infoID = self.infoID
        commentsViewController.dataProvider = { (relativeID: Int?, completion: @escaping ((_ data: Any?) -> ())) -> () in
            DataManager.shared.requestCommentsForDiscount(self.infoID, Cons.Svr.commentRequestSize, relativeID as NSNumber?, { (data: Any?, error: NSError?) in
                completion(data)
            })
        }
        self.navigationController?.pushViewController(commentsViewController, animated: true)
    }
}

// MARK: Data
extension DiscountDetailViewController {
    
    fileprivate func loadDiscount(_ discount: Discount, context: NSManagedObjectContext) {
        // Load HTML
        self.loadWebView(title: discount.title, content: discount.content)
        
        // Like button
        self.updateExtraInfo()
        
        // Favorite button
        self.isFavorite = discount.isFavorite()
        
        // Cover Image
        if (self.headerImage == nil) {
            if let imageURLString = discount.coverImage, let imageURL = URL(string: imageURLString) {
                let imageManager = SDWebImageManager.shared()
                let cacheKey = imageManager?.cacheKey(for: imageURL)
                var cachedImage: UIImage? = imageManager?.imageCache.imageFromMemoryCache(forKey: cacheKey)
                if cachedImage == nil {
                    cachedImage = imageManager?.imageCache.imageFromDiskCache(forKey: cacheKey)
                }
                if let cachedImage = cachedImage {
                    DispatchQueue.main.async {
                        self.headerImage = cachedImage
                        self.setupParallaxHeader()
                    }
                } else {
                    SDWebImageManager.shared().downloadImage(
                        with: imageURL,
                        options: [.continueInBackground, .allowInvalidSSLCertificates],
                        progress: { (receivedSize: NSInteger, expectedSize: NSInteger) -> Void in
                            
                        },
                        completed: { (image, error, type, finished, url) -> Void in
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
        
        // Prepare next discount
        self.delegate?.getNextItem(IndexPath(row: self.infoIndex ?? 0, section: 0), isNext: true, completion: { (indexPath, item) in
            if let index = indexPath?.row, let discount = item as? Discount {
                self.nextInfoIndex = index
                self.nextInfo = discount
            } else {
                self.nextInfoIndex = nil
                self.nextInfo = nil
            }
            // Next button status
            self.nextInfoBarButtonItem?.isEnabled = self.nextInfo != nil
        })
    }
}
