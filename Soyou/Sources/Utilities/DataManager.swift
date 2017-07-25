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
            UIApplication.shared.isNetworkActivityIndicatorVisible = isUpdatingData
        }
    }
    
    //////////////////////////////////////
    // MARK: General
    //////////////////////////////////////
    
    fileprivate func handleError(_ error: NSError?) {
        DLog(error)
        
        if let response = (error as NSError?)?.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] as? HTTPURLResponse {
            // If 401 error, logout
            if response.statusCode == 401 {
                UserManager.shared.logOut()
            }
        }
    }
    
    fileprivate func completeWithData(_ data: Any?, completion: CompletionClosure?) {
        if let completion = completion { completion(data, nil) }
    }
    
    fileprivate func completeWithError(_ error: NSError?, completion: CompletionClosure?) {
        self.handleError(error)
        if let completion = completion { completion(nil, error) }
    }
    
    class func getResponseData(_ responseObject: Any?) -> Any? {
        guard let responseObject = responseObject as? Dictionary<String, Any> else { return nil }
        return responseObject["data"]
    }
    
    class func showRequestFailedAlert(_ error: NSError?) {
        let responseObject = AFNetworkingGetResponseObjectFromError(error as NSError?)
        DLog(responseObject)
        // Show error
        if let responseObject = responseObject as? Dictionary<String, Any>,
            let data = responseObject["data"] as? [String],
            let message = data.first {
            SCLAlertView().showError(NSLocalizedString("alert_title_failed"), subTitle: NSLocalizedString(message), closeButtonTitle: NSLocalizedString("alert_button_ok"))
        } else {
            SCLAlertView().showError(NSLocalizedString("alert_title_failed"), subTitle: error?.localizedDescription ?? "", closeButtonTitle: NSLocalizedString("alert_button_ok"))
        }
    }
    
    //////////////////////////////////////
    // MARK: Currency
    //////////////////////////////////////
    
    func requestCurrencyChanges(_ currencies: [NSDictionary], _ completion: CompletionClosure?) {
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
    
    func login(_ email: String, _ password: String, _ completion: CompletionClosure?) {
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
    
    func logout(_ completion: CompletionClosure?) {
        RequestManager.shared.logout({ responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func register(_ email: String, _ password: String, _ gender: String, _ completion: CompletionClosure?) {
        RequestManager.shared.register(email, password, gender, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func loginThird(_ type: String, _ accessToken: String, _ thirdId: String, _ username: String?, _ gender: String?, _ completion: CompletionClosure?) {
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
    
    func requestVerifyCode(_ email: String, _ completion: CompletionClosure?) {
        RequestManager.shared.requestVerifyCode(email, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func resetPassword(_ verifyCode: String, _ password: String, _ completion: CompletionClosure?) {
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
    
    func modifyEmail(_ email: String, _ completion: CompletionClosure?) {
        RequestManager.shared.modifyEmail(email, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func modifyUserInfo(_ field:String, _ value:String, _ completion: CompletionClosure?) {
        RequestManager.shared.modifyUserInfo(field, value, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    //////////////////////////////////////
    // MARK: Products
    //////////////////////////////////////
    
    func requestAllBrands(_ completion: CompletionClosure?) {
        RequestManager.shared.requestAllBrands({ responseObject in
                if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                    Brand.importDatas(data, true, { (_, _) -> () in
                        // After importing, cache all brand images
                        MagicalRecord.save({ (localContext) -> Void in
                            if let brands = Brand.mr_findAll(in: localContext) as? [Brand] {
                                for brand in brands {
                                    if let imageURL = brand.imageUrl, let url = URL(string: imageURL) {
                                        SDWebImageManager.shared().downloadImage(
                                            with: url,
                                            options: .lowPriority,
                                            progress: { (_, _) -> Void in },
                                            completed: { (_, _, _, _, _) -> Void in })
                                    }
                                }
                            }
                            }, completion: { (_, _) -> Void in
                                self.completeWithData(responseObject, completion: completion)
                        })
                        // Notify observers
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Cons.DB.brandsUpdatingDidFinishNotification), object: nil)
                    })
                } else {
                    self.completeWithData(responseObject, completion: completion)
                }
            }, { error in
                self.completeWithError(error, completion: completion)
        })
    }
    
    func requestProductInfo(_ id: String, _ completion: CompletionClosure?) {
        RequestManager.shared.requestProductInfo(id, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    //////////////////////////////////////
    // MARK: Favorites Discounts
    //////////////////////////////////////
    
    func favoriteDiscount(_ id: NSNumber, wasFavorite: Bool, _ completion: CompletionClosure?) {
        RequestManager.shared.favoriteDiscount(id, operation: wasFavorite ? "-" : "+", { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestDiscountFavorites(_ completion: CompletionClosure?) {
        let responseHandlerClosure = { (responseObject: Any?) -> () in
            if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                FavoriteDiscount.updateWithData(data, completion)
            } else {
                self.completeWithError(FmtError(0, nil), completion: completion)
            }
        }
        let errorHandlerClosure = { (error: NSError?) -> () in
            self.completeWithError(error, completion: completion)
        }
        
        if UserManager.shared.isLoggedIn {
            RequestManager.shared.requestDiscountFavorites(responseHandlerClosure, errorHandlerClosure)
        }
    }
    
    //////////////////////////////////////
    // MARK: Favorites News
    //////////////////////////////////////
    
    func favoriteNews(_ id: NSNumber, wasFavorite: Bool, _ completion: CompletionClosure?) {
        RequestManager.shared.favoriteNews(id, operation: wasFavorite ? "-" : "+", { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestNewsFavorites(_ completion: CompletionClosure?) {
        let responseHandlerClosure = { (responseObject: Any?) -> () in
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
    
    func requestProductFavorites(_ completion: CompletionClosure?) {
        let responseHandlerClosure = { (responseObject: Any?) -> () in
            if let responseObject = responseObject as? [String:Any],
                let data = responseObject["data"] as? [NSDictionary] {
                FavoriteProduct.updateWithData(data, completion)
            }
        }
        let errorHandlerClosure = { (error: NSError?) -> () in
            self.completeWithError(error, completion: completion)
        }
        
        RequestManager.shared.requestProductFavorites(responseHandlerClosure, errorHandlerClosure)
    }
    
    func favoriteProduct(_ id: NSNumber, wasFavorite: Bool, _ completion: CompletionClosure?) {
        RequestManager.shared.favoriteProduct(id, operation: wasFavorite ? "-" : "+", { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    //////////////////////////////////////
    // MARK: News
    //////////////////////////////////////
    
    func likeNews(_ id: NSNumber, wasLiked: Bool, _ completion: CompletionClosure?) {
        RequestManager.shared.likeNews(id, operation: wasLiked ? "-" : "+", { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestNewsList(_ relativeID: NSNumber?, _ completion: CompletionClosure?) {
        RequestManager.shared.requestNewsList(Cons.Svr.infoRequestSize, relativeID, { responseObject in
            if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                News.importDatas(data, (relativeID != nil) ? false : true, false, { (_, _) -> () in
                    // After importing, cache all news images
                    MagicalRecord.save({ (localContext) -> Void in
                        if let allNews = News.mr_findAll(in: localContext) as? [News] {
                            for news in allNews {
                                if let imageURL = news.image, let url = URL(string: imageURL) {
                                    SDWebImageManager.shared().downloadImage(
                                        with: url,
                                        options: .lowPriority,
                                        progress: { (_, _) -> Void in },
                                        completed: { (_, _, _, _, _) -> Void in })
                                }
                            }
                        }
                        }, completion: { (_, _) -> Void in
                            self.completeWithData(responseObject, completion: completion)
                    })
                    // Notify observers
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Cons.DB.newsUpdatingDidFinishNotification), object: nil)
                })
            } else {
                self.completeWithError(FmtError(0, nil), completion: completion)
            }
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestNewsByID(_ id: NSNumber, _ completion: CompletionClosure?) {
        RequestManager.shared.requestNewsByID(id, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestNews(_ ids: [NSNumber], _ completion: CompletionClosure?) {
        RequestManager.shared.requestNews(ids, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestNewsInfo(_ id: NSNumber, _ completion: CompletionClosure?) {
        RequestManager.shared.requestNewsInfo(id, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    //////////////////////////////////////
    // MARK: Discounts
    //////////////////////////////////////
    
    func likeDiscount(_ id: NSNumber, wasLiked: Bool, _ completion: CompletionClosure?) {
        RequestManager.shared.likeDiscount(id, operation: wasLiked ? "-" : "+", { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestDiscountsList(_ relativeID: NSNumber?, _ completion: CompletionClosure?) {
        RequestManager.shared.requestDiscountsList(Cons.Svr.infoRequestSize, relativeID, { responseObject in
            if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                Discount.importDatas(data, (relativeID != nil) ? false : true, false, { (_, _) -> () in
                    // After importing, cache all news images
                    MagicalRecord.save({ (localContext) -> Void in
                        if let allDiscounts = Discount.mr_findAll(in: localContext) as? [Discount] {
                            for discount in allDiscounts {
                                if let imageURL = discount.coverImage, let url = URL(string: imageURL) {
                                    SDWebImageManager.shared().downloadImage(
                                        with: url,
                                        options: .lowPriority,
                                        progress: { (_, _) -> Void in },
                                        completed: { (_, _, _, _, _) -> Void in })
                                }
                            }
                        }
                    }, completion: { (_, _) -> Void in
                        self.completeWithData(responseObject, completion: completion)
                    })
                    // Notify observers
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Cons.DB.discountsUpdatingDidFinishNotification), object: nil)
                })
            } else {
                self.completeWithError(FmtError(0, nil), completion: completion)
            }
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestDiscountByID(_ id: NSNumber, _ completion: CompletionClosure?) {
        RequestManager.shared.requestDiscountByID(id, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestDiscounts(_ ids: [NSNumber], _ completion: CompletionClosure?) {
        RequestManager.shared.requestDiscounts(ids, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestDiscountInfo(_ id: NSNumber, _ completion: CompletionClosure?) {
        RequestManager.shared.requestDiscountInfo(id, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func createCommentForDiscount(_ id: NSNumber, _ commentId: NSNumber = 0, _ comment: String, _ completion: CompletionClosure?) {
        RequestManager.shared.createCommentForDiscount(id, commentId, comment, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestCommentsForDiscount(_ id: NSNumber, _ count: Int, _ relativeID: NSNumber? = 0, _ completion: CompletionClosure?) {
        RequestManager.shared.requestCommentsForDiscount(id, count, relativeID, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    //////////////////////////////////////
    // MARK: Notification
    //////////////////////////////////////
    
    func registerForNotification(_ forceRegister: Bool) {
        // If hasn't registered
        if forceRegister || !UserDefaults.boolForKey(Cons.App.hasRegisteredForNotification) {
            UserDefaults.setBool(false, forKey: Cons.App.hasRegisteredForNotification)
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
    
    func translateProduct(_ id: NSNumber, _ completion: CompletionClosure?) {
        RequestManager.shared.translateProduct(id, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func likeProduct(_ id: NSNumber, wasLiked: Bool, _ completion: CompletionClosure?) {
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
    
    var _requestProductsQueue: OperationQueue?
    fileprivate func requestProductsQueue() -> OperationQueue {
        if _requestProductsQueue == nil {
            _requestProductsQueue = OperationQueue()
            _requestProductsQueue?.maxConcurrentOperationCount = 1
        }
        return _requestProductsQueue ?? OperationQueue()
    }
    
    var _importProductsQueue: OperationQueue?
    fileprivate func importProductsQueue() -> OperationQueue {
        if _importProductsQueue == nil {
            _importProductsQueue = OperationQueue()
            _importProductsQueue?.maxConcurrentOperationCount = ProcessInfo.processInfo.activeProcessorCount
        }
        return _importProductsQueue ?? OperationQueue()
    }
    
    fileprivate func requestNextProducts() {
        // No need to request more if it's requesting, or we are waiting for importing
        if (self.requestProductsQueue().operations.count > 1 ||
            self.importProductsQueue().operations.count > ProcessInfo.processInfo.activeProcessorCount) {
            return
        }
        
        self.requestProductsQueue().addOperation {
            // NSError
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
    
    fileprivate func importProducts(_ data: [NSDictionary]?) {
        self.importProductsQueue().addOperation {
            // NSError
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
                DispatchQueue.main.async {
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
    fileprivate func loadProducts(_ productIDs: [NSNumber], index: Int, size: Int, completion: CompletionClosure?) {
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
        DispatchQueue.main.async {
            self.updateProductsProgress(0, total: self._requestProductIDs.count)
        }
        self.requestNextProducts()
    }
    
    fileprivate func handleModifiedProductsIDs(_ responseObject: Any?, _ error: NSError?, _ completion: CompletionClosure?) {
        if error != nil {
            self.completeWithError(error, completion: completion)
            return
        }
        if let responseObject = responseObject as? [String:Any],
            let timestamp = responseObject["timestamp"] as? String,
            let productIDs = responseObject["products"] as? [NSNumber] {
            DLog(FmtString("NSNumber of modified products = %d",productIDs.count))
            // Load products
            self.loadProducts(productIDs, index: 0, size: 1000, completion: { responseObject, error in
                self.updateProductsProgress((error != nil ? -1 : 1), total: 1)
                if error == nil {
                    // If no error, save the last request timestamp
                    self.setAppInfo(timestamp , forKey: Cons.DB.lastRequestTimestampProductIDs)
                    self.completeWithData(nil, completion: completion)
                } else {
                    self.completeWithError(error, completion: completion)
                }
            })
        } else {
            self.completeWithData(FmtError(0, nil), completion: completion)
        }
    }
    
    fileprivate func requestModifiedProductIDs(_ completion: CompletionClosure?) {
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
    
    fileprivate func handleDeletedProductsIDs(_ responseObject: Any?, _ error: NSError?, _ completion: CompletionClosure?) {
        if error != nil {
            self.completeWithError(error, completion: completion)
            return
        }
        if let responseObject = responseObject as? [String:Any],
            let productIDs = responseObject["products"] as? [NSNumber] {
            DLog(FmtString("NSNumber of deleted products = %d",productIDs.count))
            let timestamp = responseObject["timestamp"] as? String
            self.setAppInfo(timestamp ?? "", forKey: Cons.DB.lastRequestTimestampDeletedProductIDs)
            MagicalRecord.save({ (localContext) -> Void in
                Product.mr_deleteAll(matching: FmtPredicate("id IN %@", productIDs), in: localContext)
                }, completion: { (_, _) -> Void in
                    self.completeWithData(nil, completion: completion)
                    // Notify observers
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Cons.DB.productsUpdatingDidFinishNotification), object: nil)
            })
        } else {
            self.completeWithError(FmtError(0, nil), completion: completion)
        }
    }
    
    fileprivate func requestDeletedProductIDs(_ error: NSError?, _ completion: CompletionClosure?) {
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
    
    func updateProducts(_ completion: CompletionClosure?) {
        self.requestModifiedProductIDs { responseObject, error in
            self.handleModifiedProductsIDs(responseObject, error) { responseObject, error in
                self.requestDeletedProductIDs(error) { responseObject, error in
                    self.handleDeletedProductsIDs(responseObject, error, completion)
                }
            }
        }
    }
    
    //////////////////////////////////////
    // MARK: Search Products
    //////////////////////////////////////
    
    func searchProducts(_ query: String?, _ brandId: NSNumber?, _ category: NSNumber?, _ page: Int?, _ completion: CompletionClosure?) {
        if query == nil && brandId == nil && category == nil && page == 0 {
            if let completion = completion { completion(nil, nil) }
        } else {
            RequestManager.shared.searchProducts(query, brandId, (category != nil ? [category!] : nil), page, { responseObject in
                if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                    let products = Product.productsWithData(data)
                    self.completeWithData(products, completion: completion)
                } else {
                    self.completeWithError(FmtError(0, nil), completion: completion)
                }
                }, { error in
                    self.completeWithError(error, completion: completion)
            })
        }
    }
    
    //////////////////////////////////////
    // MARK: Region
    //////////////////////////////////////
    
    func requestAllRegions(_ completion: CompletionClosure?) {
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
    
    func requestAllStores(_ completion: CompletionClosure?) {
        let timestamp = self.getAppInfo(Cons.DB.lastRequestTimestampStores)
        DLog(FmtString("lastRequestTimestampStores = %@",timestamp ?? ""))
        RequestManager.shared.requestAllStores(timestamp, { responseObject in
            if let data = DataManager.getResponseData(responseObject) as? NSDictionary,
                let stores = data["stores"] as? [NSDictionary] {
                // Import data
                DLog(FmtString("NSNumber of modified stores = %d",stores.count))
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
    
    func updateData(_ completion: CompletionClosure?) {
        if !self.isUpdatingData {
            // If it's more than 1 day since the last update
            if let lastUpdateDate = UserDefaults.objectForKey(Cons.App.lastUpdateDate) as? Date {
                if Date().timeIntervalSince(lastUpdateDate) < Cons.App.updateInterval {
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
                        UserDefaults.setObject(Date(), forKey: Cons.App.lastUpdateDate)
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
    
//    var _isWTStatusBarVisible = false
    func updateProductsProgress(_ current: Int, total: Int) {
        DLog("Updating products: \(current) / \(total)")
//        if current == -1 {
//            if (_isWTStatusBarVisible) {
//                WTStatusBar.setStatusText(NSLocalizedString("data_manager_data_update_failed"), timeout: 1, animated: true)
//                _isWTStatusBarVisible = false
//            }
//        } else {
//            let progress = CGFloat(current) / CGFloat(total)
//            WTStatusBar.setProgress(progress, animated: true)
//            if progress < 1 {
//                if !_isWTStatusBarVisible {
//                    _isWTStatusBarVisible = true
//                    WTStatusBar.setStatusText(NSLocalizedString("data_manager_updating_data"))
//                }
//            } else if (_isWTStatusBarVisible) {
//                WTStatusBar.setStatusText(NSLocalizedString("data_manager_data_update_succeeded"), timeout: 1, animated: true)
//                _isWTStatusBarVisible = false
//            }
//        }
    }
    
    //////////////////////////////////////
    // MARK: Helpers
    //////////////////////////////////////
    
    func getAppInfo(_ key: String) -> String? {
        var returnValue: String?
        MagicalRecord.save(blockAndWait: { (localContext) -> Void in
            // mr_findFirst(byAttribute attribute: String, withValue searchValue: Any, in context: NSManagedObjectContext) -> Self?
            if let lastRequestTimestamp = AppData.mr_findFirst(byAttribute: "key", withValue: key, in: localContext) {
                returnValue = lastRequestTimestamp.value
            }
        })
        return returnValue
    }
    
    func setAppInfo(_ timestamp: String?, forKey key: String) {
        if let timestamp = timestamp {
            MagicalRecord.save(blockAndWait: { (localContext) -> Void in
                var lastRequestTimestamp = AppData.mr_findFirst(byAttribute: "key", withValue: key, in: localContext)
                if lastRequestTimestamp == nil {
                    lastRequestTimestamp = AppData.mr_createEntity(in: localContext)
                    lastRequestTimestamp?.key = key
                }
                lastRequestTimestamp?.value = timestamp
            })
        }
    }
    
    //////////////////////////////////////
    // MARK: NSManagedObjectContexts used for products
    //////////////////////////////////////
    
    var _memoryContext: NSManagedObjectContext?
    func memoryContext() -> NSManagedObjectContext {
        if let memoryContext = _memoryContext {
            return memoryContext
        } else {
            let inMemoryStoreCoordinator = NSPersistentStoreCoordinator.mr_coordinatorWithInMemoryStore()
            let memoryContext = NSManagedObjectContext.mr_context(with: inMemoryStoreCoordinator)
            _memoryContext = memoryContext
            return memoryContext
        }
    }
    
    //////////////////////////////////////
    // MARK: Analytics
    //////////////////////////////////////
    
    func analyticsAppBecomeActive() {
        RequestManager.shared.sendAnalyticsData(NSNumber(value: 3), NSNumber(value: 6), "null", { responseObject in
            DLog(responseObject)
        }, { error in
            self.completeWithError(error, completion: nil)
        })
    }
}
