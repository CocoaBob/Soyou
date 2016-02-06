//
//  RequestManager.swift
//  Soyou
//
//  Created by CocoaBob on 17/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class RequestManager {
    
    let requestOperationManager = HTTPRequestOperationManager(baseURL:NSURL(string: Cons.Svr.baseURL))
    
    static let shared = RequestManager()
    
    //////////////////////////////////////
    // MARK: General
    //////////////////////////////////////
    
    func getAsyncExternal(path: String, _ api: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        requestOperationManager.requestExternal("GET", path, false, false, nil, nil, nil, onSuccess, onFailure)
    }
    
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
    
    func checkToken(onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/secure/auth/check", "AuthCheck", onSuccess, onFailure)
    }
    
    func login(email: String, _ password: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/auth/login", "Auth", ["email": email, "password": password, "uuid": UserManager.shared.uuid], onSuccess, onFailure)
    }
    
    func logout(onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/auth/logout", "Auth", nil, onSuccess, onFailure)
    }
    
    func register(email: String, _ password: String, _ gender: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/auth/register", "Auth", ["email": email, "password": password, "gender": gender], onSuccess, onFailure)
    }
    
    func requestVerifyCode(email: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/auth/verify-code", "Auth", ["email": email], onSuccess, onFailure)
    }
    
    func resetPassword(verifyCode: String, _ password: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/auth/password", "Auth", ["verificationCode": verifyCode, "password": password], onSuccess, onFailure)
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
    
    // Add (remove) news to (from) favorite
    func favoriteNews(id: NSNumber, operation:String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/secure/favorite/news/\(id)", "FavoriteNews", ["operation": operation], onSuccess, onFailure)
    }
    
    func requestNewsFavorites(onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/secure/favorite/news", "FavoriteNews", onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Favorites Products
    //////////////////////////////////////
    
    func favoriteProduct(id: NSNumber, operation:String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/secure/favorite/products/\(id)", "FavoriteProducts", ["operation": operation], onSuccess, onFailure)
    }
    
    func requestProductFavoritesByCategory(categoryId: NSNumber, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/secure/favorite/category-products/\(categoryId)", "FavoriteProductsByCategory", onSuccess, onFailure)
    }
    
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
    
    func requestNewsByID(id: NSNumber, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/news/\(id)", "News", onSuccess, onFailure)
    }
    
    func requestNews(ids: [NSNumber], _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/news", "News", ["ids": ids], onSuccess, onFailure)
    }
    
    func requestNewsInfo(id: NSNumber, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/news/\(id)/extra", "News", onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Notification
    //////////////////////////////////////
    
    func registerForMonitoring(deviceToken: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?){
        postAsync("/api/\(Cons.Svr.apiVersion)/notification/register-monitor", "Notifications", ["deviceToken": deviceToken],onSuccess, onFailure)
    }
    
    func registerForNotification(uuid: String, _ deviceToken: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?){
        postAsync("/api/\(Cons.Svr.apiVersion)/notifications/register", "Notifications", ["uuid": uuid, "deviceToken": deviceToken],onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Products
    //////////////////////////////////////
    
    func translateProduct(id: NSNumber, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/products/\(id)/translation", "Products", onSuccess, onFailure)
    }
    
    func likeProduct(id: NSNumber, operation:String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/products/\(id)/like", "Products", ["operation": operation], onSuccess, onFailure)
    }
    
    func requestProducts(ids: [NSNumber], _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/products", "Products", ["ids": ids], onSuccess, onFailure)
    }
    
    func requestProduct(id: NSNumber, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/products/\(id)", "Products", onSuccess, onFailure)
    }
    
    func requestModifiedProductIDs(timestamp: String?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync(FmtString("/api/\(Cons.Svr.apiVersion)/products/%@", timestamp ?? ""), "Products", onSuccess, onFailure)
    }
    
    func requestProductInfo(id: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/products/\(id)/extra", "Products", onSuccess, onFailure)
    }
    
    func requestCurrencies(currencies: [NSDictionary], _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        
        let url = "http://query.yahooapis.com/v1/public/yql?q=select * from yahoo.finance.xchange where pair in (\"__CURRENCIES__\")&format=json&env=store://datatables.org/alltableswithkeys"
        
        var _currenciies: [String] = [String]();
        for currency in currencies {
            if let sourceCode = currency["sourceCode"], let targetCode = currency["targetCode"] {
                _currenciies.append("\(sourceCode)\(targetCode)")
            }
        }
        
        if _currenciies.count == 0{
            if let onFailure = onFailure { onFailure(nil) };
        }else{
            getAsyncExternal(url.stringByReplacingOccurrencesOfString("__CURRENCIES__", withString: _currenciies.joinWithSeparator(",")), "", onSuccess, onFailure)
        }
    }
    
    //////////////////////////////////////
    // MARK: Region
    //////////////////////////////////////
    
    func requestAllRegions(onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/regions", "Region", onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Store
    //////////////////////////////////////
    
    func requestAllStores(timestamp: String?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync(FmtString("/api/\(Cons.Svr.apiVersion)/stores/%@", timestamp ?? ""), "Store", onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: User Info
    //////////////////////////////////////
    
    func modifyEmail(email:String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/secure/user/email", "UserEmail", ["email": email], onSuccess, onFailure)
    }
    
    func modifyUserInfo(field:String, _ value:String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/secure/user/info", "UserInfo", ["field": field, "value": value], onSuccess, onFailure)
    }
}
