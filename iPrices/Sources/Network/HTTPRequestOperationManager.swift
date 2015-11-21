//
//  HTTPRequestOperationManager.swift
//  iPrices
//
//  Created by CocoaBob on 17/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

typealias DataClosure = (AnyObject?)->()
typealias ErrorClosure = (NSError?)->()

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
    
    private func request(method: String, _ path: String, _ modeUI: Bool, _ isSynchronous: Bool, _ headers: Dictionary<String,String>?, _ parameters: Dictionary<String,String>?, _ userInfo: Dictionary<String,AnyObject>?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        print("--> \(path)")
        guard let path = path.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else {
            let error = FmtError(0, "Failed to encode URL")
            if let onFailure = onFailure { onFailure(error) }
            return
        }
        modeUI ? self.showLoader() : ()
        
        // Handlers of success and failure
        let success: (AFHTTPRequestOperation, AnyObject?) -> () = { (operation, responseObject) -> () in
            modeUI ? self.hideLoader() : ()
            self.handleSuccess(operation, responseObject, path, onSuccess, onFailure)
        }
        
        let failure: (AFHTTPRequestOperation, NSError) -> () = { (operation, error) -> () in
            modeUI ? self.hideLoader() : ()
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
        request.addValue(Cons.Svr.reqAPIKeyValue, forHTTPHeaderField: Cons.Svr.reqAPIKey);
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
                modeUI ? self.hideLoader() : ()
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
    
    private func handleSuccess(operation: AFHTTPRequestOperation, _ responseObject: AnyObject?, _ path: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        var isAccepted = false
        var verServer: String? = nil
        if let headers: Dictionary = operation.response?.allHeaderFields {
            if let serverVersion = headers["Server-Version"] as? NSString as? String {
                verServer = serverVersion
                if serverVersion == Cons.Svr.minVer {
                    isAccepted = true
                }
            }
        }
        if !isAccepted {
            let error = FmtError(0, "Accepted Server Version: %@ Server Version: %@", Cons.Svr.minVer, (verServer != nil ? verServer! : ""))
            if let onFailure = onFailure { onFailure(error) }
            return
        }
        if let onSuccess = onSuccess { onSuccess(responseObject) }
    }
    
    private func handleFailure(operation: AFHTTPRequestOperation, _ error: NSError?, _ onFailure: ErrorClosure?) {
        if let onFailure = onFailure { onFailure(error) }
    }
    
    // MARK: Activity Indicator
    
    private func showLoader() {
        let hideClosure = {
            MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().delegate?.window!, animated: true)
        }
        if NSThread.isMainThread() {
            hideClosure()
        } else {
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                hideClosure()
            })
        }
    }
    
    private func hideLoader() {
        let hideClosure = {
            MBProgressHUD.hideAllHUDsForView(UIApplication.sharedApplication().delegate?.window!, animated: true)
        }
        if NSThread.isMainThread() {
            hideClosure()
        } else {
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                hideClosure()
            })
        }
    }
}

// MARK: Helpers
extension HTTPRequestOperationManager {
    func getRequest(path: String, _ modeUI: Bool, _ isSynchronous: Bool, _ headers: Dictionary<String,String>?, _ parameters: Dictionary<String,String>?, _ userInfo: Dictionary<String,AnyObject>?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        self.request("GET", path, modeUI, isSynchronous, headers, parameters, userInfo, onSuccess, onFailure)
    }
    
    func postRequest(path: String, _ modeUI: Bool, _ isSynchronous: Bool, _ headers: Dictionary<String,String>?, _ parameters: Dictionary<String,String>?, _ userInfo: Dictionary<String,AnyObject>?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        self.request("POST", path, modeUI, isSynchronous, headers, parameters, userInfo, onSuccess, onFailure)
    }
}