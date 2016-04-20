//
//  HTTPRequestOperationManager.swift
//  Soyou
//
//  Created by CocoaBob on 17/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class HTTPRequestOperationManager: AFHTTPRequestOperationManager {
    
    var newVersionAlert: SCLAlertView?
    
    override init(baseURL url: NSURL?) {
        super.init(baseURL: url)
        
        requestSerializer = AFJSONRequestSerializer()
        responseSerializer = AFJSONResponseSerializer()
        self.securityPolicy = AFSecurityPolicy(pinningMode: AFSSLPinningMode.None)
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
        DLog(path)
        guard let path = path.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else {
            let error = FmtError(0, "Failed to encode URL")
            if let onFailure = onFailure { onFailure(error) }
            return
        }
        if modeUI {
            MBProgressHUD.showLoader(nil)
        }
        
        // Handlers of success and failure
        let success: (AFHTTPRequestOperation, AnyObject?) -> () = { (operation, responseObject) -> () in
            modeUI ? MBProgressHUD.hideLoader(nil) : ()
            self.handleSuccessWithoutServerVersionCheck(operation, responseObject, path, onSuccess, onFailure)
        }
        
        let failure: (AFHTTPRequestOperation, NSError) -> () = { (operation, error) -> () in
            modeUI ? MBProgressHUD.hideLoader(nil) : ()
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
        request.addValue(FmtString("%.0f", NSDate.timeIntervalSinceReferenceDate()), forHTTPHeaderField: "request-time")
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
        let languageCode = NSLocale.preferredLanguages().first ?? "zh"
        var languageCountryCode = "zh-CN"
        if languageCode.hasPrefix("en") {
            languageCountryCode = "en-US"
        }
        let newPath = path + "?lang=" + languageCountryCode
        DLog("--> \"\(newPath)\"")
        guard let path = newPath.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) else {
            let error = FmtError(0, "Failed to encode URL")
            if let onFailure = onFailure { onFailure(error) }
            return
        }
        if modeUI {
            MBProgressHUD.showLoader(nil)
        }
        
        // Handlers of success and failure
        let success: (AFHTTPRequestOperation, AnyObject?) -> () = { (operation, responseObject) -> () in
            modeUI ? MBProgressHUD.hideLoader(nil) : ()
            DLog("<-- [\((responseObject?["data"])?.count)]")
            self.handleSuccess(operation, responseObject, path, onSuccess, onFailure)
        }
        
        let failure: (AFHTTPRequestOperation, NSError) -> () = { (operation, error) -> () in
            modeUI ? MBProgressHUD.hideLoader(nil) : ()
            DLog("<-- [x]\n\(error)")
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
        request.addValue(FmtString("%.0f", NSDate.timeIntervalSinceReferenceDate()), forHTTPHeaderField: "request-time")
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
        let verLocalMin = "|"+Cons.Svr.serverVersion+"|"
        if let headers: Dictionary = operation.response?.allHeaderFields {
            if let serverVersion = headers["Server-Version"] as? String {
                verServer = serverVersion
                if serverVersion.rangeOfString(verLocalMin) != nil {
                    isAccepted = true
                }
            }
        }
        if !isAccepted {
            let error = FmtError(0, "Local version: %@ Server supported version: %@", verLocalMin, verServer ?? "")
            
            // Show alert to open App Store
            if self.newVersionAlert == nil {
                self.newVersionAlert = SCLAlertView()
                self.newVersionAlert!.addButton(NSLocalizedString("app_new_version_app_store")) { () -> Void in
                    self.newVersionAlert = nil
                    Utils.openAppStorePage()
                }
                self.newVersionAlert!.showNotice(UIApplication.sharedApplication().keyWindow?.rootViewController?.toppestViewController(),
                                                 title: NSLocalizedString("alert_title_info"),
                                                 subTitle: NSLocalizedString("app_new_version_available"),
                                                 closeButtonTitle: nil,
                                                 duration: 0.0)
            }
            
            if let onFailure = onFailure { onFailure(error) }
            return
        }
        if let onSuccess = onSuccess { onSuccess(responseObject) }
    }
    
    private func handleFailure(operation: AFHTTPRequestOperation, _ error: NSError?, _ onFailure: ErrorClosure?) {
        if let onFailure = onFailure { onFailure(error) }
    }
}
