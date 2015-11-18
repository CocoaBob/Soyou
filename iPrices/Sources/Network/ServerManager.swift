//
//  ServerManager.swift
//  iPrices
//
//  Created by CocoaBob on 17/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//


class ServerManager {
    
    let requestOperationManager = HTTPRequestOperationManager(baseURL:NSURL(string: kBaseURL))
    
    static let shared = ServerManager()
    
    func getNewsList(count: UInt, _ index: UInt, _ isNewer: Bool, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        requestOperationManager.getRequest("/api/news/\(count)/\(index)", false, false, [kAPI:kAPINews], nil, nil, onSuccess, onFailure)
    }
    
    func getNews(id: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        requestOperationManager.getRequest("/api/news/\(id)", false, false, [kAPI:kAPINews], nil, nil, onSuccess, onFailure)
    }
    
}
