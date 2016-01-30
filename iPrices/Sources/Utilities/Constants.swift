//
//  Constants.swift
//  iPrices
//
//  Created by CocoaBob on 17/11/15.
//  Copyright © 2015 iPrices. All rights reserved.
//

public struct Cons {
    struct Svr {
        static let minVer                               = "0.0.2"
        
        static let baseURL                              = "https://baodating-api.woniu.io:5000"
        
        static let apiVersion                           = "v1"
        
        static let shareBaseURL                         = "http://baodating-contents.woniu.io:8090/#"
        
        // Count of News to load for each request
        static let reqCnt                               = 5
        
        static let reqAPIKey                            = "48548598-f079-4c57-bb39-d9ca8344abd7"
        static let reqAuthorizationKey                  = "reqAuthorizationKey"
    }
    
    struct Usr {
        static let uuid                                 = "uuid"
        static let token                                = "token"
        static let deviceToken                          = "deviceToken"
        static let roleCode                             = "roleCode"
        static let IsLoggedInDidChangeNotification      = "IsLoggedInDidChangeNotification"
    }
    
    struct App {
        static let username                             = "username"
        static let deviceToken                          = "deviceToken"
        static let lastVerIntro                         = "lastVerIntro" // The last app version that displayed the introduction view
        static let lastUpdateDate                       = "lastUpdateDate"
        static let lastRequestStoresTimestamp           = "lastRequestStoresTimestamp"
    }
    
    struct UI {
        static let colorWindow                          = "#555555"
        static let colorNavBar                          = "#000000"
        static let colorToolbar                         = "#a0a0a0"
        static let colorTab                             = "#333C41"
        static let colorBG                              = "#EDEAE5"
        static let colorLike                            = "#00B8F4"
        static let colorHeart                           = "#FF5EAA"
    }
}

typealias DataClosure = (AnyObject?)->()
typealias ErrorClosure = (NSError?)->()
typealias VoidClosure = ()->()
typealias CompletionClosure = (AnyObject?, NSError?)->()

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

func NSLocalizedString(key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

var CountryCode: [String:String] = [
    "中国":"CN",
    "香港":"HK",
    "日本":"JP",
    "韩国":"KR",
    "新加坡":"SG",
    "英国":"GB",
    "德国":"DE",
    "法国":"FR",
    "意大利":"IT",
    "西班牙":"ES",
    "美国":"US",
    "加拿大":"CA"]

/**
 Prints the filename, function name, line number and textual representation of `object` and a newline character into
 the standard output if the build setting for "Other Swift Flags" defines `-D DEBUG`.
 The current thread is a prefix on the output. <UI> for the main thread, <BG> for anything else.
 Only the first parameter needs to be passed to this funtion.
 The textual representation is obtained from the `object` using its protocol conformances, in the following
 order of preference: `CustomDebugStringConvertible` and `CustomStringConvertible`. Do not overload this function for
 your type. Instead, adopt one of the protocols mentioned above.
 :param: object   The object whose textual representation will be printed. If this is an expression, it is lazily evaluated.
 :param: file     The name of the file, defaults to the current file without the ".swift" extension.
 :param: function The name of the function, defaults to the function within which the call is made.
 :param: line     The line number, defaults to the line number within the file that the call is made.
 */
func DLog<T>(@autoclosure object: () -> T, _ file: String = __FILE__, _ function: String = __FUNCTION__, _ line: Int = __LINE__) {
    #if DEBUG
        let value = object()
        
        let fileURL = NSURL(string: file)?.lastPathComponent ?? "Unknown"
        let queue = NSThread.isMainThread() ? "UI" : "BG"
        
        let strFileName = fileURL.stringByPaddingToLength(40, withString: " ", startingAtIndex: 0)
        let strFunction = (function+"()").stringByPaddingToLength(32, withString: " ", startingAtIndex: 0)
        let strLineNmbr = FmtString("%04d", line)
        
        print("[\(queue)] \(strFileName) \(strFunction) [-\(strLineNmbr)]: \(value)")
    #endif
}