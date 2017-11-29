//
//  RequestManager.swift
//  Soyou
//
//  Created by CocoaBob on 17/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class RequestManager {
    
    var requestOperationManager: HTTPRequestOperationManager!
    
    static let shared = RequestManager()
    
    init() {
        self.initRequestOperationManager()
    }
    
    func initRequestOperationManager() {
        let isSTGMode = UserDefaults.boolForKey(Cons.App.isSTGMode)
        let hostname = isSTGMode ? Cons.Svr.hostnameSTG : Cons.Svr.hostnamePROD
        self.requestOperationManager = HTTPRequestOperationManager(baseURL:URL(string: "https://" + hostname))
    }
    
    //////////////////////////////////////
    // MARK: General
    //////////////////////////////////////
    
    func getSyncExternal(_ path: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        requestOperationManager.requestExternal("GET", path, false, true, nil, [:], nil, onSuccess, onFailure)
    }
    
    func getAsyncExternal(_ path: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        requestOperationManager.requestExternal("GET", path, false, false, nil, [:], nil, onSuccess, onFailure)
    }
    
    func getAsync(_ path: String, _ api: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        requestOperationManager.request("GET", path, false, false, ["api": api, "authorization": UserManager.shared.token ?? ""], nil, nil, onSuccess, onFailure)
    }
    
    func postAsync(_ path: String, _ api: String, _ params: [String: Any]?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        requestOperationManager.request("POST", path, false, false, ["api": api, "authorization": UserManager.shared.token ?? ""], params as AnyObject, nil, onSuccess, onFailure)
    }
    
    func deleteAsync(_ path: String, _ api: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        requestOperationManager.request("DELETE", path, false, false, ["api": api, "authorization": UserManager.shared.token ?? ""], nil, nil, onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Authentication
    //////////////////////////////////////
    
    func checkToken(_ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/secure/auth/check", "AuthCheck", onSuccess, onFailure)
    }
    
    func login(_ email: String, _ password: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/auth/login", "Auth", ["email": email, "password": password, "uuid": UserManager.shared.uuid], onSuccess, onFailure)
    }
    
    func logout(_ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/auth/logout", "Auth", [:], onSuccess, onFailure)
    }
    
    func register(_ email: String, _ password: String, _ gender: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/auth/register", "Auth", ["email": email, "password": password, "gender": gender], onSuccess, onFailure)
    }
    
    func loginThird(_ type: String, _ accessToken: String, _ thirdId: String, _ username: String, _ gender: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/auth/third",
                  "Auth",
                  ["type": type, "accessToken": accessToken, "thirdId": thirdId, "username": username, "gender": gender, "uuid": UserManager.shared.uuid],
                  onSuccess,
                  onFailure)
    }
    
    func requestVerifyCode(_ email: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/auth/verify-code", "Auth", ["email": email], onSuccess, onFailure)
    }
    
    func resetPassword(_ verifyCode: String, _ password: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/auth/password", "Auth", ["verificationCode": verifyCode, "password": password], onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Brands
    //////////////////////////////////////
    
    func requestAllBrands(_ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/brands", "Brands", onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Favorites News
    //////////////////////////////////////
    
    // Add (remove) news to (from) favorite
    func favoriteNews(_ id: NSNumber, operation:String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/secure/favorite/news/\(id)", "FavoriteNews", ["operation": operation], onSuccess, onFailure)
    }
    
    func requestNewsFavorites(_ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/secure/favorite/news", "FavoriteNews", onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Favorites Discounts
    //////////////////////////////////////
    
    // Add (remove) discount to (from) favorite
    func favoriteDiscount(_ id: NSNumber, operation:String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/secure/favorite/discounts/\(id)", "FavoriteDiscounts", ["operation": operation], onSuccess, onFailure)
    }
    
    func requestDiscountFavorites(_ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/secure/favorite/discounts", "FavoriteDiscounts", onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Favorites Products
    //////////////////////////////////////
    
    func favoriteProduct(_ id: NSNumber, operation:String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/secure/favorite/products/\(id)", "FavoriteProducts", ["operation": operation], onSuccess, onFailure)
    }
    
    func requestProductFavoritesByCategory(_ categoryId: NSNumber, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/secure/favorite/category-products/\(categoryId)", "FavoriteProductsByCategory", onSuccess, onFailure)
    }
    
    func requestProductFavorites(_ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/secure/favorite/products", "FavoriteProducts", onSuccess, onFailure)
    }
    
    
    //////////////////////////////////////
    // MARK: News
    //////////////////////////////////////
    
    func likeNews(_ id: NSNumber, operation:String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/news/\(id)/like", "News", ["operation": operation], onSuccess, onFailure)
    }
    
    func requestNewsList(_ count: Int, _ relativeNewsID: NSNumber?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        let path = (relativeNewsID != nil) ? "/api/\(Cons.Svr.apiVersion)/news/previous/\(count)/\(relativeNewsID!)" : "/api/\(Cons.Svr.apiVersion)/news/latest/\(count)"
        getAsync(path, "News", onSuccess, onFailure)
    }
    
    func requestNewsByID(_ id: NSNumber, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/news/\(id)", "News", onSuccess, onFailure)
    }
    
    func requestNews(_ ids: [NSNumber], _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/news", "News", ["ids": ids], onSuccess, onFailure)
    }
    
    func requestNewsInfo(_ id: NSNumber, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/news/\(id)/extra", "News", onSuccess, onFailure)
    }
    
    func createCommentForNews(_ id: NSNumber, _ commentId: NSNumber = 0, _ comment: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/secure/news/\(id)/comments/\(commentId)", "News", ["comment": comment], onSuccess, onFailure)
    }
    
    func requestCommentsForNews(_ id: NSNumber, _ count: Int, _ relativeID: NSNumber? = 0, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/news/\(id)/comments/\(count)/\(relativeID ?? 0)", "News", onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Discounts
    //////////////////////////////////////
    
    func likeDiscount(_ id: NSNumber, operation:String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/secure/discounts/\(id)/like", "Discounts", ["operation": operation], onSuccess, onFailure)
    }
    
    func requestDiscountsList(_ count: Int, _ relativeID: NSNumber?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        let path = (relativeID != nil) ? "/api/\(Cons.Svr.apiVersion)/discounts/previous/\(count)/\(relativeID!)" : "/api/\(Cons.Svr.apiVersion)/discounts/latest/\(count)"
        getAsync(path, "Discounts", onSuccess, onFailure)
    }
    
    func requestDiscountByID(_ id: NSNumber, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/discounts/\(id)", "Discounts", onSuccess, onFailure)
    }
    
    func requestDiscounts(_ ids: [NSNumber], _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/discounts", "Discounts", ["ids": ids], onSuccess, onFailure)
    }
    
    func requestDiscountInfo(_ id: NSNumber, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/discounts/\(id)/extra", "Discounts", onSuccess, onFailure)
    }
    
    func createCommentForDiscount(_ id: NSNumber, _ commentId: NSNumber = 0, _ comment: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/secure/discounts/\(id)/comments/\(commentId)", "Discounts", ["comment": comment], onSuccess, onFailure)
    }
    
    func requestCommentsForDiscount(_ id: NSNumber, _ count: Int, _ relativeID: NSNumber? = 0, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/discounts/\(id)/comments/\(count)/\(relativeID ?? 0)", "Discounts", onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Notification
    //////////////////////////////////////
    
    func registerForMonitoring(_ deviceToken: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/notification/register-monitor", "Notifications", ["deviceToken": deviceToken],onSuccess, onFailure)
    }
    
    func registerForNotification(_ uuid: String, _ deviceToken: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/notifications/register", "Notifications", ["uuid": uuid, "deviceToken": deviceToken],onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Products
    //////////////////////////////////////
    
    func translateProduct(_ id: NSNumber, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/products/\(id)/translation", "Products", onSuccess, onFailure)
    }
    
    func likeProduct(_ id: NSNumber, operation:String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/products/\(id)/like", "Products", ["operation": operation], onSuccess, onFailure)
    }
    
    func requestProducts(_ ids: [NSNumber], _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/products", "Products", ["ids": ids], onSuccess, onFailure)
    }
    
    func requestProduct(_ id: NSNumber, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/products/\(id)", "Products", onSuccess, onFailure)
    }
    
    func requestModifiedProductIDs(_ timestamp: String?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync(FmtString("/api/\(Cons.Svr.apiVersion)/products/%@", timestamp ?? ""), "Products", onSuccess, onFailure)
    }
    
    func requestDeletedProductIDs(_ timestamp: String?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync(FmtString("/api/\(Cons.Svr.apiVersion)/products/deleted/%@", timestamp ?? ""), "Products", onSuccess, onFailure)
    }
    
    func requestProductInfo(_ id: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/products/\(id)/extra", "Products", onSuccess, onFailure)
    }
    
    func createCommentForProduct(_ id: NSNumber, _ commentId: NSNumber = 0, _ comment: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/secure/products/\(id)/comments/\(commentId)", "Products", ["comment": comment], onSuccess, onFailure)
    }
    
    func requestCommentsForProduct(_ id: NSNumber, _ count: Int, _ relativeID: NSNumber? = 0, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/products/\(id)/comments/\(count)/\(relativeID ?? 0)", "Products", onSuccess, onFailure)
    }
    
    func requestCurrencyChanges(_ currencies: [NSDictionary], _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        var _currencies: [String] = [String]()
        for currency in currencies {
            if let sourceCode = currency["sourceCode"],
                let targetCode = currency["targetCode"] {
                _currencies.append("\(sourceCode):\(targetCode)")
            }
        }
        if _currencies.isEmpty {
            if let onFailure = onFailure { onFailure(nil) }
        } else {
            let currencies = _currencies.joined(separator: ",")
            getAsync("/api/\(Cons.Svr.apiVersion)/currencyRates/\(currencies)", "Products", onSuccess, onFailure)
        }
    }
    
    //////////////////////////////////////
    // MARK: Search Products
    //////////////////////////////////////
    
    func searchProducts(_ query: String?, _ brandId: NSNumber?, _ categories: [NSNumber]?, _ page: Int?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        var params = [String: Any]()
        params["page"] = page
        params["size"] = Cons.App.productsPageSize
        if let query = query {
            params["query"] = query
        }
        if let brandId = brandId {
            params["brandId"] = brandId
        }
        if let categories = categories {
            if !categories.isEmpty {
                var param = "|"
                for category in categories {
                    param += "\(category)|"
                }
                params["category"] = param
            }
        }
        postAsync("/api/\(Cons.Svr.apiVersion)/search", "Search", params, onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Region
    //////////////////////////////////////
    
    func requestAllRegions(_ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync("/api/\(Cons.Svr.apiVersion)/regions", "Regions", onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Store
    //////////////////////////////////////
    
    func requestAllStores(_ timestamp: String?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        getAsync(FmtString("/api/\(Cons.Svr.apiVersion)/stores/%@", timestamp ?? ""), "Stores", onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: User Info
    //////////////////////////////////////
    
    func modifyEmail(_ email:String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/secure/user/email", "UserEmail", ["email": email], onSuccess, onFailure)
    }
    
    func modifyUserInfo(_ field:String, _ value:String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        postAsync("/api/\(Cons.Svr.apiVersion)/secure/user/info", "UserInfo", ["field": field, "value": value], onSuccess, onFailure)
    }
    
    //////////////////////////////////////
    // MARK: Analytics
    //////////////////////////////////////
    
    func sendAnalyticsData(_ target: NSNumber, _ action: NSNumber, _ data: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        let operatedAt = Cons.utcDateFormatter.string(from: Date())
        let params = ["target": target, "action": action, "data": data, "operatedAt": operatedAt, "uuid": UserManager.shared.uuid, "device": "iOS"] as [String : Any]
        postAsync("/api/\(Cons.Svr.apiVersion)/analytics", "Analytics", params, onSuccess, onFailure)
    }
}
