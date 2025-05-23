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
    
    fileprivate func handleError(_ error: Error?) {
        DLog(error)
        
        if let response = (error as NSError?)?.userInfo[AFNetworkingOperationFailingURLResponseErrorKey] as? HTTPURLResponse {
            // If 401 error, logout
            if response.statusCode == 401 {
                UserManager.shared.logOut()
            }
        }
    }
    
    fileprivate func completeWithData(_ data: Any?, completion: CompletionClosure?) {
        completion?(data, nil)
    }
    
    fileprivate func completeWithError(_ error: Error?, completion: CompletionClosure?) {
        self.handleError(error)
        completion?(nil, error)
    }
    
    class func getResponseData(_ responseObject: Any?) -> Any? {
        guard let responseObject = responseObject as? Dictionary<String, Any> else { return nil }
        return responseObject["data"]
    }
    
    class func showRequestFailedAlert(_ error: Error?) {
        let responseObject = AFNetworkingGetResponseObjectFromError(error as Error?)
        DLog(responseObject)
        // Show error
        var errorMessage = error?.localizedDescription ?? ""
        if let responseObject = responseObject as? Dictionary<String, Any>,
            let data = responseObject["data"] as? [String],
            let message = data.first {
            errorMessage = NSLocalizedString(message)
        }
        UIAlertController.presentAlert(from: nil,
                                       title: NSLocalizedString("alert_title_failed"),
                                       message: errorMessage,
                                       UIAlertAction(title: NSLocalizedString("alert_button_ok"),
                                                     style: UIAlertActionStyle.cancel,
                                                     handler: nil))
    }
    
    //////////////////////////////////////
    // MARK: Currency
    //////////////////////////////////////
    
    func requestCurrencyChanges(_ currencies: [NSDictionary], _ completion: CompletionClosure?) {
        RequestManager.shared.requestCurrencyChanges(currencies, { responseObject in
            if let data = DataManager.getResponseData(responseObject) as? NSArray {
                self.completeWithData(data, completion: completion)
            }
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
                if let value = data["token"] as? String {
                    UserManager.shared.userDidLogIn(value)
                }
                if let value = data["imUserId"] as? String {
                    UserManager.shared.imUserId = value
                }
                if let value = data["imAuthToken"] as? String {
                    UserManager.shared.imAuthToken = value
                }
                if let profileUrl = data["profileUrl"] as? String {
                    UserManager.shared.avatar = profileUrl
                }
                if let username = data["username"] as? String {
                    UserManager.shared.username = username.removingPercentEncoding ?? username
                }
            }
            UserManager.shared.signInRocketChat() {
                self.completeWithData(responseObject, completion: completion)
            }
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
    
    func loginThird(_ type: String, _ accessToken: String, _ thirdId: String, _ username: String?, _ profileUrl: String?, _ gender: String?, _ completion: ((Any?, Error?, String?)->())?) {
        let encodedUsername = username?.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) ?? username
        RequestManager.shared.loginThird(type, accessToken, thirdId, encodedUsername ?? "", profileUrl ?? "", gender ?? "", { responseObject in
            var profileURL: String?
            if let data = DataManager.getResponseData(responseObject) as? NSDictionary {
                for (key, value) in data {
                    if let key = key as? String {
                        UserManager.shared[key] = value
                    }
                }
                if let token = data["token"]! as? String {
                    UserManager.shared.userDidLogIn(token)
                }
                if let value = data["imUserId"] as? String {
                    UserManager.shared.imUserId = value
                }
                if let value = data["imAuthToken"] as? String {
                    UserManager.shared.imAuthToken = value
                }
                if let username = data["username"] as? String {
                    UserManager.shared.username = username.removingPercentEncoding ?? username
                }
                profileURL = data["profileUrl"] as? String
            }
            UserManager.shared.signInRocketChat() {
                DispatchQueue.main.async {
                    completion?(responseObject, nil, profileURL)
                }
            }
        }, { error in
            self.handleError(error)
            completion?(nil, error, nil)
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
                for (key, value) in data {
                    if let key = key as? String {
                        UserManager.shared[key] = value
                    }
                }
                if let token = data["token"]! as? String {
                    UserManager.shared.userDidLogIn(token)
                }
                if let value = data["imUserId"] as? String {
                    UserManager.shared.imUserId = value
                }
                if let value = data["imAuthToken"] as? String {
                    UserManager.shared.imAuthToken = value
                }
            }
            UserManager.shared.signInRocketChat() {
                self.completeWithData(responseObject, completion: completion)
            }
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    
    //////////////////////////////////////
    // MARK: User
    //////////////////////////////////////
    
    func getUserInfo(_ userId: Int, _ completion: CompletionClosure?) {
        RequestManager.shared.getUserInfo(userId, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    // type: sinaweibo, qq, wx, google, facebook, twitter
    func linkThirdAccount(_ type: String, _ accessToken: String, _ thirdId: String, _ username: String, _ profileUrl: String, _ completion: CompletionClosure?) {
        RequestManager.shared.linkThirdAccount(type, accessToken, thirdId, username, profileUrl, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func acceptInvitation(_ invitationCode: String, _ completion: CompletionClosure?) {
        RequestManager.shared.acceptInvitation(invitationCode, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func searchUsers(_ keyword: String, _ completion: CompletionClosure?) {
        RequestManager.shared.searchUsers(keyword, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
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
    
    func modifyProfileImage(_ image:UIImage, _ completion: CompletionClosure?) {
        guard let imageData = UIImageJPEGRepresentation(image, 0.7) else {
            return
        }
        RequestManager.shared.modifyProfileImage(imageData, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func getRecommendation(_ completion: CompletionClosure?) {
        RequestManager.shared.getRecommendation({ responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func blockUser(_ userId: Int, _ isInvisibleToHim: Bool, _ isInvisibleToMe: Bool, _ completion: CompletionClosure?) {
        RequestManager.shared.blockUser(userId, isInvisibleToHim, isInvisibleToMe, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func setGDPR(_ value: Bool, _ completion: CompletionClosure?) {
        RequestManager.shared.setGDPR(value, { responseObject in
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
                                        SDWebImagePrefetcher.shared().prefetchURLs([url])
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
    
    func favoriteDiscount(_ id: Int, wasFavorite: Bool, _ completion: CompletionClosure?) {
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
        let errorHandlerClosure = { (error: Error?) -> () in
            self.completeWithError(error, completion: completion)
        }
        
        if UserManager.shared.isLoggedIn {
            RequestManager.shared.requestDiscountFavorites(responseHandlerClosure, errorHandlerClosure)
        }
    }
    
    //////////////////////////////////////
    // MARK: Favorites News
    //////////////////////////////////////
    
    func favoriteNews(_ id: Int, wasFavorite: Bool, _ completion: CompletionClosure?) {
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
        let errorHandlerClosure = { (error: Error?) -> () in
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
        let errorHandlerClosure = { (error: Error?) -> () in
            self.completeWithError(error, completion: completion)
        }
        
        RequestManager.shared.requestProductFavorites(responseHandlerClosure, errorHandlerClosure)
    }
    
    func favoriteProduct(_ id: Int, wasFavorite: Bool, _ completion: CompletionClosure?) {
        RequestManager.shared.favoriteProduct(id, operation: wasFavorite ? "-" : "+", { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    //////////////////////////////////////
    // MARK: News
    //////////////////////////////////////
    
    func likeNews(_ id: Int, wasLiked: Bool, _ completion: CompletionClosure?) {
        RequestManager.shared.likeNews(id, operation: wasLiked ? "-" : "+", { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestNewsList(_ relativeID: Int?, _ completion: CompletionClosure?) {
        RequestManager.shared.requestNewsList(Cons.Svr.infoRequestSize, relativeID, { responseObject in
            if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                News.importDatas(data, (relativeID != nil) ? false : true, false, { (_, _) -> () in
                    // After importing, cache all news images
                    MagicalRecord.save({ (localContext) -> Void in
                        if let allNews = News.mr_findAll(in: localContext) as? [News] {
                            for news in allNews {
                                if let imageURL = news.image, let url = URL(string: imageURL) {
                                    SDWebImagePrefetcher.shared().prefetchURLs([url])
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
    
    func requestNewsByID(_ id: Int, _ completion: CompletionClosure?) {
        RequestManager.shared.requestNewsByID(id, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestNews(_ ids: [Int], _ completion: CompletionClosure?) {
        RequestManager.shared.requestNews(ids, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestNewsInfo(_ id: Int, _ completion: CompletionClosure?) {
        RequestManager.shared.requestNewsInfo(id, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func createCommentForNews(_ id: Int, _ commentId: Int?, _ comment: String, _ completion: CompletionClosure?) {
        RequestManager.shared.createCommentForNews(id, commentId, comment, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestCommentsForNews(_ id: Int, _ count: Int, _ relativeID: Int?, _ completion: CompletionClosure?) {
        RequestManager.shared.requestCommentsForNews(id, count, relativeID, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func deleteCommentsForNews(_ ids: [Int], _ completion: CompletionClosure?) {
        RequestManager.shared.deleteCommentsForNews(ids, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    //////////////////////////////////////
    // MARK: Discounts
    //////////////////////////////////////
    
    func likeDiscount(_ id: Int, wasLiked: Bool, _ completion: CompletionClosure?) {
        RequestManager.shared.likeDiscount(id, operation: wasLiked ? "-" : "+", { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestDiscountsList(_ relativeID: Int?, _ completion: CompletionClosure?) {
        RequestManager.shared.requestDiscountsList(Cons.Svr.infoRequestSize, relativeID, { responseObject in
            if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                Discount.importDatas(data, (relativeID != nil) ? false : true, false, { (_, _) -> () in
                    // After importing, cache all news images
                    MagicalRecord.save({ (localContext) -> Void in
                        if let allDiscounts = Discount.mr_findAll(in: localContext) as? [Discount] {
                            for discount in allDiscounts {
                                if let imageURL = discount.coverImage, let url = URL(string: imageURL) {
                                    SDWebImagePrefetcher.shared().prefetchURLs([url])
                                }
                            }
                        }
                    }, completion: { (_, _) -> Void in
                        self.completeWithData(responseObject, completion: completion)
                    })
                    // Notify observers
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: Cons.DB.discountsUpdatingDidFinishNotification),
                                                    object: nil)
                })
            } else {
                self.completeWithError(FmtError(0, nil), completion: completion)
            }
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestDiscountByID(_ id: Int, _ completion: CompletionClosure?) {
        RequestManager.shared.requestDiscountByID(id, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestDiscounts(_ ids: [Int], _ completion: CompletionClosure?) {
        RequestManager.shared.requestDiscounts(ids, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestDiscountInfo(_ id: Int, _ completion: CompletionClosure?) {
        RequestManager.shared.requestDiscountInfo(id, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func createCommentForDiscount(_ id: Int, _ commentId: Int?, _ comment: String, _ completion: CompletionClosure?) {
        RequestManager.shared.createCommentForDiscount(id, commentId, comment, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestCommentsForDiscount(_ id: Int, _ count: Int, _ relativeID: Int?, _ completion: CompletionClosure?) {
        RequestManager.shared.requestCommentsForDiscount(id, count, relativeID, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func deleteCommentsForDiscount(_ ids: [Int], _ completion: CompletionClosure?) {
        RequestManager.shared.deleteCommentsForDiscount(ids, { responseObject in
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
    
    func translateProduct(_ id: Int, _ completion: CompletionClosure?) {
        RequestManager.shared.translateProduct(id, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func likeProduct(_ id: Int, wasLiked: Bool, _ completion: CompletionClosure?) {
        RequestManager.shared.likeProduct(id, operation: wasLiked ? "-" : "+", { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func loadProducts(_ productIDs: [Int], _ completion: CompletionClosure?) {
        RequestManager.shared.requestProducts(productIDs, { responseObject in
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
    
    func loadProduct(_ sku: String, _ completion: CompletionClosure?) {
        RequestManager.shared.requestProduct(sku, { responseObject in
            if let data = DataManager.getResponseData(responseObject) as? NSDictionary {
                let newData = NSMutableDictionary(dictionary: data)
                newData["id"] = NSNumber(value: 0) // Add a fake id
                let product = Product.importData(newData, nil)
                self.completeWithData(product, completion: completion)
            } else {
                self.completeWithError(FmtError(0, nil), completion: completion)
            }
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func createCommentForProduct(_ id: Int, _ commentId: Int?, _ comment: String, _ completion: CompletionClosure?) {
        RequestManager.shared.createCommentForProduct(id, commentId, comment, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestCommentsForProduct(_ id: Int, _ count: Int, _ relativeID: Int?, _ completion: CompletionClosure?) {
        RequestManager.shared.requestCommentsForProduct(id, count, relativeID, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func deleteCommentsForProduct(_ ids: [Int], _ completion: CompletionClosure?) {
        RequestManager.shared.deleteCommentsForProduct(ids, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    //////////////////////////////////////
    // MARK: Search Products
    //////////////////////////////////////
    
    func searchProducts(_ query: String?, _ brandId: Int?, _ category: Int?, _ page: Int?, _ completion: CompletionClosure?) {
        if query == nil && brandId == nil && category == nil && page == 0 {
            completion?(nil, nil)
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
                DLog(FmtString("Int of modified stores = %d",stores.count))
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
    // MARK: Circles
    //////////////////////////////////////
    
    func requestPreviousCicles(_ timestamp: String,
                               _ deleteAll: Bool,
                               _ userID: Int?,
                               _ moc: NSManagedObjectContext?,
                               _ willSaveData:(()->())?,
                               _ completion: CompletionClosure?) {
        RequestManager.shared.requestPreviousCicles(timestamp, userID, { responseObject in
            if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                willSaveData?()
                var context = NSManagedObjectContext.mr_rootSaving()
                if let moc = moc {
                    context = moc
                }
                Circle.importDatas(data, deleteAll, context) { (_, _) -> () in
                    self.completeWithData(responseObject, completion: completion)
                }
            } else {
                self.completeWithData(responseObject, completion: completion)
            }
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func requestNextCicles(_ timestamp: String, _ userID: Int?, _ isInMemory: Bool = false, _ completion: CompletionClosure?) {
        RequestManager.shared.requestNextCicles(timestamp, userID, { responseObject in
            if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                let context = isInMemory ? self.memoryContext() : NSManagedObjectContext.mr_rootSaving()
                Circle.importDatas(data, false, context) { (_, _) -> () in
                    self.completeWithData(responseObject, completion: completion)
                }
            } else {
                self.completeWithData(responseObject, completion: completion)
            }
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func createCircle(_ text: String?, _ imgs: [Data]?, _ visibility: Int,
                      _ tagUserIds: [Int]?, _ forbiddenTagUserIds: [Int]?,
                      _ originalId: String?, _ completion: CompletionClosure?) {
        RequestManager.shared.createCircle(text, imgs, visibility,
                                           tagUserIds, forbiddenTagUserIds,
                                           originalId, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func deleteCircle(_ id: String,  _ completion: CompletionClosure?) {
        RequestManager.shared.deleteCircle(id, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func createCommentForCircle(_ id: Int, _ comment: String, _ parentUserId: Int?, _ completion: CompletionClosure?) {
        RequestManager.shared.createCommentForCircle(id, comment, parentUserId, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func deleteCommentForCircle(_ id: Int, _ commentId: Int, _ completion: CompletionClosure?) {
        RequestManager.shared.deleteCommentForCircle(id, commentId, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func likeCircle(_ id: String, wasLiked: Bool, _ completion: CompletionClosure?) {
        RequestManager.shared.likeCircle(id, operation: wasLiked ? "-" : "+", { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func getNumberOfNewerCircles(_ userId: Int?, _ timestamp: String, _ completion: CompletionClosure?) {
        RequestManager.shared.getNumberOfNewerCircles(userId, timestamp, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    //////////////////////////////////////
    // MARK: Friends
    //////////////////////////////////////
    
    func followFriend(_ userId: Int, _ completion: CompletionClosure?) {
        RequestManager.shared.followFriend(userId, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func unfollowFriend(_ userId: Int, _ completion: CompletionClosure?) {
        RequestManager.shared.unfollowFriend(userId, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func allFollowers(_ completion: CompletionClosure?) {
        RequestManager.shared.allFollowers({ responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func allFollowings(_ completion: CompletionClosure?) {
        RequestManager.shared.allFollowings({ responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    //////////////////////////////////////
    // MARK: Tags
    //////////////////////////////////////
    
    func addOrRemoveMembersForTag(_ id: Int, isAdd: Bool, userIds: [Int], _ completion: CompletionClosure?) {
        RequestManager.shared.addOrRemoveMembersForTag(id, operation: isAdd ? "+" : "-", userIds: userIds, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func createOrModifyTag(_ id: Int?, label: String, _ completion: CompletionClosure?) {
        RequestManager.shared.createOrModifyTag(id, label: label, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func allTags(_ completion: CompletionClosure?) {
        RequestManager.shared.allTags({ responseObject in
            if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                var tags = [Tag]()
                for dict in data {
                    let id = dict["id"] as? Int ?? -1
                    var label = dict["label"] as? String ?? ""
                    label = label.removingPercentEncoding ?? label
                    let memberDicts = dict["members"] as? [NSDictionary] ?? []
                    var members = [TagUser]()
                    for dict in memberDicts {
                        let userId = dict["userId"] as? Int ?? -1
                        var username = dict["username"] as? String
                        username = username?.removingPercentEncoding ?? username
                        let userProfileUrl = dict["profileUrl"] as? String
                        members.append(TagUser(userId: userId, username: username, userProfileUrl: userProfileUrl))
                    }
                    let tag = Tag(id: id, label: label, members: members)
                    tags.append(tag)
                }
                self.completeWithData(tags, completion: completion)
            } else {
                self.completeWithError(FmtError(0, nil), completion: completion)
            }
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func removeTag(_ tagId: Int, _ completion: CompletionClosure?) {
        RequestManager.shared.removeTag(tagId, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func getTagsForUser(_ userId: Int, _ completion: CompletionClosure?) {
        RequestManager.shared.getTagsForUser(userId, { responseObject in
            self.completeWithData(responseObject, completion: completion)
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
        }
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
    // MARK: - Crawl
    //////////////////////////////////////
    
    fileprivate func createCrawls(_ datas: [NSDictionary]) -> [Crawl] {
        return datas.map {
            let id = $0["id"] as? Int ?? -1
            var label = $0["label"] as? String ?? ""
            label = label.removingPercentEncoding ?? label
            let url = $0["url"] as? String ?? ""
            let isSelected = $0["isSelected"] as? Bool ?? false
            return Crawl(id: id, label: label, url: url, isSelected: isSelected)
        }
    }
    
    func getCrawlSuggestions(_ completion: CompletionClosure?) {
        RequestManager.shared.getCrawlSuggestions({ responseObject in
            if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                self.completeWithData(self.createCrawls(data), completion: completion)
            } else {
                self.completeWithError(FmtError(0, nil), completion: completion)
            }
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func getCrawls(_ completion: CompletionClosure?) {
        RequestManager.shared.getCrawls({ responseObject in
            if let data = DataManager.getResponseData(responseObject) as? [NSDictionary] {
                self.completeWithData(self.createCrawls(data), completion: completion)
            } else {
                self.completeWithError(FmtError(0, nil), completion: completion)
            }
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func addCrawl(_ label: String, _ url: String, _ completion: CompletionClosure?) {
        RequestManager.shared.addCrawl(label, url, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    func deleteCrawl(_ id: Int, _ completion: CompletionClosure?) {
        RequestManager.shared.deleteCrawl(id, { responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: completion)
        })
    }
    
    //////////////////////////////////////
    // MARK: Analytics
    //////////////////////////////////////
    
    func analyticsAppBecomeActive() {
        RequestManager.shared.sendAnalyticsData(3, 6, "null", { responseObject in
            DLog(responseObject)
        }, { error in
            self.completeWithError(error, completion: nil)
        })
    }
    
    func analyticsViewNews(id: Int) {
        RequestManager.shared.sendAnalyticsData(1, 1, "{ \"type\": \"news\", \"id\": \(id)}", { responseObject in
            DLog(responseObject)
        }, { error in
            self.completeWithError(error, completion: nil)
        })
    }
    
    func analyticsViewDiscount(id: Int) {
        RequestManager.shared.sendAnalyticsData(4, 1, "{ \"type\": \"discount\", \"id\": \(id)}", { responseObject in
            DLog(responseObject)
        }, { error in
            self.completeWithError(error, completion: nil)
        })
    }
    
    func analyticsViewProduct(sku: String) {
        RequestManager.shared.sendAnalyticsData(2, 1, "{ \"type\": \"product\", \"sku\": \"\(sku)\"}", { responseObject in
            DLog(responseObject)
        }, { error in
            self.completeWithError(error, completion: nil)
        })
    }
    
    func analyticsShareNews(id: Int) {
        RequestManager.shared.sendAnalyticsData(1, 4, "{ \"type\": \"news\", \"id\": \(id)}", { responseObject in
            DLog(responseObject)
        }, { error in
            self.completeWithError(error, completion: nil)
        })
    }
    
    func analyticsShareDiscount(id: Int) {
        RequestManager.shared.sendAnalyticsData(4, 4, "{ \"type\": \"discount\", \"id\": \(id)}", { responseObject in
            DLog(responseObject)
        }, { error in
            self.completeWithError(error, completion: nil)
        })
    }
    
    func analyticsShareProduct(sku: String) {
        RequestManager.shared.sendAnalyticsData(2, 4, "{ \"type\": \"product\", \"sku\": \"\(sku)\"}", { responseObject in
            DLog(responseObject)
        }, { error in
            self.completeWithError(error, completion: nil)
        })
    }
    
    func analyticsShareCircle(id: String) {
        RequestManager.shared.sendAnalyticsData(5, 4, "{ \"type\": \"circle\", \"id\": \"\(id)\"}", { responseObject in
            DLog(responseObject)
        }, { error in
            self.completeWithError(error, completion: nil)
        })
    }
    
    //////////////////////////////////////
    // MARK: MISC
    //////////////////////////////////////
    
    func getCheckList(_ completion: CompletionClosure?) {
        RequestManager.shared.getCheckList({ responseObject in
            self.completeWithData(responseObject, completion: completion)
        }, { error in
            self.completeWithError(error, completion: nil)
        })
    }
}
