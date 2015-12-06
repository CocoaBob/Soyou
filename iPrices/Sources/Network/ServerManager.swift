//
//  ServerManager.swift
//  iPrices
//
//  Created by CocoaBob on 17/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class ServerManager {
    
    let requestOperationManager = HTTPRequestOperationManager(baseURL:NSURL(string: Cons.Svr.baseURL))
    
    static let shared = ServerManager()
    
    var token: String {
        get {
            if let token = UICKeyChainStore.stringForKey(Cons.Svr.reqAuthorizationKey) {
                return token
            } else {
                return ""
            }
        }
        set {
            UICKeyChainStore.setString(token, forKey: Cons.Svr.reqAuthorizationKey)
        }
    }
    
    //////////////////////////////////////
    // MARK: General
    //////////////////////////////////////
    
    func getAsync(path: String, _ api: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        requestOperationManager.request("GET", path, false, false, ["api": api, "authorization": self.token], nil, nil, onSuccess, onFailure)
    }
    
    func postAsync(path: String, _ api: String, _ params: AnyObject?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        requestOperationManager.request("POST", path, false, false, ["api": api, "authorization": self.token], params, nil, onSuccess, onFailure)
    }
    
    func deleteAsync(path: String, _ api: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        requestOperationManager.request("DELETE", path, false, false, ["api": api, "authorization": self.token], nil, nil, onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Authentication
    //////////////////////////////////////
    
    // Not tested yet
    func login(email: String, _ password: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/auth/login", "Auth", ["email": email, "password": password], onSuccess, onFailure)
    }
    
    // Not tested yet
    func logout(onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/auth/logout", "Auth", nil, onSuccess, onFailure)
    }
    
    // Not tested yet
    func register(email: String, _ password: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/auth/register", "Auth", ["email": email, "password": password], onSuccess, onFailure)
    }
    
    // Not tested yet
    func requestVerifyCode(email: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/auth/verify-code", "Auth", ["email": email], onSuccess, onFailure)
    }
    
    // Not tested yet
    func resetPassword(verifyCode: String, password: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/auth/password", "Auth", ["verifyCode": verifyCode, "password": password], onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Favorites News
    //////////////////////////////////////
    
    // Not tested yet
    func addNewsFavorite(id: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/secure/favorite/news/\(id)", "FavoriteNews", nil, onSuccess, onFailure)
    }
    
    // Not tested yet
    func deleteNewsFavorite(id: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        deleteAsync("/api/secure/favorite/news/\(id)", "FavoriteNews", onSuccess, onFailure)
    }
    
    // Not tested yet
    func requestNewsFavorites(onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/secure/favorite/news", "FavoriteNews", onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Favorites Products
    //////////////////////////////////////
    
    // Not tested yet
    func addProductFavorite(id: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/secure/favorite/products/\(id)", "FavoriteProducts", nil, onSuccess, onFailure)
    }
    
    // Not tested yet
    func deleteProductFavorite(id: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        deleteAsync("/api/secure/favorite/products/\(id)", "FavoriteProducts", onSuccess, onFailure)
    }
    
    // Not tested yet
    func requestProductFavorites(onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/secure/favorite/products", "FavoriteProducts", onSuccess, onFailure)
    }
    
    
    //////////////////////////////////////
    // MARK: News
    //////////////////////////////////////
    
    func likeNews(id: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/news/\(id)/like", "News", nil, onSuccess, onFailure)
    }
    
    func requestNewsList(count: Int, _ relativeNewsID: NSNumber?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        let path = (relativeNewsID != nil) ? "/api/news/previous/\(count)/\(relativeNewsID!)" : "/api/news/latest/\(count)"
        getAsync(path, "News", onSuccess, onFailure)
    }
    
    func requestNews(id: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/news/\(id)", "News", onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Notification
    //////////////////////////////////////
    
    func registerForMonitoring(deviceToken: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?){
        postAsync("/api/notification/register-monitor", "Notifications", ["deviceToken": deviceToken],onSuccess, onFailure)
    }
    
    func registerForNotification(uuid: String, _ deviceToken: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?){
        postAsync("/api/notification/register", "Notifications", ["uuid": uuid, "deviceToken": deviceToken],onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Products
    //////////////////////////////////////
    
    // Not tested yet
    func likeProduct(id: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/products/\(id)/like", "Products", nil, onSuccess, onFailure)
    }
    
    // Not tested yet
    func requestProducts(ids: [String], _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/products", "Products", ["id": ids], onSuccess, onFailure)
    }
    
    // Not tested yet
    func requestProduct(id: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/products/\(id)", "Products", onSuccess, onFailure)
    }
    
    // Not tested yet
    func requestAllProducts(onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/products", "Products", onSuccess, onFailure)
    }
    
}
