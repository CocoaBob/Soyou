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
    
    func getLatestNews(count: Int, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        requestOperationManager.getRequest("/api/news/latest/\(count)", false, false, ["api":Cons.Svr.reqAPINews], nil, nil, onSuccess, onFailure)
    }
    
    func getOlderNews(count: Int, _ newsID: NSNumber, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        requestOperationManager.getRequest("/api/news/previous/\(count)/\(newsID)", false, false, ["api":Cons.Svr.reqAPINews], nil, nil, onSuccess, onFailure)
    }
    
    func getNews(id: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        requestOperationManager.getRequest("/api/news/\(id)", false, false, ["api":Cons.Svr.reqAPINews], nil, nil, onSuccess, onFailure)
    }
    
}
