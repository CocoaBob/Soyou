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
    
    func requestAsync(path: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        requestOperationManager.getRequest(path, false, false, ["api":Cons.Svr.reqAPINews], nil, nil, onSuccess, onFailure)
    }
    
    func requestNewsList(count: Int, _ relativeNewsID: NSNumber?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        let path = (relativeNewsID != nil) ? "/api/news/previous/\(count)/\(relativeNewsID!)" : "/api/news/latest/\(count)"
        requestAsync(path, onSuccess, onFailure)
    }
    
    func requestNews(id: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        requestAsync("/api/news/\(id)", onSuccess, onFailure)
    }
    
}
