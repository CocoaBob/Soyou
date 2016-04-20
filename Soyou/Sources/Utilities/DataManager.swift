//
//  ServerManager.swift
//  Soyou
//
//  Created by CocoaBob on 23/12/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class DataManager {
    
    static let shared = DataManager()
    
    var isUpdatingData = false {
        didSet {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = isUpdatingData
        }
    }
    
    //////////////////////////////////////
    // MARK: General
    //////////////////////////////////////
    
    private func handleError(error: NSError?) {
        DLog(error)
        
        if let response = error?.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] as? NSHTTPURLResponse {
            // If 401 error, logout
            if response.statusCode == 401 {
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
            SCLAlertView().showError(UIApplication.sharedApplication().keyWindow?.rootViewController?.toppestViewController(),
                                     title: NSLocalizedString("alert_title_failed"),
                                     subTitle: NSLocalizedString(message),
                                     closeButtonTitle: NSLocalizedString("alert_button_ok"),
                                     duration: 0.0)
        } else {
            SCLAlertView().showError(UIApplication.sharedApplication().keyWindow?.rootViewController?.toppestViewController(),
                                     title: NSLocalizedString("alert_title_failed"),
                                     subTitle: error?.localizedDescription ?? "",
                                     closeButtonTitle: NSLocalizedString("alert_button_ok"),
                                     duration: 0.0)
        }
    }
    
    //////////////////////////////////////
    // MARK: Currency
    //////////////////////////////////////
    
    func requestCurrencyChanges(currencies: [NSDictionary], _ completion: CompletionClosure?) {
        RequestManager.shared.requestCurrencyChanges(currencies, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    
    //////////////////////////////////////
    // MARK: Authentication
    //////////////////////////////////////
    
    func checkToken() {
        RequestManager.shared.checkToken({ responseObject in
            self.completeWithData(responseObject, completion: nil)
        }, { error in
            self.completeWithError(error, completion: nil)
        })
    }
    
    func login(email: String, _ password: String, _ completion: CompletionClosure?) {
        RequestManager.shared.login(email, password, { responseObject in
            if let data = DataManager.getResponseData(responseObject) as? NSDictionary {
                for (key, value) in data {
                    if let key = key as? String {
                        UserManager.shared[key] = value
                    }
                }
                if let token = data["token"]! as? String {
                    UserManager.shared.logIn(token)
                }
            }
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func register(email: String, _ password: String, _ gender: String, _ completion: CompletionClosure?) {
        RequestManager.shared.register(email, password, gender, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func loginThird(type: String, _ accessToken: String, _ thirdId: String, _ username: String?, _ gender: String?, _ completion: CompletionClosure?) {
        RequestManager.shared.loginThird(type, accessToken, thirdId, username ?? "", gender ?? "", { responseObject in
            DLog(responseObject)
            if let data = DataManager.getResponseData(responseObject) as? NSDictionary {
                for (key, value) in data {
                    if let key = key as? String {
                        UserManager.shared[key] = value
                    }
                }
                if let token = data["token"]! as? String {
                    UserManager.shared.logIn(token)
                }
            }
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestVerifyCode(email: String, _ completion: CompletionClosure?) {
        RequestManager.shared.requestVerifyCode(email, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func resetPassword(verifyCode: String, _ password: String, _ completion: CompletionClosure?) {
        RequestManager.shared.resetPassword(verifyCode, password, { responseObject in
            if let data = DataManager.getResponseData(responseObject) as? NSDictionary {
                if let token = data["token"]! as? String {
                    UserManager.shared.logIn(token)
                }
                for (key, value) in data {
                    if let key = key as? String {
                        UserManager.shared[key] = value
                    }
                }
            }
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    
    //////////////////////////////////////
    // MARK: User
    //////////////////////////////////////
    
    func modifyEmail(email: String, _ completion: CompletionClosure?) {
        RequestManager.shared.modifyEmail(email, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func modifyUserInfo(field:String, _ value:String, _ completion: CompletionClosure?) {
        RequestManager.shared.modifyUserInfo(field, value, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    //////////////////////////////////////
    // MARK: Products
    //////////////////////////////////////
    
    func requestAllBrands(completion: CompletionClosure?) {
        RequestManager.shared.requestAllBrands({ responseObject in
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
                        // Notify observers
                        NSNotificationCenter.defaultCenter().postNotificationName(Cons.DB.brandsUpdatingDidFinishNotification, object: nil)
                    })
                } else {
                    self.completeWithData(responseObject, completion: completion)
                }
            }, { error in
                self.completeWithError(error, completion: completion)
        })
    }
    
    func requestProductInfo(id: String, _ completion: CompletionClosure?) {
        RequestManager.shared.requestProductInfo(id, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    //////////////////////////////////////
    // MARK: Favorites News
    //////////////////////////////////////
    
    func favoriteNews(id: NSNumber, wasFavorite: Bool, _ completion: CompletionClosure?) {
        RequestManager.shared.favoriteNews(id, operation: wasFavorite ? "-" : "+", { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestNewsFavorites(completion: CompletionClosure?) {
        let responseHandlerClosure = { (responseObject: AnyObject?) -> () in
            if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                FavoriteNews.updateWithData(data, completion)
            } else {
                self.completeWithError(FmtError(0, nil), completion: completion)
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
            if let responseObject = responseObject as? [String:AnyObject],
                data = responseObject["data"] as? [NSDictionary] {
                FavoriteProduct.updateWithData(data, completion)
            }
        }
        let errorHandlerClosure = { (error: NSError?) -> () in
            self.completeWithError(error, completion: completion)
        }
        
        RequestManager.shared.requestProductFavorites(responseHandlerClosure, errorHandlerClosure)
    }
    
    func favoriteProduct(id: NSNumber, wasFavorite: Bool, _ completion: CompletionClosure?) {
        RequestManager.shared.favoriteProduct(id, operation: wasFavorite ? "-" : "+", { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    //////////////////////////////////////
    // MARK: News
    //////////////////////////////////////
    
    func likeNews(id: NSNumber, wasLiked: Bool, _ completion: CompletionClosure?) {
        RequestManager.shared.likeNews(id, operation: wasLiked ? "-" : "+", { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestNewsList(relativeID: NSNumber?, _ completion: CompletionClosure?) {
        RequestManager.shared.requestNewsList(Cons.Svr.reqCnt, relativeID, { responseObject in
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
                    // Notify observers
                    NSNotificationCenter.defaultCenter().postNotificationName(Cons.DB.newsUpdatingDidFinishNotification, object: nil)
                })
            } else {
                self.completeWithError(FmtError(0, nil), completion: completion)
            }
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestNewsByID(id: NSNumber, _ completion: CompletionClosure?) {
        RequestManager.shared.requestNewsByID(id, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestNews(ids: [NSNumber], _ completion: CompletionClosure?) {
        RequestManager.shared.requestNews(ids, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestNewsInfo(id: NSNumber, _ completion: CompletionClosure?) {
        RequestManager.shared.requestNewsInfo(id, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    //////////////////////////////////////
    // MARK: Notification
    //////////////////////////////////////
    
    func registerForNotification() {
        // If hasn't registered
        if !UserDefaults.boolForKey(Cons.App.hasRegisteredForNotification) {
            // Get the last device token
            if let deviceToken = UserManager.shared.deviceToken {
                // Register to server
                RequestManager.shared.registerForNotification(UserManager.shared.uuid, deviceToken, { responseObject in
                    UserDefaults.setBool(true, forKey: Cons.App.hasRegisteredForNotification)
                }, { error in
                    UserDefaults.setBool(false, forKey: Cons.App.hasRegisteredForNotification)
                    self.completeWithError(error, completion: nil)
                })
            }
        }
    }
    
    //////////////////////////////////////
    // MARK: Products
    //////////////////////////////////////
    
    func translateProduct(id: NSNumber, _ completion: CompletionClosure?) {
        RequestManager.shared.translateProduct(id, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func likeProduct(id: NSNumber, wasLiked: Bool, _ completion: CompletionClosure?) {
        RequestManager.shared.likeProduct(id, operation: wasLiked ? "-" : "+", { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    var _requestProductIDs = [NSNumber]()
    var _requestProductsIndex = 0
    var _requestProductsSize = 0
    var _requestProductsCompletionHandler: CompletionClosure?
    var _requestProductsError: NSError?
    var _requestProductsImportedIndex = 0
    
    var _requestProductsQueue: NSOperationQueue?
    private func requestProductsQueue() -> NSOperationQueue {
        if _requestProductsQueue == nil {
            _requestProductsQueue = NSOperationQueue()
            _requestProductsQueue?.maxConcurrentOperationCount = 1
        }
        return _requestProductsQueue ?? NSOperationQueue()
    }
    
    var _importProductsQueue: NSOperationQueue?
    private func importProductsQueue() -> NSOperationQueue {
        if _importProductsQueue == nil {
            _importProductsQueue = NSOperationQueue()
            _importProductsQueue?.maxConcurrentOperationCount = NSProcessInfo.processInfo().activeProcessorCount
        }
        return _importProductsQueue ?? NSOperationQueue()
    }
    
    private func requestNextProducts() {
        // No need to request more if it's requesting, or we are waiting for importing
        if (self.requestProductsQueue().operations.count > 1 ||
            self.importProductsQueue().operations.count > NSProcessInfo.processInfo().activeProcessorCount) {
            return
        }
        
        self.requestProductsQueue().addOperationWithBlock {
            // Error
            if self._requestProductsError != nil {
                self.completeWithError(self._requestProductsError, completion: self._requestProductsCompletionHandler)
                return
            }
            
            let index = self._requestProductsIndex
            let size = self._requestProductsSize
            let totalCount = self._requestProductIDs.count
            let rangeSize = ((index + size) > totalCount) ? (totalCount - index) : size
            
            // Finished
            if index >= totalCount {
                return
            }
            
            DLog(FmtString("count=%d index=%d size=%d rangeSize=%d", totalCount, index, size, rangeSize))
            if rangeSize < 0 {
                self._requestProductsError = FmtError(0, nil)
                return
            }
            
            let rangeIDs = self._requestProductIDs[index..<(index+rangeSize)]
            let ids = Array(rangeIDs)
            self._requestProductsIndex += rangeSize
            RequestManager.shared.requestProducts(ids, { responseObject in
                if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                    self.importProducts(data)
                } else {
                    self._requestProductsError = FmtError(0, nil)
                }
                
                // Request next
                self.requestNextProducts()
            }, { error in
                self._requestProductsError = error
                
                // Request next
                self.requestNextProducts()
            })
        }
    }
    
    private func importProducts(data: [NSDictionary]?) {
        self.importProductsQueue().addOperationWithBlock {
            // Error
            if self._requestProductsError != nil {
                self.completeWithError(self._requestProductsError, completion: self._requestProductsCompletionHandler)
                return
            }
            
            Product.importDatas(data, { (_, error) in
                if error != nil {
                    self._requestProductsError = error
                }
                
                // Update progress
                self._requestProductsImportedIndex += data?.count ?? 0
                dispatch_async(dispatch_get_main_queue()) {
                    self.updateProductsProgress(self._requestProductsImportedIndex, total: self._requestProductIDs.count)
                }
                
                // Request next
                if self._requestProductsImportedIndex >= self._requestProductIDs.count {
                    self.completeWithData(nil, completion: self._requestProductsCompletionHandler)
                } else {
                    self.requestNextProducts()
                }
            })
        }
    }
    
    // Helper methods for Products
    private func loadProducts(productIDs: [NSNumber], index: Int, size: Int, completion: CompletionClosure?) {
        _requestProductIDs = productIDs
        _requestProductsIndex = index
        _requestProductsSize = size
        _requestProductsCompletionHandler = completion
        _requestProductsError = nil
        _requestProductsImportedIndex = 0
        
        let totalCount = productIDs.count
        if index >= totalCount {
            self.completeWithError(FmtError(0, nil), completion: completion)
            return
        }
        
        // Request next
        dispatch_async(dispatch_get_main_queue()) {
            self.updateProductsProgress(0, total: self._requestProductIDs.count)
        }
        self.requestNextProducts()
    }
    
    private func handleModifiedProductsIDs(responseObject: AnyObject?, _ error: NSError?, _ completion: CompletionClosure?) {
        if error != nil {
            self.completeWithError(error, completion: completion)
            return
        }
        if let responseObject = responseObject as? [String:AnyObject],
            timestamp = responseObject["timestamp"] as? String,
            productIDs = responseObject["products"] as? [NSNumber] {
            DLog(FmtString("Number of modified products = %d",productIDs.count))
            // Load products
            self.loadProducts(productIDs, index: 0, size: 1000, completion: { responseObject, error in
                self.updateProductsProgress((error != nil ? -1 : 1), total: 1)
                if error == nil {
                    // If no error, save the last request timestamp
                    self.setAppInfo(timestamp ?? "", forKey: Cons.DB.lastRequestTimestampProductIDs)
                    self.completeWithData(nil, completion: completion)
                } else {
                    self.completeWithError(error, completion: completion)
                }
            })
        } else {
            self.completeWithData(FmtError(0, nil), completion: completion)
        }
    }
    
    private func requestModifiedProductIDs(completion: CompletionClosure?) {
        let timestamp = self.getAppInfo(Cons.DB.lastRequestTimestampProductIDs)
        DLog(FmtString("lastRequestTimestampProductIDs = %@",timestamp ?? ""))
        RequestManager.shared.requestModifiedProductIDs(
            timestamp, { responseObject in
                if let data = DataManager.getResponseData(responseObject) as? NSDictionary {
                    self.completeWithData(data, completion: completion)
                } else {
                    self.completeWithError(FmtError(0, nil), completion: completion)
                }
            }, { error in
                self.completeWithError(error, completion: completion)
        })
    }
    
    private func handleDeletedProductsIDs(responseObject: AnyObject?, _ error: NSError?, _ completion: CompletionClosure?) {
        if error != nil {
            self.completeWithError(error, completion: completion)
            return
        }
        if let responseObject = responseObject as? [String:AnyObject],
            productIDs = responseObject["products"] as? [NSNumber] {
            DLog(FmtString("Number of deleted products = %d",productIDs.count))
            let timestamp = responseObject["timestamp"] as? String
            self.setAppInfo(timestamp ?? "", forKey: Cons.DB.lastRequestTimestampDeletedProductIDs)
            MagicalRecord.saveWithBlock({ (localContext) -> Void in
                Product.MR_deleteAllMatchingPredicate(FmtPredicate("id IN %@", productIDs), inContext: localContext)
                }, completion: { (_, _) -> Void in
                    self.completeWithData(nil, completion: completion)
                    // Notify observers
                    NSNotificationCenter.defaultCenter().postNotificationName(Cons.DB.productsUpdatingDidFinishNotification, object: nil)
            })
        } else {
            self.completeWithError(FmtError(0, nil), completion: completion)
        }
    }
    
    private func requestDeletedProductIDs(error: NSError?, _ completion: CompletionClosure?) {
        if error != nil {
            self.completeWithError(error, completion: completion)
            return
        }
        let timestamp = self.getAppInfo(Cons.DB.lastRequestTimestampDeletedProductIDs)
        DLog(FmtString("lastRequestTimestampDeletedProductIDs = %@",timestamp ?? ""))
        RequestManager.shared.requestDeletedProductIDs(
            timestamp, { responseObject in
                if let data = DataManager.getResponseData(responseObject) as? NSDictionary {
                    self.completeWithData(data, completion: completion)
                } else {
                    self.completeWithError(FmtError(0, nil), completion: completion)
                }
            }, { error in
                self.completeWithError(error, completion: completion)
        })
    }
    
    func updateProducts(completion: CompletionClosure?) {
        self.requestModifiedProductIDs { responseObject, error in
            self.handleModifiedProductsIDs(responseObject, error) { responseObject, error in
                self.requestDeletedProductIDs(error) { responseObject, error in
                    self.handleDeletedProductsIDs(responseObject, error, completion)
                }
            }
        }
    }
    
    //////////////////////////////////////
    // MARK: Region
    //////////////////////////////////////
    
    func requestAllRegions(completion: CompletionClosure?) {
        RequestManager.shared.requestAllRegions({ responseObject in
            if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                Region.importDatas(data, { (_, _) -> () in
                    // Update all currencies based on all regions
                    CurrencyManager.shared.updateCurrencyRates(CurrencyManager.shared.userCurrency, completion)
                })
            } else {
                self.completeWithError(FmtError(0, nil), completion: completion)
            }
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    //////////////////////////////////////
    // MARK: Store
    //////////////////////////////////////
    
    func requestAllStores(completion: CompletionClosure?) {
        let timestamp = self.getAppInfo(Cons.DB.lastRequestTimestampStores)
        DLog(FmtString("lastRequestTimestampStores = %@",timestamp ?? ""))
        RequestManager.shared.requestAllStores(timestamp, { responseObject in
            if let data = DataManager.getResponseData(responseObject) as? NSDictionary,
                let stores = data["stores"] as? [NSDictionary] {
                // Import data
                DLog(FmtString("Number of modified stores = %d",stores.count))
                Store.importDatas(stores, { (_, _) -> () in
                    // Succeeded to import, save timestamp for next request
                    let timestamp = data["timestamp"] as? String
                    self.setAppInfo(timestamp ?? "", forKey: Cons.DB.lastRequestTimestampStores)
                    self.completeWithData(responseObject, completion: completion)
                })
            } else {
                self.completeWithError(FmtError(0, nil), completion: completion)
            }
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    //////////////////////////////////////
    // MARK: Update data
    //////////////////////////////////////
    
    func updateData(completion: CompletionClosure?) {
        if !self.isUpdatingData {
            // If it's more than 1 day since the last update
            if let lastUpdateDate = UserDefaults.objectForKey(Cons.App.lastUpdateDate) as? NSDate {
                if NSDate().timeIntervalSinceDate(lastUpdateDate) < Cons.App.updateInterval {
                    return
                }
            }
            
            self.isUpdatingData = true
            var cnt = 4
            var hasError = false
            let completionClosure: CompletionClosure = { responseObject, error in
                cnt -= 1
                DLog(cnt)
                if error != nil {
                    hasError = true
                }
                if cnt == 0 {
                    // Completed
                    self.completeWithData(nil, completion: completion)
                    self.isUpdatingData = false
                    
                    // If there was no error
                    if !hasError {
                        UserDefaults.setObject(NSDate(), forKey: Cons.App.lastUpdateDate)
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
    
    var _isWTStatusBarVisible = false
    func updateProductsProgress(current: Int, total: Int) {
        WTStatusBar.setBackgroundColor(UIColor(hex: Cons.UI.colorBGNavBar))
        WTStatusBar.setProgressBarColor(UIColor(hex: Cons.UI.colorTheme))
        WTStatusBar.setTextColor(UIColor.darkGrayColor())
        if current == -1 {
            if (_isWTStatusBarVisible) {
                WTStatusBar.setStatusText(NSLocalizedString("data_manager_data_update_failed"), timeout: 1, animated: true)
                _isWTStatusBarVisible = false
            }
        } else {
            let progress = CGFloat(current) / CGFloat(total)
            WTStatusBar.setProgress(progress, animated: true)
            if progress < 1 {
                if !_isWTStatusBarVisible {
                    _isWTStatusBarVisible = true
                    WTStatusBar.setStatusText(NSLocalizedString("data_manager_updating_data"))
                }
            } else if (_isWTStatusBarVisible) {
                WTStatusBar.setStatusText(NSLocalizedString("data_manager_data_update_succeeded"), timeout: 1, animated: true)
                _isWTStatusBarVisible = false
            }
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
    
    //////////////////////////////////////
    // MARK: Analytics
    //////////////////////////////////////
    
    func analyticsAppBecomeActive() {
        RequestManager.shared.sendAnalyticsData(NSNumber(integer: 3), NSNumber(integer: 6), "null", { responseObject in
            DLog(responseObject)
        }, { error in
            self.completeWithError(error, completion: nil)
        })
    }
}
