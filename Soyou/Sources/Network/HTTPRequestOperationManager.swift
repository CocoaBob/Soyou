//
//  HTTPRequestOperationManager.swift
//  Soyou
//
//  Created by CocoaBob on 17/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

class HTTPRequestOperationManager: AFHTTPRequestOperationManager {
    
    var reqAPIKey: String = Cons.Svr.reqAPIKeyPROD
    var uuid: String = UserManager.shared.uuid
    
    override init(baseURL url: URL?) {
        super.init(baseURL: url)
        
        self.reqAPIKey = Utils.isSTGMode() ? Cons.Svr.reqAPIKeySTG : Cons.Svr.reqAPIKeyPROD
        
        self.requestSerializer = AFJSONRequestSerializer()
        self.responseSerializer = AFJSONResponseSerializer()
//        self.securityPolicy = AFSecurityPolicy(pinningMode: AFSSLPinningMode.none)
//        self.securityPolicy.validatesDomainName = false
//        self.securityPolicy.allowInvalidCertificates = true
        
        self.updateUserAgent()
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
            self.handleSuccess(operation, responseObject, path, onSuccess, onFailure)
        }
        
        let failure: (AFHTTPRequestOperation, Error) -> () = { (operation, error) -> () in
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
        let timestamp = self.timestamp()
        request.addValue(self.apiKey(timestamp), forHTTPHeaderField: "apiKey")
        request.addValue(timestamp, forHTTPHeaderField: "request-time")
        request.addValue(self.uuid, forHTTPHeaderField: "uuid")
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
                    failure(operation, operation.error! as Error)
                }
            }
        } else {
            operation.setCompletionBlockWithSuccess(success, failure: failure)
            self.operationQueue.addOperation(operation)
        }
    }
    
    func request(_ method: String, _ path: String, _ modeUI: Bool, _ isSynchronous: Bool, _ headers: Dictionary<String,String>?, _ parameters: Any?, _ userInfo: Dictionary<String,Any>?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        self.request(method, path, modeUI, isSynchronous, headers, parameters, false, userInfo, onSuccess, onFailure)
    }
    
    func request(_ method: String, _ path: String, _ modeUI: Bool, _ isSynchronous: Bool, _ headers: Dictionary<String,String>?, _ parameters: Any?, _ multiForm: Bool, _ userInfo: Dictionary<String,Any>?, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
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
        
        let failure: (AFHTTPRequestOperation, Error) -> () = { (operation, error) -> () in
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
        let request: NSMutableURLRequest = multiForm ?
            self.requestSerializer.multipartFormRequest(withMethod: method,
                                                        urlString: urlString,
                                                        parameters: nil,
                                                        constructingBodyWith: { (formData) in
                                                            guard let dict = parameters as? Dictionary<String, Any> else {
                                                                return
                                                            }
                                                            for (key, value) in dict {
                                                                if let value = value as? Data {
                                                                    formData.appendPart(withFileData: value, name: key, fileName: key, mimeType: "image/jpeg")
                                                                } else if let value = value as? [Data] {
                                                                    for (i, data) in value.enumerated() {
                                                                        formData.appendPart(withFileData: data, name: key, fileName: "\(key)\(i)", mimeType: "image/jpeg")
                                                                    }
                                                                } else {
                                                                    if let value = value as? String, let data = value.data(using: .utf8) {
                                                                        formData.appendPart(withForm: data, name: key)
                                                                    } else if JSONSerialization.isValidJSONObject(value),
                                                                        let jsonData = try? JSONSerialization.data(withJSONObject: value, options: []) {
                                                                        formData.appendPart(withForm: jsonData, name: key)
                                                                    } else {
                                                                        if let data = "\(value)".data(using: .utf8) {
                                                                            formData.appendPart(withForm: data, name: key)
                                                                        }
                                                                    }
                                                                }
                                                            }
            },
                                                        error: nil) :
            self.requestSerializer.request(withMethod: method, urlString: urlString, parameters: parameters, error: nil)
        let timestamp = self.timestamp()
        request.addValue(self.apiKey(timestamp), forHTTPHeaderField: "apiKey")
        request.addValue(timestamp, forHTTPHeaderField: "request-time")
        request.addValue(self.uuid, forHTTPHeaderField: "uuid")
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Setup operation
        let operation: AFHTTPRequestOperation = self.httpRequestOperation(with: request as URLRequest,
                                                                          success: success,
                                                                          failure: failure)
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
                    failure(operation, operation.error! as Error)
                }
            }
        } else {
//            operation.setCompletionBlockWithSuccess(success, failure: failure)
            self.operationQueue.addOperation(operation)
        }
    }
    
    fileprivate func handleSuccess(_ operation: AFHTTPRequestOperation, _ responseObject: Any?, _ path: String, _ onSuccess: DataClosure?, _ onFailure: ErrorClosure?) {
        if let onSuccess = onSuccess { onSuccess(responseObject) }
    }
    
    fileprivate func handleFailure(_ operation: AFHTTPRequestOperation, _ error: Error?, _ onFailure: ErrorClosure?) {
        if let onFailure = onFailure { onFailure(error) }
    }
}

extension HTTPRequestOperationManager {
    
    fileprivate func timestamp() -> String {
        return Cons.utcDateFormatter.string(from: Date())
    }
    
    fileprivate func apiKey(_ timestamp: String) -> String {
        return [self.reqAPIKey, timestamp, self.uuid].sorted().joined().sha1()
    }
    
    fileprivate func updateUserAgent() {
        var userAgent = "Soyou "
        // App Version
        if let shortVersionString = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString" as String) as? String {
            userAgent  += shortVersionString
        }
        // Model
        // Get device machine name http://stackoverflow.com/questions/26028918
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        let machine = String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        userAgent  += ";\(machine)"
        // System Version
        userAgent  += ";\(UIDevice.current.systemVersion)"
        // Device UUID
        userAgent  += ";\(self.uuid)"
        self.requestSerializer.setValue(userAgent, forHTTPHeaderField: "User-Agent")
    }
}

extension HTTPRequestOperationManager {
    
    func checkServerVersion() {
        // Handlers of success and failure
        let success: (AFHTTPRequestOperation, Any?) -> () = { (operation, responseObject) -> () in
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
                DLog("Local version: %@ Server supported version: %@", verLocalMin, verServer ?? "")
                // Show alert to open App Store
                Utils.shared.showNewVersionAvailable()
                return
            }
        }
        
        let failure: (AFHTTPRequestOperation, Error) -> () = { (operation, error) -> () in
            DLog("\(error.localizedDescription)")
        }
        
        // Build the URL
        let path = "/api/\(Cons.Svr.apiVersion)/secure/auth/check"
        guard let urlString = URL(string: path, relativeTo: self.baseURL)?.absoluteString else {
            return
        }
        
        // Setup request
        let request: NSMutableURLRequest = self.requestSerializer.request(withMethod: "GET", urlString: urlString, parameters: nil, error: nil)
        let timestamp = self.timestamp()
        request.addValue(self.apiKey(timestamp), forHTTPHeaderField: "apiKey")
        request.addValue(timestamp, forHTTPHeaderField: "request-time")
        request.addValue(self.uuid, forHTTPHeaderField: "uuid")
        let headers = ["api": "AuthCheck", "authorization": UserManager.shared.token ?? ""]
        for (key, value) in headers {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        // Setup operation
        let operation: AFHTTPRequestOperation = self.httpRequestOperation(with: request as URLRequest, success: nil, failure: nil)
        operation.setCompletionBlockWithSuccess(success, failure: failure)
        self.operationQueue.addOperation(operation)
    }
}
