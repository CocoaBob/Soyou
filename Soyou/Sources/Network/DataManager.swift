//
//  ServerManager.swift
//  Soyou
//
//  Created by CocoaBob on 23/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class DataManager {
    
    static let shared = DataManager()
    
    var isUpdatingData = false
    
    //////////////////////////////////////
    // MARK: General
    //////////////////////////////////////
    
    private func handleError(error: NSError?) {
        DLog(error)
        
        if let response = error?.userInfo[AFNetworkingOperationFailingURLResponseErrorKey],
            statusCode = response.statusCode {
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
    
    func requestCurrencies(currencies: [NSDictionary], _ completion: CompletionClosure?) {
        RequestManager.shared.requestCurrencies(currencies,
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
                        Brand.importDatas(data, true)
                    }
                    self.completeWithData(responseObject, completion: completion)
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
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                // Collect all products and favorite ids
                let allFavoriteNews = FavoriteNews.MR_findAllInContext(localContext) as? [FavoriteNews]
                var favoriteIDs = [NSNumber]()
                if let data = responseObject?["data"] as? [NSNumber] {
                    favoriteIDs.appendContentsOf(data)
                }
                // Filter all existing ones, delete remotely deleted ones.
                if let allFavoritesNews = allFavoriteNews {
                    for favoriteNews in allFavoritesNews {
                        if let newsID = favoriteNews.id {
                            if let index = favoriteIDs.indexOf(newsID) {
                                if favoriteNews.appIsUpdated != nil && favoriteNews.appIsUpdated!.boolValue {
                                    favoriteIDs.removeAtIndex(index)
                                }
                            } else {
                                favoriteNews.MR_deleteEntityInContext(localContext)
                            }
                        }
                    }
                }
                // Request non-existing ones
                if favoriteIDs.count > 0 {
                    self.requestNews(favoriteIDs, { responseObject, error in
                        if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                            FavoriteNews.importDatas(data, false, nil)
                        }
                    })
                }
            })
            
            self.completeWithData(responseObject, completion: completion)
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
    
    func requestProductFavorites(categoryId: NSNumber?, _ completion: CompletionClosure?) {
        let responseHandlerClosure = { (responseObject: AnyObject?) -> () in
            MagicalRecord.saveWithBlockAndWait({ (localContext: NSManagedObjectContext!) -> Void in
                // Collect all products and favorite ids
                var allProducts: [Product]?
                var favoriteIDs = [NSNumber]()
                if let categoryId = categoryId {
                    allProducts = Product.MR_findAllWithPredicate(FmtPredicate("categories CONTAINS %@", FmtString("|%@|",categoryId)), inContext: localContext) as? [Product]
                    if let data = responseObject?["data"] as? [NSDictionary] {
                        for dict in data {
                            favoriteIDs.append(dict["productId"] as! NSNumber)
                        }
                    }
                } else {
                    allProducts = Product.MR_findAllInContext(localContext) as? [Product]
                    if let data = responseObject?["data"] as? [NSNumber] {
                        favoriteIDs.appendContentsOf(data)
                    }
                }
                // Update .appIsFavorite
                if let allProducts = allProducts {
                    for product in allProducts {
                        product.appIsFavorite = favoriteIDs.contains(product.id!)
                    }
                }
            })
            
            self.completeWithData(responseObject, completion: completion)
        }
        let errorHandlerClosure = { (error: NSError?) -> () in
            self.completeWithError(error, completion: completion)
        }
        
        if let categoryId = categoryId {
            RequestManager.shared.requestProductFavoritesByCategory(categoryId, responseHandlerClosure, errorHandlerClosure)
        } else {
            RequestManager.shared.requestProductFavorites(responseHandlerClosure, errorHandlerClosure)
        }
    }
    
    func favoriteProduct(id: NSNumber, isFavorite: Bool, _ completion: CompletionClosure?) {
        RequestManager.shared.favoriteProduct(id, operation: isFavorite ? "-" : "+",
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
                        News.importDatas(data, false, relativeID)
                    }
                    self.completeWithData(responseObject, completion: completion)
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
                        Product.importDatas(data)
                    }
                    self.completeWithData(responseObject, completion: completion)
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
            self.loadBunchProducts(productIDs, index: 0, size: 500, completion: { responseObject, error in
                self.updateTimestamp(timestamp, key: Cons.App.lastRequestTimestampProductIDs)
                self.completeWithData(nil, completion: completion)
            })
        } else {
            self.completeWithData(nil, completion: completion)
        }
    }
    
    func requestModifiedProductIDs(completion: CompletionClosure?) {
        let timestamp = self.timestamp(Cons.App.lastRequestTimestampProductIDs)
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
            self.updateTimestamp(timestamp, key: Cons.App.lastRequestTimestampDeletedProductIDs)
        }
        self.completeWithData(nil, completion: completion)
    }
    
    func requestDeletedProductIDs(completion: CompletionClosure?) {
        let timestamp = self.timestamp(Cons.App.lastRequestTimestampDeletedProductIDs)
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
        var _error: NSError?
        self.requestModifiedProductIDs { responseObject, error in
            self.handleModifiedProductsIDs(responseObject, error) { responseObject, error in
                _error = error
                self.requestDeletedProductIDs() { responseObject, error in
                    self.handleDeletedProductsIDs(responseObject, error, { responseObject, error in
                        self.completeWithData(_error ?? error, completion: completion)
                    })
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
                        Region.importDatas(data)
                    }
                    self.completeWithData(responseObject, completion: completion)
                }
            },
            { error in self.completeWithError(error, completion: completion) }
        )
    }
    
    //////////////////////////////////////
    // MARK: Store
    //////////////////////////////////////
    
    func requestAllStores(completion: CompletionClosure?) {
        let timestamp = self.timestamp(Cons.App.lastRequestTimestampStores)
        RequestManager.shared.requestAllStores(timestamp,
            { responseObject in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    if let data = DataManager.getResponseData(responseObject) as? NSDictionary {
                        // Import data
                        if let stores = data["stores"] as? [NSDictionary] {
                            DLog(FmtString("Number of modified stores = %d",stores.count))
                            Store.importDatas(stores)
                        }
                        // Succeeded to import, save timestamp for next request
                        self.updateTimestamp(data["timestamp"] as? String, key: Cons.App.lastRequestTimestampStores)
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
            var hasError = false
            
            let completionClosure: CompletionClosure = { responseObject, error in
                if error != nil {
                    hasError = true
                }
                --count
                if count == 0 {
                    self.completeWithData(nil, completion: completion)
                    self.isUpdatingData = false
                    if !hasError {
                        NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: Cons.App.lastUpdateDate)
                        NSUserDefaults.standardUserDefaults().synchronize()
                    }
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
    
    func timestamp(key: String) -> String? {
        var returnValue: String?
        MagicalRecord.saveWithBlockAndWait({ (localContext) -> Void in
            if let lastRequestTimestamp = AppData.MR_findFirstByAttribute("key", withValue: key, inContext: localContext) {
                returnValue = lastRequestTimestamp.value
            }
        })
        return returnValue
    }
    
    func updateTimestamp(timestamp: String?, key: String) {
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