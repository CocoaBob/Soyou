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
    
    //////////////////////////////////////
    // MARK: Authentication
    //////////////////////////////////////
    
    func login(email: String, _ password: String, completion: ErrorClosure?) {
        RequestManager.shared.login(email, password,
            { (responseObject: AnyObject?) -> () in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    if let data = self.getResponseData(responseObject) as? Dictionary<String, String> {
                        UserManager.shared.logIn(data["token"]!, roleCode: data["roleCode"]!)
                    }
                    // Complete
                    if let completion = completion { completion(nil) }
                }
            },
            { (error: NSError?) -> () in
                self.handleError(error)
                // Complete
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
                // Complete
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
                // Complete
                if let completion = completion { completion(error) }
            }
        )
    }
    
    func resetPassword(verifyCode: String, _ password: String, completion: ErrorClosure?) {
        RequestManager.shared.resetPassword(verifyCode, password,
            { (responseObject: AnyObject?) -> () in
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                    if let data = self.getResponseData(responseObject) as? Dictionary<String, String> {
                        UserManager.shared.logIn(data["token"]!, roleCode: data["roleCode"]!)
                    }
                    // Complete
                    if let completion = completion { completion(nil) }
                }
            },
            { (error: NSError?) -> () in
                self.handleError(error)
                // Complete
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
    
    //////////////////////////////////////
    // MARK: Favorites News
    //////////////////////////////////////
    
    func newsFavorite(id: NSNumber, isFavorite: Bool, _ completion: DataClosure?) {
        RequestManager.shared.newsFavorite(id, operation: isFavorite ? "-" : "+",
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

    
    //////////////////////////////////////
    // MARK: Favorites Products
    //////////////////////////////////////
    
    func productFavorite(id: NSNumber, isFavorite: Bool, _ completion: DataClosure?) {
        RequestManager.shared.productFavorite(id, operation: isFavorite ? "-" : "+",
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
            { (error: NSError?) -> () in
                self.handleError(error)
            }
        )
    }
    
    func loadNewsList(relativeID: NSNumber?, _ completion: CompletionClosure?) {
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
    
    func loadNews(id: String, _ completion: CompletionClosure?) {
        RequestManager.shared.requestNews(id,
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
                // Complete
                if let completion = completion { completion() }
            }
        );
    }
    
    func loadNewsInfo(id: String, _ completion: DataClosure?) {
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
                let allNotUpdatedProducts = Product.MR_findAllWithPredicate(
                    FmtPredicate("appIsUpdated == %@", NSNumber(bool: false)),
                    inContext: localContext)
                productIDs = allNotUpdatedProducts.map { (product) -> NSNumber in
                    return (product as! Product).id!
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