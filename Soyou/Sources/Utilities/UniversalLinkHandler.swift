//
//  UniversalLinkHandler.swift
//  Soyou
//
//  Created by CocoaBob on 2018-03-11.
//  Copyright © 2018 Soyou. All rights reserved.
//

class UniversalLinkerHandler: NSObject {
    
    static let shared = UniversalLinkerHandler()
    
    // KVO Context
    fileprivate var KVOContextUniversalLinkerHandler = 0
    
    var needsToAcceptInvitationMatricule: String?
}

extension UniversalLinkerHandler {
    
    func handleURL(_ url: URL?) {
        guard let url = url else { return }
        
        if url.path.hasPrefix("/invitation") {
            self.handleInvitation(url)
        } else if url.path.hasPrefix("/share") {
            self.handleShare(url)
        } else {
            UIViewController.root()?.toppestViewController()?.present(SFSafariViewController(url: url), animated: true, completion: nil)
        }
    }
    
    func handleInvitation(_ url: URL) {
        guard let query = url.query,
            let matriculeStr = query.components(separatedBy: "=").last else {
                return
        }
        self.handleInvitation(matricule: matriculeStr)
    }
    
    func handleInvitation(matricule: String) {
        guard let rootVC = UIViewController.root() else { return }
        if let presentedVC = rootVC.presentedViewController {
            presentedVC.dismiss(animated: false, completion: nil)
        }
        if UserManager.shared.isLoggedIn {
            MBProgressHUD.show(rootVC.view)
            DataManager.shared.acceptInvitation(matricule, { (responseObject, error) in
                MBProgressHUD.hide(rootVC.view)
                if let responseObject = responseObject,
                    let data = DataManager.getResponseData(responseObject) as? NSDictionary,
                    let userID = data["id"] as? Int,
                    let username = data["username"] as? String,
                    let profileStr = data["profileUrl"] as? String,
                    let profileUrl = URL(string: profileStr),
                    let matriculeInt = Int(matricule),
                    let gender = data["gender"] as? String {
                    var countryName: String?
                    if let countryCode = data["region"] as? String {
                        countryName = CurrencyManager.shared.countryName(countryCode)
                    }
                    let vc = InvitationSuccessViewController.instantiate(matricule: matriculeInt,
                                                                         userID: userID,
                                                                         profileUrl: profileUrl,
                                                                         name: username.removingPercentEncoding ?? username,
                                                                         gender: gender,
                                                                         region: countryName)
                    let navC = UINavigationController(rootViewController: vc)
                    if let presentedVC = rootVC.presentedViewController {
                        presentedVC.dismiss(animated: false, completion: nil)
                    }
                    rootVC.present(navC, animated: true, completion: nil)
                }
            })
        } else {
            self.needsToAcceptInvitationMatricule = matricule
            UserManager.shared.addObserver(self, forKeyPath: "token", options: .new, context: &KVOContextUniversalLinkerHandler)
            let vc = LoginViewController.instantiate(.login)
            let navC = UINavigationController(rootViewController: vc)
            rootVC.present(navC, animated: true) {
                vc.loginWechat(nil)
            }
        }
    }
    
    func handleShare(_ url: URL) {
        let fullPath = url.absoluteString
        guard let components = fullPath.components(separatedBy: "/share/#/").last?.components(separatedBy: "?"),
            let path = components.first,
            let query = components.last,
            let firstParam = query.components(separatedBy: "&").first,
            let id = firstParam.components(separatedBy: "=").last else {
                return
        }
        if path == "news" {
            self.handleNews(id)
        } else if path == "discounts" {
            self.handleDiscount(id)
        } else if path == "product" {
            self.handleProduct(id)
        }
    }
    
    func handleNews(_ id: String) {
        guard let rootVC = UIViewController.root(), let newsID = Int(id) else { return }
        MBProgressHUD.show(rootVC.view)
        // Load Data
        DataManager.shared.requestNewsByID(newsID) { responseObject, error in
            MBProgressHUD.hide(rootVC.view)
            if let responseObject = responseObject,
                let data = DataManager.getResponseData(responseObject) as? NSDictionary,
                let news = News.importData(data, true, nil),
                let imageURL = URL(string: news.image ?? "") {
                // Download image
                MBProgressHUD.show(rootVC.view)
                SDWebImageManager.shared().loadImage(
                    with: imageURL,
                    options: [.continueInBackground, .allowInvalidSSLCertificates],
                    progress: nil,
                    completed: { (image, data, error, type, finished, url) -> Void in
                        MBProgressHUD.hide(rootVC.view)
                        let vc = NewsDetailViewController.instantiate()
                        vc.info = news
                        vc.headerImage = image
                        let navC = UINavigationController(rootViewController: vc)
                        if let presentedVC = rootVC.presentedViewController {
                            presentedVC.dismiss(animated: false, completion: nil)
                        }
                        rootVC.present(navC, animated: true, completion: nil)
                })
            }
        }
    }
    
    func handleDiscount(_ id: String) {
        guard let rootVC = UIViewController.root(), let discountID = Int(id) else { return }
        MBProgressHUD.show(rootVC.view)
        // Load Data
        DataManager.shared.requestDiscountByID(discountID) { responseObject, error in
            MBProgressHUD.hide(rootVC.view)
            if let responseObject = responseObject,
                let data = DataManager.getResponseData(responseObject) as? NSDictionary,
                let discount = Discount.importData(data, true, nil),
                let imageURL = URL(string: discount.coverImage ?? "") {
                // Download image
                MBProgressHUD.show(rootVC.view)
                SDWebImageManager.shared().loadImage(
                    with: imageURL,
                    options: [.continueInBackground, .allowInvalidSSLCertificates],
                    progress: nil,
                    completed: { (image, data, error, type, finished, url) -> Void in
                        MBProgressHUD.hide(rootVC.view)
                        let vc = DiscountDetailViewController.instantiate()
                        vc.info = discount
                        vc.headerImage = image
                        let navC = UINavigationController(rootViewController: vc)
                        if let presentedVC = rootVC.presentedViewController {
                            presentedVC.dismiss(animated: false, completion: nil)
                        }
                        rootVC.present(navC, animated: true, completion: nil)
                })
            }
        }
    }
    
    func handleProduct(_ sku: String) {
        guard let rootVC = UIViewController.root() else { return }
        MBProgressHUD.show(rootVC.view)
        DataManager.shared.loadProduct(sku, { (responseObject, error) in
            MBProgressHUD.hide(rootVC.view)
            if let product = responseObject as? Product {
                let vc = ProductViewController.instantiate()
                vc.product = product
                let navC = UINavigationController(rootViewController: vc)
                if let presentedVC = rootVC.presentedViewController {
                    presentedVC.dismiss(animated: false, completion: nil)
                }
                rootVC.present(navC, animated: true, completion: nil)
            }
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let matricule = self.needsToAcceptInvitationMatricule, UserManager.shared.isLoggedIn {
            self.needsToAcceptInvitationMatricule = nil
            UserManager.shared.removeObserver(self, forKeyPath: "token", context: &KVOContextUniversalLinkerHandler)
            self.handleInvitation(matricule: matricule)
        }
    }
}
