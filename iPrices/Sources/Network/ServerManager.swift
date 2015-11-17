//
//  ServerManager.swift
//  iPrices
//
//  Created by CocoaBob on 17/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//


class ServerManager {
    
    static let shared: ServerManager = {
        let instance = ServerManager()
        
        let requestOperationManager = HTTPRequestOperationManager(baseURL:NSURL(string: kBaseURL))
        
        return instance
    }()
    
}
