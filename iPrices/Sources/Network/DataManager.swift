//
//  ServerManager.swift
//  iPrices
//
//  Created by CocoaBob on 23/12/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class DataManager {
    
    static let shared = DataManager()
    
    //////////////////////////////////////
    // MARK: General
    //////////////////////////////////////
    
    private func handleError(error: NSError?) {
        DLog(error)
    }
    
    private func getResponseData(responseObject: AnyObject?) -> AnyObject? {
        guard let responseObject = responseObject as? Dictionary<String, AnyObject> else { return nil }
        return responseObject["data"]
    }
    
    class func showRequestFailedAlert(error: NSError?) {
        let responseObject = AFNetworkingGetResponseObjectFromError(error)
        DLog(responseObject)
        // Show error
        if let responseObject = responseObject as? Dictionary<String, AnyObject>,
            let data = responseObject["data"] as? [String],
            let message = data.first
        {
            SCLAlertView().showError(NSLocalizedString("alert_title_failed"), subTitle: NSLocalizedString(message))
        }
    }
    
    //////////////////////////////////////
    // MARK: Currency
    //////////////////////////////////////
    
    func requestCurrencies(currencies: [NSDictionary], _ completion: DataClosure?) {
        RequestManager.shared.requestCurrencies(currencies,
            { (responseObject: AnyObject?) -> () in
                if let completion = completion {
                    completion((responseObject?["query"]))
                }
            },
            { (error: NSError?) -> () in
                self.handleError(error)
            }
        );
    }
    
    
    //////////////////////////////////////
    // MARK: Authentication
    //////////////////////////////////////
    
    func login(email: String, _ password: String, completion: ErrorClosure?) {
        RequestManager.shared.login(email, password,
            { (responseObject: AnyObject?) -> () in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    if let data = self.getResponseData(responseObject) as? NSDictionary {
                        UserManager.shared.logIn(data["token"]! as! String)
                        for (key, value) in data {
                            UserManager.shared[key as! String] = value
                        }
                    }
                    // Complete
                    if let completion = completion { completion(nil) }
                }
            },
            { (error: NSError?) -> () in
                self.handleError(error)
                // Complete, to hide ProgressHUD
                if let completion = completion { completion(error) }
            }
        )
    }
    
    func register(email: String, _ password: String, completion: ErrorClosure?) {
        RequestManager.shared.register(email, password,
            { (responseObject: AnyObject?) -> () in
                if let completion = completion { completion(nil) }
            },
            { (error: NSError?) -> () in
                self.handleError(error)
                // Complete, to hide ProgressHUD
                if let completion = completion { completion(error) }
            }
        )
    }
    
    func requestVerifyCode(email: String, completion: ErrorClosure?) {
        RequestManager.shared.requestVerifyCode(email,
            { (responseObject: AnyObject?) -> () in
                if let completion = completion { completion(nil) }
            },
            { (error: NSError?) -> () in
                self.handleError(error)
                // Complete, to hide ProgressHUD
                if let completion = completion { completion(error) }
            }
        )
    }
    
    func resetPassword(verifyCode: String, _ password: String, completion: ErrorClosure?) {
        RequestManager.shared.resetPassword(verifyCode, password,
            { (responseObject: AnyObject?) -> () in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    if let data = self.getResponseData(responseObject) as? NSDictionary {
                        UserManager.shared.logIn(data["token"]! as! String)
                        for (key, value) in data {
                            UserManager.shared[key as! String] = value
                        }
                    }
                    // Complete
                    if let completion = completion { completion(nil) }
                }
            },
            { (error: NSError?) -> () in
                self.handleError(error)
                // Complete, to hide ProgressHUD
                if let completion = completion { completion(error) }
            }
        )
    }
    
    
    //////////////////////////////////////
    // MARK: User
    //////////////////////////////////////
    
    func modifyEmail(email: String, completion: ErrorClosure?) {
        RequestManager.shared.modifyEmail(email,
            { (responseObject: AnyObject?) -> () in
                if let completion = completion { completion(nil) }
            },
            { (error: NSError?) -> () in
                self.handleError(error)
                // Complete, to hide ProgressHUD
                if let completion = completion { completion(error) }
            }
        )
    }
    
    func modifyUserInfo(field:String, _ value:String, completion: ErrorClosure?) {
        RequestManager.shared.modifyUserInfo(field, value,
            { (responseObject: AnyObject?) -> () in
                if let completion = completion { completion(nil) }
            },
            { (error: NSError?) -> () in
                self.handleError(error)
                // Complete, to hide ProgressHUD
                if let completion = completion { completion(error) }
            }
        )
    }
    
    //////////////////////////////////////
    // MARK: Products
    //////////////////////////////////////
    
    func loadAllBrands(completion: CompletionClosure?){
        RequestManager.shared.requestAllBrands(
            { (responseObject: AnyObject?) -> () in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    if let data = self.getResponseData(responseObject) as? [NSDictionary] {
                        Brand.importDatas(data, true)
                    }
                    // Complete
                    if let completion = completion { completion() }
                }
            },
            { (error: NSError?) -> () in
                self.handleError(error)
                // Complete
                if let completion = completion { completion() }
            }
        );
    }
    
    func loadProductInfo(id: String, _ completion: DataClosure?) {
        RequestManager.shared.requestProductInfo(id,
            { (responseObject: AnyObject?) -> () in
                if let completion = completion {
                    completion((responseObject?["data"]))
                }
            },
            { (error: NSError?) -> () in
                self.handleError(error)
            }
        );
    }
    
    //////////////////////////////////////
    // MARK: Favorites News
    //////////////////////////////////////
    
    func favoriteNews(id: NSNumber, wasFavorite: Bool, _ completion: DataClosure?) {
        RequestManager.shared.favoriteNews(id, operation: wasFavorite ? "-" : "+",
            { (responseObject: AnyObject?) -> () in
                if let completion = completion {
                    completion(responseObject?["data"])
                }
            },
            { (error: NSError?) -> () in
                self.handleError(error)
            }
        )
    }
    
    func requestNewsFavorites(completion: DataClosure?) {
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
                                favoriteIDs.removeAtIndex(index)
                            } else {
                                favoriteNews.MR_deleteEntityInContext(localContext)
                            }
                        }
                    }
                }
                // Request non-existing ones
                self.requestNews(favoriteIDs, { (responseObject: AnyObject?) -> () in
                    if let data = self.getResponseData(responseObject) as? [NSDictionary] {
                        FavoriteNews.importDatas(data, true, nil)
                    }
                })
            })
            
            if let completion = completion {
                completion(responseObject?["data"])
            }
        }
        let errorHandlerClosure = { (error: NSError?) -> () in
            self.handleError(error)
        }
        RequestManager.shared.requestNewsFavorites(responseHandlerClosure, errorHandlerClosure)
    }
    
    //////////////////////////////////////
    // MARK: Favorites Products
    //////////////////////////////////////
    
    func requestProductFavorites(categoryId: NSNumber?, _ completion: DataClosure?) {
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
            
            if let completion = completion {
                completion(responseObject?["data"])
            }
        }
        let errorHandlerClosure = { (error: NSError?) -> () in
            self.handleError(error)
        }
        if let categoryId = categoryId {
            RequestManager.shared.requestProductFavoritesByCategory(categoryId, responseHandlerClosure, errorHandlerClosure)
        } else {
            RequestManager.shared.requestProductFavorites(responseHandlerClosure, errorHandlerClosure)
        }
    }
    
    func favoriteProduct(id: NSNumber, isFavorite: Bool, _ completion: DataClosure?) {
        RequestManager.shared.favoriteProduct(id, operation: isFavorite ? "-" : "+",
            { (responseObject: AnyObject?) -> () in
                if let completion = completion {
                    completion(responseObject?["data"])
                }
            },
            { (error: NSError?) -> () in self.handleError(error) }
        )
    }
    
    //////////////////////////////////////
    // MARK: News
    //////////////////////////////////////
    
    func likeNews(id: NSNumber, wasLiked: Bool, _ completion: DataClosure?) {
        RequestManager.shared.likeNews(id, operation: wasLiked ? "-" : "+",
            { (responseObject: AnyObject?) -> () in
                if let completion = completion {
                    completion(responseObject?["data"])
                }
            },
            { (error: NSError?) -> () in self.handleError(error) }
        )
    }
    
    func requestNewsList(relativeID: NSNumber?, _ completion: CompletionClosure?) {
        RequestManager.shared.requestNewsList(Cons.Svr.reqCnt, relativeID,
            { (responseObject: AnyObject?) -> () in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    if let data = self.getResponseData(responseObject) as? [NSDictionary] {
                        News.importDatas(data, false, relativeID)
                    }
                    // Complete
                    if let completion = completion { completion() }
                }
            },
            { (error: NSError?) -> () in self.handleError(error) }
        );
    }
    
    func requestNewsByID(id: NSNumber, _ completion: CompletionClosure?) {
        RequestManager.shared.requestNewsByID(id,
            { (responseObject: AnyObject?) -> () in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    if let data = self.getResponseData(responseObject) as? NSDictionary {
                        News.importData(data, true, nil)
                    }
                    // Complete
                    if let completion = completion { completion() }
                }
            },
            { (error: NSError?) -> () in
                self.handleError(error)
                // Complete, to hide ProgressHUD
                if let completion = completion { completion() }
            }
        );
    }
    
    func requestNews(ids: [NSNumber], _ completion: DataClosure?) {
        RequestManager.shared.requestNews(ids,
            { (responseObject: AnyObject?) -> () in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    // Complete
                    if let completion = completion { completion(responseObject) }
                }
            },
            { (error: NSError?) -> () in self.handleError(error) }
        );
    }
    
    func loadNewsInfo(id: NSNumber, _ completion: DataClosure?) {
        RequestManager.shared.requestNewsInfo(id,
            { (responseObject: AnyObject?) -> () in
                if let completion = completion {
                    completion((responseObject?["data"]))
                }
            },
            { (error: NSError?) -> () in
                self.handleError(error)
            }
        );
    }
    
    //////////////////////////////////////
    // MARK: Notification
    //////////////////////////////////////
    
    func registerForNotification(deviceToken: String) {
        RequestManager.shared.registerForNotification(UserManager.shared.uuid, deviceToken,
            { (responseObject: AnyObject?) -> () in
                UserManager.shared.deviceToken = deviceToken
                DLog("Push register success")
            },
            { (error: NSError?) -> () in self.handleError(error) }
        );
    }
    
    //////////////////////////////////////
    // MARK: Products
    //////////////////////////////////////
    
    func translateProduct(id: NSNumber, _ completion: DataClosure?) {
        RequestManager.shared.translateProduct(id,
            { (responseObject: AnyObject?) -> () in
                if let completion = completion {
                    completion(responseObject?["data"])
                }
            },
            { (error: NSError?) -> () in
                self.handleError(error)
                // Completion, to hide ProgressHUD
                if let completion = completion {
                    completion(nil)
                }
            }
        )
    }
    
    func likeProduct(id: NSNumber, wasLiked: Bool, _ completion: DataClosure?) {
        RequestManager.shared.likeProduct(id, operation: wasLiked ? "-" : "+",
            { (responseObject: AnyObject?) -> () in
                if let completion = completion {
                    completion(responseObject?["data"])
                }
            },
            { (error: NSError?) -> () in
                self.handleError(error)
            }
        )
    }
    
    func loadProducts(ids: [NSNumber], _ completion: CompletionClosure?) {
        RequestManager.shared.requestProducts(ids,
            { (responseObject: AnyObject?) -> () in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    if let data = self.getResponseData(responseObject) as? [NSDictionary] {
                        Product.importDatas(data, true)
                    }
                    // Complete
                    if let completion = completion { completion() }
                }
            },
            { (error: NSError?) -> () in
                self.handleError(error)
                // Complete
                if let completion = completion { completion() }
            }
        )
    }
    
    func loadAllProductIDs(completion: CompletionClosure?) {
        RequestManager.shared.requestAllProductIDs(
            { (responseObject: AnyObject?) -> () in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    if let data = self.getResponseData(responseObject) as? [NSDictionary] {
                        Product.importDatas(data, false)
                    }
                    // Complete
                    if let completion = completion { completion() }
                }
            },
            { (error: NSError?) -> () in
                self.handleError(error)
                // Complete
                if let completion = completion { completion() }
            }
        );
    }
    
    // Helper method
    func loadBunchProducts(productIDs: [NSNumber], index: Int, size: Int, completion: CompletionClosure?) {
        if index >= productIDs.count {
            return
        }
        let rangeSize = ((index + size) > productIDs.count) ? (productIDs.count - index) : size
        DLog(FmtString("count=%d index=%d size=%d rangeSize=%d", productIDs.count, index, size, rangeSize));
        if rangeSize > 0 {
            let range = productIDs[index..<(index+rangeSize)]
            if index + rangeSize >= productIDs.count {
                self.loadProducts(Array(range), completion)
            } else {
                self.loadProducts(Array(range), nil)
                self.loadBunchProducts(productIDs, index: index + rangeSize, size: size, completion: completion)
            }
        }
    }
    
    func loadAllProducts(completion: CompletionClosure?) {
        self.loadAllProductIDs { () -> () in
            // Collect product ids
            var productIDs = [NSNumber]()
            MagicalRecord.saveWithBlockAndWait({ (localContext) -> Void in
                if let allNotUpdatedProducts = Product.MR_findAllWithPredicate(
                    FmtPredicate("appIsUpdated == %@", NSNumber(bool: false)),
                    inContext: localContext) {
                        productIDs = allNotUpdatedProducts.map { (product) -> NSNumber in
                            return (product as! Product).id!
                        }
                }
            })
            
            // Load products
            self.loadBunchProducts(productIDs, index: 0, size: 1024, completion: completion)
        }
    }
    
    private var isLoading = false
    
    func prefetchData() {
        var needsToLoad = true
        if let lastUpdateDate = NSUserDefaults.standardUserDefaults().objectForKey(Cons.App.lastUpdateDate) as? NSDate {
            needsToLoad = NSDate().timeIntervalSinceDate(lastUpdateDate) > 60 * 60 * 24
        }
        
        if needsToLoad && !isLoading {
            self.isLoading = true
            var count = 2
            let completionClosure = {
                --count
                DLog("PrefetchData Completion Closure count == \(count)")
                if count == 0 {
                    self.isLoading = false
                    NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: Cons.App.lastUpdateDate)
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
            }
            
            // Preload data
            DataManager.shared.loadAllBrands({ () -> () in
                completionClosure()
            })
            DataManager.shared.loadAllProducts({ () -> () in
                completionClosure()
            })
        }
    }
}