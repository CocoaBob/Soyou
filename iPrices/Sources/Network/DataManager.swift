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
    func loadAllProducts() {
        self.loadAllProductIDs { () -> () in
            MagicalRecord.saveWithBlockAndWait({ (localContext) -> Void in
                let allNotUpdatedProducts = Product.MR_findAllWithPredicate(
                    FmtPredicate("appIsUpdated == %@", NSNumber(bool: false)),
                    inContext: localContext)
                let productIDs = allNotUpdatedProducts.map { (product) -> NSNumber in
                    return (product as! Product).id!
                }
                
                var index = 0
                var size = 1024
                while index < productIDs.count {
                    if (index + size) > productIDs.count {
                        size = productIDs.count - index
                    }
                    let range = productIDs[index..<(index+size)]
                    if range.capacity > 0 {
                        index += range.capacity
                        self.loadProducts(Array(range), nil)
                    }
                }
            })
        }
    }

}