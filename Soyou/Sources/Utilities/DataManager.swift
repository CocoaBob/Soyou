//
//  ServerManager.swift
//  Soyou
//
//  Created by CocoaBob on 23/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class DataManager {
    
    static let shared = DataManager()
    
    private var isUpdatingData = false
    
    //////////////////////////////////////
    // MARK: General
    //////////////////////////////////////
    
    private func handleError(error: NSError?) {
        DLog(error)
        
        if let response = error?.userInfo[AFNetworkingOperationFailingURLResponseErrorKey], statusCode = response.statusCode {
            // If 401 error, logout
            if statusCode == 401 {
                UserManager.shared.logOut()
            }
        }
    }
    
    private func completeWithData(data: AnyObject?, completion: CompletionClosure?) {
        if let completion = completion { completion(data, nil) }
    }
    
    private func completeWithError(error: NSError?, completion: CompletionClosure?) {
        self.handleError(error)
        if let completion = completion { completion(nil, error) }
    }
    
    class func getResponseData(responseObject: AnyObject?) -> AnyObject? {
        guard let responseObject = responseObject as? Dictionary<String, AnyObject> else { return nil }
        return responseObject["data"]
    }
    
    class func showRequestFailedAlert(error: NSError?) {
        let responseObject = AFNetworkingGetResponseObjectFromError(error)
        DLog(responseObject)
        // Show error
        if let responseObject = responseObject as? Dictionary<String, AnyObject>,
            data = responseObject["data"] as? [String],
            message = data.first {
                SCLAlertView().showError(NSLocalizedString("alert_title_failed"), subTitle: NSLocalizedString(message))
        } else {
            SCLAlertView().showError(NSLocalizedString("alert_title_failed"), subTitle: error?.localizedDescription ?? "")
        }
    }
    
    //////////////////////////////////////
    // MARK: Currency
    //////////////////////////////////////
    
    func requestCurrencyChanges(currencies: [NSDictionary], _ completion: CompletionClosure?) {
        RequestManager.shared.requestCurrencyChanges(currencies,
            { responseObject in self.completeWithData(responseObject, completion: completion) },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    
    //////////////////////////////////////
    // MARK: Authentication
    //////////////////////////////////////
    
    func checkToken() {
        RequestManager.shared.checkToken(
            { responseObject in self.completeWithData(responseObject, completion: nil) },
            { error in self.completeWithError(error, completion: nil) }
        )
    }
    
    func login(email: String, _ password: String, _ completion: CompletionClosure?) {
        RequestManager.shared.login(email, password,
            { responseObject in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    if let data = DataManager.getResponseData(responseObject) as? NSDictionary {
                        for (key, value) in data {
                            UserManager.shared[key as! String] = value
                        }
                        UserManager.shared.logIn(data["token"]! as! String)
                    }
                    self.completeWithData(responseObject, completion: completion)
                }
            },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    func register(email: String, _ password: String, _ gender: String, _ completion: CompletionClosure?) {
        RequestManager.shared.register(email, password, gender,
            { responseObject in self.completeWithData(responseObject, completion: completion) },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    func requestVerifyCode(email: String, _ completion: CompletionClosure?) {
        RequestManager.shared.requestVerifyCode(email,
            { responseObject in self.completeWithData(responseObject, completion: completion) },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    func resetPassword(verifyCode: String, _ password: String, _ completion: CompletionClosure?) {
        RequestManager.shared.resetPassword(verifyCode, password,
            { responseObject in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    if let data = DataManager.getResponseData(responseObject) as? NSDictionary {
                        UserManager.shared.logIn(data["token"]! as! String)
                        for (key, value) in data {
                            UserManager.shared[key as! String] = value
                        }
                    }
                    self.completeWithData(responseObject, completion: completion)
                }
            },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    
    //////////////////////////////////////
    // MARK: User
    //////////////////////////////////////
    
    func modifyEmail(email: String, _ completion: CompletionClosure?) {
        RequestManager.shared.modifyEmail(email,
            { responseObject in self.completeWithData(responseObject, completion: completion) },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    func modifyUserInfo(field:String, _ value:String, _ completion: CompletionClosure?) {
        RequestManager.shared.modifyUserInfo(field, value,
            { responseObject in self.completeWithData(responseObject, completion: completion) },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    //////////////////////////////////////
    // MARK: Products
    //////////////////////////////////////
    
    func requestAllBrands(completion: CompletionClosure?){
        RequestManager.shared.requestAllBrands(
            { responseObject in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                        Brand.importDatas(data, true, { (_, _) -> () in
                            // After importing, cache all brand images
                            MagicalRecord.saveWithBlock({ (localContext) -> Void in
                                if let brands = Brand.MR_findAllInContext(localContext) as? [Brand] {
                                    for brand in brands {
                                        if let imageURL = brand.imageUrl, url = NSURL(string: imageURL) {
                                            SDWebImageManager.sharedManager().downloadImageWithURL(url, options: .LowPriority, progress: { (_, _) -> Void in }, completed: { (_, _, _, _, _) -> Void in })
                                        }
                                    }
                                }
                                }, completion: { (_, _) -> Void in
                                    self.completeWithData(responseObject, completion: completion)
                            })
                        })
                    }
                }
            },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    func requestProductInfo(id: String, _ completion: CompletionClosure?) {
        RequestManager.shared.requestProductInfo(id,
            { responseObject in self.completeWithData(responseObject, completion: completion) },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    //////////////////////////////////////
    // MARK: Favorites News
    //////////////////////////////////////
    
    func favoriteNews(id: NSNumber, wasFavorite: Bool, _ completion: CompletionClosure?) {
        RequestManager.shared.favoriteNews(id, operation: wasFavorite ? "-" : "+",
            { responseObject in self.completeWithData(responseObject, completion: completion) },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    func requestNewsFavorites(completion: CompletionClosure?) {
        let responseHandlerClosure = { (responseObject: AnyObject?) -> () in
            if let data = responseObject?["data"] as? [NSDictionary] {
                FavoriteNews.updateWithData(data, completion)
            } else {
                if let completion = completion { completion(nil, nil) }
            }
        }
        let errorHandlerClosure = { (error: NSError?) -> () in
            self.completeWithError(error, completion: completion)
        }
        
        if UserManager.shared.isLoggedIn {
            RequestManager.shared.requestNewsFavorites(responseHandlerClosure, errorHandlerClosure)
        }
    }
    
    //////////////////////////////////////
    // MARK: Favorites Products
    //////////////////////////////////////
    
    func requestProductFavorites(completion: CompletionClosure?) {
        let responseHandlerClosure = { (responseObject: AnyObject?) -> () in
            if let data = responseObject?["data"] as? [NSDictionary] {
                FavoriteProduct.updateWithData(data, completion)
            }
        }
        let errorHandlerClosure = { (error: NSError?) -> () in
            self.completeWithError(error, completion: completion)
        }
        
        RequestManager.shared.requestProductFavorites(responseHandlerClosure, errorHandlerClosure)
    }
    
    func favoriteProduct(id: NSNumber, wasFavorite: Bool, _ completion: CompletionClosure?) {
        RequestManager.shared.favoriteProduct(id, operation: wasFavorite ? "-" : "+",
            { responseObject in self.completeWithData(responseObject, completion: completion) },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    //////////////////////////////////////
    // MARK: News
    //////////////////////////////////////
    
    func likeNews(id: NSNumber, wasLiked: Bool, _ completion: CompletionClosure?) {
        RequestManager.shared.likeNews(id, operation: wasLiked ? "-" : "+",
            { responseObject in self.completeWithData(responseObject, completion: completion) },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    func requestNewsList(relativeID: NSNumber?, _ completion: CompletionClosure?) {
        RequestManager.shared.requestNewsList(Cons.Svr.reqCnt, relativeID,
            { responseObject in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                        News.importDatas(data, false, relativeID, { (_, _) -> () in
                            // After importing, cache all news images
                            MagicalRecord.saveWithBlock({ (localContext) -> Void in
                                if let allNews = News.MR_findAllInContext(localContext) as? [News] {
                                    for news in allNews {
                                        if let imageURL = news.image, url = NSURL(string: imageURL) {
                                            SDWebImageManager.sharedManager().downloadImageWithURL(url, options: .LowPriority, progress: { (_, _) -> Void in }, completed: { (_, _, _, _, _) -> Void in })
                                        }
                                    }
                                }
                                }, completion: { (_, _) -> Void in
                                    self.completeWithData(responseObject, completion: completion)
                            })
                        })
                    }
                }
            },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    func requestNewsByID(id: NSNumber, _ completion: CompletionClosure?) {
        RequestManager.shared.requestNewsByID(id,
            { responseObject in self.completeWithData(responseObject, completion: completion) },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    func requestNews(ids: [NSNumber], _ completion: CompletionClosure?) {
        RequestManager.shared.requestNews(ids,
            { responseObject in self.completeWithData(responseObject, completion: completion) },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    func requestNewsInfo(id: NSNumber, _ completion: CompletionClosure?) {
        RequestManager.shared.requestNewsInfo(id,
            { responseObject in self.completeWithData(responseObject, completion: completion) },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    //////////////////////////////////////
    // MARK: Notification
    //////////////////////////////////////
    
    func registerForNotification(deviceToken: String) {
        RequestManager.shared.registerForNotification(UserManager.shared.uuid, deviceToken,
            { responseObject in
                UserManager.shared.deviceToken = deviceToken
                DLog("Push register success")
            },
            { error in self.completeWithError(error, completion: nil) }
        )
    }
    
    //////////////////////////////////////
    // MARK: Products
    //////////////////////////////////////
    
    func translateProduct(id: NSNumber, _ completion: CompletionClosure?) {
        RequestManager.shared.translateProduct(id,
            { responseObject in self.completeWithData(responseObject, completion: completion) },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    func likeProduct(id: NSNumber, wasLiked: Bool, _ completion: CompletionClosure?) {
        RequestManager.shared.likeProduct(id, operation: wasLiked ? "-" : "+",
            { responseObject in self.completeWithData(responseObject, completion: completion) },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    func loadProducts(ids: [NSNumber], _ completion: CompletionClosure?) {
        RequestManager.shared.requestProducts(ids,
            { responseObject in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                        let checkExisting: Bool = (Product.MR_findAll()?.count > 0) ?? false
                        Product.importDatas(data, checkExisting, completion)
                    }
                }
            },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    // Helper methods for Products
    func loadBunchProducts(productIDs: [NSNumber], index: Int, size: Int, completion: CompletionClosure?) {
        if index >= productIDs.count {
            self.completeWithData(nil, completion: completion)
            return
        }
        
        let rangeSize = ((index + size) > productIDs.count) ? (productIDs.count - index) : size
        DLog(FmtString("count=%d index=%d size=%d rangeSize=%d", productIDs.count, index, size, rangeSize))
        if rangeSize > 0 {
            let range = productIDs[index..<(index+rangeSize)]
            if index + rangeSize >= productIDs.count {
                self.loadProducts(Array(range), completion)
            } else {
                self.loadProducts(Array(range), nil)
                self.loadBunchProducts(productIDs, index: index + rangeSize, size: size, completion: completion)
            }
        } else {
            self.completeWithData(nil, completion: completion)
        }
    }
    
    func handleModifiedProductsIDs(responseObject: AnyObject?, _ error: NSError?, _ completion: CompletionClosure?) {
        if error != nil {
            self.completeWithError(error, completion: completion)
            return
        }
        let timestamp = responseObject?["timestamp"] as? String
        if let productIDs = responseObject?["products"] as? [NSNumber] {
            DLog(FmtString("Number of modified products = %d",productIDs.count))
            // Load products
            self.loadBunchProducts(productIDs, index: 0, size: 1000, completion: { responseObject, error in
                self.setAppInfo(timestamp ?? "", forKey: Cons.App.lastRequestTimestampProductIDs)
                self.completeWithData(nil, completion: completion)
            })
        } else {
            self.completeWithData(nil, completion: completion)
        }
    }
    
    func requestModifiedProductIDs(completion: CompletionClosure?) {
        let timestamp = self.getAppInfo(Cons.App.lastRequestTimestampProductIDs)
        RequestManager.shared.requestModifiedProductIDs(
            timestamp,
            { responseObject in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    if let data = DataManager.getResponseData(responseObject) as? NSDictionary {
                        self.completeWithData(data, completion: completion)
                        return
                    }
                    self.completeWithError(FmtError(0, nil), completion: completion)
                }
            },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    func handleDeletedProductsIDs(responseObject: AnyObject?, _ error: NSError?, _ completion: CompletionClosure?) {
        if error != nil {
            self.completeWithError(error, completion: completion)
            return
        }
        if let productIDs = responseObject?["products"] as? [NSNumber] {
            DLog(FmtString("Number of deleted products = %d",productIDs.count))
            MagicalRecord.saveWithBlockAndWait({ (localContext) -> Void in
                if let products = Product.MR_findAllWithPredicate(FmtPredicate("id IN %@", productIDs), inContext: localContext) {
                    for product in products {
                        product.MR_deleteEntityInContext(localContext)
                    }
                }
            })
            let timestamp = responseObject?["timestamp"] as? String
            self.setAppInfo(timestamp ?? "", forKey: Cons.App.lastRequestTimestampDeletedProductIDs)
        }
        self.completeWithData(nil, completion: completion)
    }
    
    func requestDeletedProductIDs(completion: CompletionClosure?) {
        let timestamp = self.getAppInfo(Cons.App.lastRequestTimestampDeletedProductIDs)
        RequestManager.shared.requestDeletedProductIDs(
            timestamp,
            { responseObject in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    if let data = DataManager.getResponseData(responseObject) as? NSDictionary {
                        self.completeWithData(data, completion: completion)
                        return
                    }
                    self.completeWithError(FmtError(0, nil), completion: completion)
                }
            },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    func updateProducts(completion: CompletionClosure?) {
        self.requestModifiedProductIDs { responseObject, error in
            self.handleModifiedProductsIDs(responseObject, error) { responseObject, error in
                self.requestDeletedProductIDs() { responseObject, error in
                    self.handleDeletedProductsIDs(responseObject, error, completion)
                }
            }
            
        }
    }
    
    //////////////////////////////////////
    // MARK: Region
    //////////////////////////////////////
    
    func requestAllRegions(completion: CompletionClosure?) {
        RequestManager.shared.requestAllRegions(
            { responseObject in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                        Region.importDatas(data, { (_, _) -> () in
                            // Update all currencies based on all regions
                            CurrencyManager.shared.updateCurrencyRates(completion)
                        })
                    }
                }
            },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    //////////////////////////////////////
    // MARK: Store
    //////////////////////////////////////
    
    func requestAllStores(completion: CompletionClosure?) {
        let timestamp = self.getAppInfo(Cons.App.lastRequestTimestampStores)
        RequestManager.shared.requestAllStores(timestamp,
            { responseObject in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    if let data = DataManager.getResponseData(responseObject) as? NSDictionary {
                        // Import data
                        if let stores = data["stores"] as? [NSDictionary] {
                            DLog(FmtString("Number of modified stores = %d",stores.count))
                            Store.importDatas(stores, { (_, _) -> () in
                                // Succeeded to import, save timestamp for next request
                                let timestamp = data["timestamp"] as? String
                                self.setAppInfo(timestamp ?? "", forKey: Cons.App.lastRequestTimestampStores)
                            })
                        }
                    }
                    self.completeWithData(responseObject, completion: completion)
                }
            },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    //////////////////////////////////////
    // MARK: Update data
    //////////////////////////////////////
    
    func updateData(completion: CompletionClosure?) {
        if !self.isUpdatingData {
            self.isUpdatingData = true
            var count = 4
            
            let completionClosure: CompletionClosure = { responseObject, error in
                --count
                if count == 0 {
                    self.completeWithData(nil, completion: completion)
                    self.isUpdatingData = false
                }
            }
            
            // Preload data
            DataManager.shared.requestAllRegions(completionClosure)
            DataManager.shared.requestAllBrands(completionClosure)
            
            DataManager.shared.requestAllStores(completionClosure)
            DataManager.shared.updateProducts(completionClosure)
        }
    }
    
    //////////////////////////////////////
    // MARK: Helpers
    //////////////////////////////////////
    
    func getAppInfo(key: String) -> String? {
        var returnValue: String?
        MagicalRecord.saveWithBlockAndWait({ (localContext) -> Void in
            if let lastRequestTimestamp = AppData.MR_findFirstByAttribute("key", withValue: key, inContext: localContext) {
                returnValue = lastRequestTimestamp.value
            }
        })
        return returnValue
    }
    
    func setAppInfo(timestamp: String?, forKey key: String) {
        if let timestamp = timestamp {
            MagicalRecord.saveWithBlockAndWait({ (localContext) -> Void in
                var lastRequestTimestamp = AppData.MR_findFirstByAttribute("key", withValue: key, inContext: localContext)
                if lastRequestTimestamp == nil {
                    lastRequestTimestamp = AppData.MR_createEntityInContext(localContext)
                    lastRequestTimestamp?.key = key
                }
                lastRequestTimestamp?.value = timestamp
            })
        }
    }
}