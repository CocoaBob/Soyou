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
            MagicalRecord.saveWithBlockAndWait { (localContext) in
                let discount = self.info as? Discount
                returnValue = discount?.MR_inContext(localContext)?.title ?? ""
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
                let discount = self.info as? Discount
                returnValue = discount?.MR_inContext(localContext)?.id ?? -1
            }
            return returnValue
        }
        set {
        }
    }
    
    // MARK: Like button
    override func updateExtraInfo() {
        DataManager.shared.requestDiscountInfo(self.infoID) { responseObject, error in
            if let responseObject = responseObject as? [String:AnyObject],
                data = responseObject["data"] as? [String:AnyObject] {
                if let likeNumber = data["likeNumber"] as? NSNumber {
                    self.likeBtnNumber = likeNumber.integerValue
                }
                if let isFavorite = data["isFavorite"] as? NSNumber {
                    if isFavorite.boolValue != self.isFavorite {
                        self.isFavorite = isFavorite.boolValue
                        Discount.updateFavorite(self.infoID, isFavorite: isFavorite.boolValue)
                    }
                }
                if let commentNumber = data["commentNumber"] as? NSNumber {
                    self.commentBtnNumber = commentNumber.integerValue
                }
            }
        }
    }
    
    // MARK: Bar button items
    override func share() {
        MBProgressHUD.showLoader(self.view)
        
        var htmlString: String?
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if let localDiscount = self.discount?.MR_inContext(localContext) {
                htmlString = localDiscount.content
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
        if let infoID = self.infoID, item = NSURL(string: "\(Cons.Svr.shareBaseURL)/discounts?id=\(infoID)") {
            items.append(item)
        }
        Utils.shareItems(items, completion: { () -> Void in
            MBProgressHUD.hideLoader(self.view)
        })
    }
    
    override func like() {
        UserManager.shared.loginOrDo() { () -> () in
            self.discount?.toggleLike() { (likeNumber: AnyObject?) -> () in
                // Update like number
                if let likeNumber = likeNumber as? NSNumber {
                    self.likeBtnNumber = likeNumber.integerValue
                }
                
                // Update like color
                MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                    let isLiked = self.discount?.MR_inContext(localContext)?.isLiked()
                    dispatch_async(dispatch_get_main_queue(), {
                        self.updateLikeBtnColor(isLiked)
                    })
                })
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
        commentsViewController.dataProvider = { (completion: ((data: AnyObject?) -> ())) -> () in
            // TODO: Load limited data, and automatically load next data
            DataManager.shared.requestCommentsForDiscount(self.infoID, 100, 0, { (data, error) in
                completion(data: data)
            })
        }
        self.navigationController?.pushViewController(commentsViewController, animated: true)
    }
}

// MARK: Data
extension DiscountDetailViewController {
    
    private func loadDiscount(discount: Discount, context: NSManagedObjectContext) {
        // Load HTML
        self.loadWebView(title: discount.title, content: discount.content)
        
        // Like button
        updateLikeBtnColor(discount.isLiked())
        updateExtraInfo()
        
        // Favorite button
        self.isFavorite = discount.isFavorite()
        
        // Cover Image
        if (self.headerImage == nil) {
            if let imageURLString = discount.coverImage, imageURL = NSURL(string: imageURLString) {
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
                                if let localDiscount = self.discount?.MR_inContext(localContext) {
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
        
        MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
            if let localDiscount = self.discount?.MR_inContext(localContext) {
                if localDiscount.appIsUpdated == nil || !localDiscount.appIsUpdated!.boolValue {
                    needsToLoad = true
                }
            }
        })
        
        if needsToLoad {
            MBProgressHUD.showLoader(self.view)
            DataManager.shared.requestDiscountByID(self.infoID) { responseObject, error in
                MBProgressHUD.hideLoader(self.view)
                if let responseObject = responseObject {
                    if let data = DataManager.getResponseData(responseObject) as? NSDictionary {
                        if self.discount is FavoriteDiscount {
                            FavoriteDiscount.importData(data, true, nil)
                        } else {
                            Discount.importData(data, true, nil)
                        }
                    }
                    MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                        if let localDiscount = self.discount?.MR_inContext(localContext) {
                            self.loadDiscount(localDiscount, context: localContext)
                        }
                    })
                }
            }
        } else {
            MagicalRecord.saveWithBlock({ (localContext: NSManagedObjectContext!) -> Void in
                if let localDiscount = self.discount?.MR_inContext(localContext) {
                    self.loadDiscount(localDiscount, context: localContext)
                }
            })
        }
        
        // Parallax Header
        self.setupParallaxHeader()
        
        // Prepare next discount
        self.delegate?.getNextItem(NSIndexPath(forRow: self.infoIndex ?? 0, inSection: 0), isNext: true, completion: { (indexPath, item) in
            if let index = indexPath?.row, discount = item as? Discount {
                self.nextInfoIndex = index
                self.nextInfo = discount
            } else {
                self.nextInfoIndex = nil
                self.nextInfo = nil
            }
            // Next button status
            self.nextInfoBarButtonItem?.enabled = self.nextInfo != nil
        })
    }
}
