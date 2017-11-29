//
//  HTTPRequestOperationManager.swift
//  Soyou
//
//  Created by CocoaBob on 17/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class HTTPRequestOperationManager: AFHTTPRequestOperationManager {
    
    var newVersionAlert: SCLAlertView?
    var reqAPIKey: String = Cons.Svr.reqAPIKeyPROD
    
    override init(baseURL url: URL?) {
        super.init(baseURL: url)
        
        let isSTGMode = UserDefaults.boolForKey(Cons.App.isSTGMode)
        self.reqAPIKey = isSTGMode ? Cons.Svr.reqAPIKeySTG : Cons.Svr.reqAPIKeyPROD
        
        requestSerializer = AFJSONRequestSerializer()
        responseSerializer = AFJSONResponseSerializer()
        self.securityPolicy = AFSecurityPolicy(pinningMode: AFSSLPinningMode.none)
        self.securityPolicy.validatesDomainName = false
        self.securityPolicy.allowInvalidCertificates = true
        
        // Use self-signed certificates in X.509 DER format, now we have 1 certificate
        var data: [NSData] = [NSData]()
        for name: String in ["server"] {
            let path: String? = Bundle.main.path(forResource: name, ofType: "cer")
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
    
    func requestExternal(_ method: String,
                         _ path: String,
                         _ modeUI: Bool,
                         _ isSynchronous: Bool,
                         _ headers: Dictionary<String,String>?,
                         _ parameters: Any?,
                         _ userInfo: Dictionary<String,Any>?,
                         _ onSuccess: DataClosure?,
                         _ onFailure: ErrorClosure?) {
        DLog(path)
        guard let path = path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            let error = FmtError(0, "Failed to encode URL")
            if let onFailure = onFailure { onFailure(error) }
            return
        }
        if modeUI {
            MBProgressHUD.show()
        }
        
        // Handlers of success and failure
        let success: (AFHTTPRequestOperation, Any?) -> () = { (operation, responseObject) -> () in
            modeUI ? MBProgressHUD.hide() : ()
            self.handleSuccessWithoutServerVersionCheck(operation, responseObject, path, onSuccess, onFailure)
        }
        
        let failure: (AFHTTPRequestOperation, NSError) -> () = { (operation, error) -> () in
            modeUI ? MBProgressHUD.hide() : ()
            self.handleFailure(operation, error, onFailure)
        }
        
        // Build the URL
        guard let urlString = URL(string: path, relativeTo: self.baseURL)?.absoluteString else {
            let error = FmtError(0, "Failed to build URL")
            if let onFailure = onFailure { onFailure(error) }
            return
        }
        
        // Setup request
        let request: NSMutableURLRequest = self.requestSerializer.request(withMethod: method, urlString: urlString, parameters: parameters, error: nil)
        request.addValue(self.reqAPIKey, forHTTPHeaderField: "apiKey")
        request.addValue(FmtString("%.0f", NSDate.timeIntervalSinceReferenceDate), forHTTPHeaderField: "request-time")
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Setup operation
        let operation: AFHTTPRequestOperation = self.httpRequestOperation(with: request as URLRequest, success: nil, failure: nil)
        if let userInfo = userInfo { operation.userInfo = userInfo }
        if isSynchronous {
            operation.start()
            operation.waitUntilFinished()
            if operation.isCancelled {
                modeUI ? MBProgressHUD.hide() : ()
            } else {
                if operation.error == nil {
                    success(operation, operation.responseObject)
                } else {
                    failure(operation, operation.error! as NSError)
                }
            }
        } else {
            operation.setCompletionBlockWithSuccess(success, failure: failure as? (AFHTTPRequestOperation, Error) -> Void)
            self.operationQueue.addOperation(operation)
        }
    }
    
    func request(_ method: String, _ path: String, _ modeUI: Bool, _ isSynchronous: Bool, _ headers: Dictionary<String,String>?, _ parameters: Any?, _ userInfo: Dictionary<String,Any>?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        let languageCode = Locale.preferredLanguages.first ?? "zh"
        var languageCountryCode = "zh-CN"
        if languageCode.hasPrefix("en") {
            languageCountryCode = "en-US"
        }
        let newPath = path + "?lang=" + languageCountryCode
        DLog("--> \"\(newPath)\"")
        guard let path = newPath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            let error = FmtError(0, "Failed to encode URL")
            if let onFailure = onFailure { onFailure(error) }
            return
        }
        if modeUI {
            MBProgressHUD.show()
        }
        
        // Handlers of success and failure
        let success: (AFHTTPRequestOperation, Any?) -> () = { (operation, responseObject) -> () in
            modeUI ? MBProgressHUD.hide() : ()
            DLog("<-- [\(((responseObject as? Dictionary<String, Any>)?["data"] as? [Any])?.count ?? 0)]")
            self.handleSuccess(operation, responseObject, path, onSuccess, onFailure)
        }
        
        let failure: (AFHTTPRequestOperation, NSError) -> () = { (operation, error) -> () in
            modeUI ? MBProgressHUD.hide() : ()
            DLog("<-- [x]\n\(error)")
            self.handleFailure(operation, error, onFailure)
        }
        
        // Build the URL
        guard let urlString = URL(string: path, relativeTo: self.baseURL)?.absoluteString else {
            let error = FmtError(0, "Failed to build URL")
            if let onFailure = onFailure { onFailure(error) }
            return
        }
        
        // Setup request
        let request: NSMutableURLRequest = self.requestSerializer.request(withMethod: method, urlString: urlString, parameters: parameters, error: nil)
        request.addValue(self.reqAPIKey, forHTTPHeaderField: "apiKey")
        request.addValue(FmtString("%.0f", NSDate.timeIntervalSinceReferenceDate), forHTTPHeaderField: "request-time")
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Setup operation
        let operation: AFHTTPRequestOperation = self.httpRequestOperation(with: request as URLRequest, success: nil, failure: nil)
        if let userInfo = userInfo { operation.userInfo = userInfo }
        if isSynchronous {
            operation.start()
            operation.waitUntilFinished()
            if operation.isCancelled {
                modeUI ? MBProgressHUD.hide() : ()
            } else {
                if operation.error == nil {
                    success(operation, operation.responseObject)
                } else {
                    failure(operation, operation.error! as NSError)
                }
            }
        } else {
            operation.setCompletionBlockWithSuccess(success, failure: failure as? (AFHTTPRequestOperation, Error) -> Void)
            self.operationQueue.addOperation(operation)
        }
    }
    
    fileprivate func handleSuccessWithoutServerVersionCheck(_ operation: AFHTTPRequestOperation, _ responseObject: Any?, _ path: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        if let onSuccess = onSuccess { onSuccess(responseObject) }
    }
    
    fileprivate func handleSuccess(_ operation: AFHTTPRequestOperation, _ responseObject: Any?, _ path: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        var isSoyouServer = false
        var isCurVerAccepted = false
        var verServer: String? = nil
        let verLocalMin = "|"+Cons.Svr.serverVersion+"|"
        if let headers: Dictionary = operation.response?.allHeaderFields {
            if let serverVersion = headers["Server-Version"] as? String {
                isSoyouServer = true
                verServer = serverVersion
                if serverVersion.range(of: verLocalMin) != nil {
                    isCurVerAccepted = true
                }
            }
        }
        if isSoyouServer && !isCurVerAccepted {
            let error = FmtError(0, "Local version: %@ Server supported version: %@", verLocalMin, verServer ?? "")
            
            // Show alert to open App Store
            if self.newVersionAlert == nil {
                self.newVersionAlert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
                self.newVersionAlert!.addButton(NSLocalizedString("app_new_version_app_store")) { () -> Void in
                    self.newVersionAlert = nil
                    Utils.openAppStorePage()
                }
                DispatchQueue.main.async {
                    self.newVersionAlert!.showNotice(NSLocalizedString("alert_title_info"), subTitle: NSLocalizedString("app_new_version_available"))
                }
            }
            
            if let onFailure = onFailure { onFailure(error) }
            return
        }
        if let onSuccess = onSuccess { onSuccess(responseObject) }
    }
    
    fileprivate func handleFailure(_ operation: AFHTTPRequestOperation, _ error: NSError?, _ onFailure: ErrorClosure?) {
        if let onFailure = onFailure { onFailure(error) }
    }
}
