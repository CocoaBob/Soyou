//
//  Constants.swift
//  iPrices
//
//  Created by CocoaBob on 17/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

public struct Cons {
    struct Svr {
        static let minVer                   = "0.0.2"
        
        static let baseURL                  = "https://baodating-api.woniu.io:5000"
        
        // Count of News to load for each request
        static let reqCnt                   = 2
        
        static let reqAPIKey                = "48548598-f079-4c57-bb39-d9ca8344abd7"
        static let reqAuthorizationKey      = "reqAuthorizationKey"
    }
    
    struct Usr {
        static let uuid                     = "uuid"
        static let token                    = "token"
        static let deviceToken              = "deviceToken"
    }
    
    struct App {
        static let deviceToken      = "deviceToken"
        static let lastVerIntro     = "lastVerIntro" // The last app version that displayed the introduction view
    }
}

func FmtPredicate(fmt: String, _ args: CVarArgType...) -> NSPredicate {
    return NSPredicate(format: fmt, arguments: getVaList(args))
}

func FmtString(fmt: String, _ args: CVarArgType...) -> String {
    return String(format: fmt, arguments: args)
}

func FmtString(fmt: String, _ args: [CVarArgType]) -> String {
    return String(format: fmt, arguments: args)
}

func FmtError(code: Int, _ msg: String?, _ args: CVarArgType...) -> NSError {
    return NSError(domain: "iPricesError", code: code, userInfo: ((msg != nil) ? [NSLocalizedDescriptionKey:FmtString(msg!, args)] : nil))
}