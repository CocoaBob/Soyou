//
//  HTTPRequestOperationManager.swift
//  iPrices
//
//  Created by CocoaBob on 17/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

class HTTPRequestOperationManager: AFHTTPRequestOperationManager {
    
    override init(baseURL url: NSURL?) {
        super.init(baseURL: url)
        
        requestSerializer = AFJSONRequestSerializer()
        responseSerializer = AFJSONResponseSerializer()
        self.securityPolicy = AFSecurityPolicy(pinningMode: AFSSLPinningMode.Certificate)
        self.securityPolicy.validatesDomainName = false
        self.securityPolicy.allowInvalidCertificates = true
        
        // Use self-signed certificates in X.509 DER format, now we have 1 certificate
        var data: [NSData] = [NSData]()
        for name: String in ["server"] {
            let path: String? = NSBundle.mainBundle().pathForResource(name, ofType: "cer")
            if let path = path {
                let keyData: NSData = NSData(contentsOfFile: path)!
                data.append(keyData)
            }
        }
        self.securityPolicy.pinnedCertificates = data
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func requestExternal(method: String, _ path: String, _ modeUI: Bool, _ isSynchronous: Bool, _ headers: Dictionary<String,String>?, _ parameters: AnyObject?, _ userInfo: Dictionary<String,AnyObject>?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        DLog("--> \"\(path)\"")
        guard let path = path.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else {
            let error = FmtError(0, "Failed to encode URL")
            if let onFailure = onFailure { onFailure(error) }
            return
        }
        modeUI ? MBProgressHUD.showLoader(nil) : ()
        
        // Handlers of success and failure
        let success: (AFHTTPRequestOperation, AnyObject?) -> () = { (operation, responseObject) -> () in
            modeUI ? MBProgressHUD.hideLoader(nil) : ()
            DLog("<-- [\((responseObject?["data"])?.count)]")
            self.handleSuccessWithoutServerVersionCheck(operation, responseObject, path, onSuccess, onFailure)
        }
        
        let failure: (AFHTTPRequestOperation, NSError) -> () = { (operation, error) -> () in
            modeUI ? MBProgressHUD.hideLoader(nil) : ()
            DLog("<-- [x]")
            self.handleFailure(operation, error, onFailure)
        }
        
        // Build the URL
        guard let urlString = NSURL(string: path, relativeToURL: self.baseURL)?.absoluteString else {
            let error = FmtError(0, "Failed to build URL")
            if let onFailure = onFailure { onFailure(error) }
            return
        }
        
        // Setup request
        let request: NSMutableURLRequest = self.requestSerializer.requestWithMethod(method, URLString: urlString, parameters: parameters, error: nil)
        request.addValue(Cons.Svr.reqAPIKey, forHTTPHeaderField: "apiKey")
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Setup operation
        let operation: AFHTTPRequestOperation = self.HTTPRequestOperationWithRequest(request, success: nil, failure: nil)
        if let userInfo = userInfo { operation.userInfo = userInfo }
        if isSynchronous {
            operation.start()
            operation.waitUntilFinished()
            if !operation.cancelled {
                modeUI ? MBProgressHUD.hideLoader(nil) : ()
            } else {
                if operation.error == nil {
                    success(operation, operation.responseObject)
                } else {
                    failure(operation, operation.error!)
                }
            }
        } else {
            operation.setCompletionBlockWithSuccess(success, failure: failure)
            self.operationQueue.addOperation(operation)
        }
    }
    
    func request(method: String, _ path: String, _ modeUI: Bool, _ isSynchronous: Bool, _ headers: Dictionary<String,String>?, _ parameters: AnyObject?, _ userInfo: Dictionary<String,AnyObject>?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        DLog("--> \"\(path)\"")
        guard let path = path.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else {
            let error = FmtError(0, "Failed to encode URL")
            if let onFailure = onFailure { onFailure(error) }
            return
        }
        modeUI ? MBProgressHUD.showLoader(nil) : ()
        
        // Handlers of success and failure
        let success: (AFHTTPRequestOperation, AnyObject?) -> () = { (operation, responseObject) -> () in
            modeUI ? MBProgressHUD.hideLoader(nil) : ()
            DLog("<-- [\((responseObject?["data"])?.count)]")
            self.handleSuccess(operation, responseObject, path, onSuccess, onFailure)
        }
        
        let failure: (AFHTTPRequestOperation, NSError) -> () = { (operation, error) -> () in
            modeUI ? MBProgressHUD.hideLoader(nil) : ()
            DLog("<-- [x]")
            self.handleFailure(operation, error, onFailure)
        }
        
        // Build the URL
        guard let urlString = NSURL(string: path, relativeToURL: self.baseURL)?.absoluteString else {
            let error = FmtError(0, "Failed to build URL")
            if let onFailure = onFailure { onFailure(error) }
            return
        }
        
        // Setup request
        let request: NSMutableURLRequest = self.requestSerializer.requestWithMethod(method, URLString: urlString, parameters: parameters, error: nil)
        request.addValue(Cons.Svr.reqAPIKey, forHTTPHeaderField: "apiKey")
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Setup operation
        let operation: AFHTTPRequestOperation = self.HTTPRequestOperationWithRequest(request, success: nil, failure: nil)
        if let userInfo = userInfo { operation.userInfo = userInfo }
        if isSynchronous {
            operation.start()
            operation.waitUntilFinished()
            if !operation.cancelled {
                modeUI ? MBProgressHUD.hideLoader(nil) : ()
            } else {
                if operation.error == nil {
                    success(operation, operation.responseObject)
                } else {
                    failure(operation, operation.error!)
                }
            }
        } else {
            operation.setCompletionBlockWithSuccess(success, failure: failure)
            self.operationQueue.addOperation(operation)
        }
    }
    
    private func handleSuccessWithoutServerVersionCheck(operation: AFHTTPRequestOperation, _ responseObject: AnyObject?, _ path: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        if let onSuccess = onSuccess { onSuccess(responseObject) }
    }
    
    private func handleSuccess(operation: AFHTTPRequestOperation, _ responseObject: AnyObject?, _ path: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        
        var isAccepted = false
        var verServer: String? = nil
        if let headers: Dictionary = operation.response?.allHeaderFields {
            if let serverVersion = headers["Server-Version"] as? NSString as? String {
                verServer = serverVersion
                if serverVersion.rangeOfString(Cons.Svr.minVer) != nil{
                    isAccepted = true
                }
            }
        }
        if !isAccepted {
            let error = FmtError(0, "Local version: %@ Server supported version: %@", Cons.Svr.minVer, (verServer != nil ? verServer! : ""))
            if let onFailure = onFailure { onFailure(error) }
            return
        }
        if let onSuccess = onSuccess { onSuccess(responseObject) }
    }
    
    private func handleFailure(operation: AFHTTPRequestOperation, _ error: NSError?, _ onFailure: ErrorClosure?) {
        if let onFailure = onFailure { onFailure(error) }
    }
}