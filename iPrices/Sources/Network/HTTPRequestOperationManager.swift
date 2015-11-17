//
//  HTTPRequestOperationManager.swift
//  iPrices
//
//  Created by CocoaBob on 17/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class HTTPRequestOperationManager: AFHTTPRequestOperationManager {
    
    typealias DataClosure = ()->(AnyObject)
    typealias ErrorClosure = ()->(NSError)
    
    override init(baseURL url: NSURL?) {
        super.init(baseURL: url)
        
        requestSerializer = AFJSONRequestSerializer()
        responseSerializer = AFJSONResponseSerializer()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func request(
        method: String,
        parameters: Dictionary<String,String>,
        path: String,
        isSynchronous: Bool,
        userInfo: Dictionary<String,AnyObject>,
        onSuccess: DataClosure,
        onFailure: ErrorClosure) {
            
            let queryPath = path.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            let success: (AFHTTPRequestOperation, AnyObject) -> () = {
                (operation, responseObject) -> () in
                self.handleSuccess(responseObject, path, onSuccess, onFailure)
            }
            
            let failure: (AFHTTPRequestOperation, NSError) -> () = {
                (operation, error) -> () in
                self.handleFailure(operation, error, onFailure)
            }
    }
    
    func handleSuccess(responseObject: AnyObject, _ path: String, _ onSuccess: DataClosure, _ onFailure: ErrorClosure) {
        
    }
    
    func handleFailure(operation: AFHTTPRequestOperation, _ error: NSError, _ onFailure: ErrorClosure) {
        
    }
}