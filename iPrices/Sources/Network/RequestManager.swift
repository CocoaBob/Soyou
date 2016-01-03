//
//  RequestManager.swift
//  iPrices
//
//  Created by CocoaBob on 17/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class RequestManager {
    
    let requestOperationManager = HTTPRequestOperationManager(baseURL:NSURL(string: Cons.Svr.baseURL))
    
    static let shared = RequestManager()
    
    //////////////////////////////////////
    // MARK: General
    //////////////////////////////////////
    
    func getAsync(path: String, _ api: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        requestOperationManager.request("GET", path, false, false, ["api": api, "authorization": UserManager.shared.token ?? ""], nil, nil, onSuccess, onFailure)
    }
    
    func postAsync(path: String, _ api: String, _ params: AnyObject?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        requestOperationManager.request("POST", path, false, false, ["api": api, "authorization": UserManager.shared.token ?? ""], params, nil, onSuccess, onFailure)
    }
    
    func deleteAsync(path: String, _ api: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        requestOperationManager.request("DELETE", path, false, false, ["api": api, "authorization": UserManager.shared.token ?? ""], nil, nil, onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Authentication
    //////////////////////////////////////
    
    // Not tested yet
    func checkToken(onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/secure/auth/check", "AuthCheck", onSuccess, onFailure)
    }
    
    func login(email: String, _ password: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/auth/login", "Auth", ["email": email, "password": password], onSuccess, onFailure)
    }
    
    // Not tested yet
    func logout(onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/auth/logout", "Auth", nil, onSuccess, onFailure)
    }
    
    func register(email: String, _ password: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/auth/register", "Auth", ["email": email, "password": password], onSuccess, onFailure)
    }
    
    func requestVerifyCode(email: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/auth/verify-code", "Auth", ["email": email], onSuccess, onFailure)
    }
    
    // Not tested yet
    func resetPassword(verifyCode: String, _ password: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/auth/password", "Auth", ["verifyCode": verifyCode, "password": password], onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Brands
    //////////////////////////////////////
    
    func requestAllBrands(onSuccess: DataClosure?, _ onFailure: ErrorClosure?){
        getAsync("/api/\(Cons.Svr.apiVersion)/brands", "Brands", onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Favorites News
    //////////////////////////////////////
    
    // Not tested yet
    // Add (remove) news to (from) favorite
    func newsFavorite(id: NSNumber, operation:String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/secure/favorite/news/\(id)", "FavoriteNews", ["operation": operation], onSuccess, onFailure)
    }
    
    // Not tested yet
    func requestNewsFavorites(onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/secure/favorite/news", "FavoriteNews", onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Favorites Products
    //////////////////////////////////////
    
    // Not tested yet
    func productFavorite(id: NSNumber, operation:String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/secure/favorite/products/\(id)", "FavoriteProducts", ["operation": operation], onSuccess, onFailure)
    }
    
    // Not tested yet
    func requestProductFavorites(onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/secure/favorite/products", "FavoriteProducts", onSuccess, onFailure)
    }
    
    
    //////////////////////////////////////
    // MARK: News
    //////////////////////////////////////
    
    func likeNews(id: NSNumber, operation:String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/news/\(id)/like", "News", ["operation": operation], onSuccess, onFailure)
    }
    
    func requestNewsList(count: Int, _ relativeNewsID: NSNumber?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        let path = (relativeNewsID != nil) ? "/api/\(Cons.Svr.apiVersion)/news/previous/\(count)/\(relativeNewsID!)" : "/api/\(Cons.Svr.apiVersion)/news/latest/\(count)"
        getAsync(path, "News", onSuccess, onFailure)
    }
    
    func requestNews(id: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/news/\(id)", "News", onSuccess, onFailure)
    }
    
    func requestNewsInfo(id: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/news/\(id)/extra", "News", onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Notification
    //////////////////////////////////////
    
    func registerForMonitoring(deviceToken: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?){
        postAsync("/api/\(Cons.Svr.apiVersion)/notification/register-monitor", "Notifications", ["deviceToken": deviceToken],onSuccess, onFailure)
    }
    
    func registerForNotification(uuid: String, _ deviceToken: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?){
        postAsync("/api/notifications/register", "Notifications", ["uuid": uuid, "deviceToken": deviceToken],onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Products
    //////////////////////////////////////
    
    // Not tested yet
    func likeProduct(id: NSNumber, operation:String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/products/\(id)/like", "Products", ["operation": operation], onSuccess, onFailure)
    }
    
    // Not tested yet
    func requestProducts(ids: [NSNumber], _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/products", "Products", ["ids": ids], onSuccess, onFailure)
    }
    
    // Not tested yet
    func requestProduct(id: NSNumber, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/products/\(id)", "Products", onSuccess, onFailure)
    }
    
    // Not tested yet
    func requestAllProductIDs(onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/products", "Products", onSuccess, onFailure)
    }
    
}
