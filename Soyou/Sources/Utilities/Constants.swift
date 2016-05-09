//
//  Constants.swift
//  Soyou
//
//  Created by CocoaBob on 17/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

public struct Cons {
    struct Svr {
        static let serverVersion                            = "0.0.4"
        static let apiVersion                               = "v1"
        
//#if DEBUG
        static let hostname                                 = "test-api.soyou.io"
        static let shareBaseURL                             = "http://test-share.soyou.io:8090/#"
        static let reqAPIKey                                = "17843599-f079-4c57-bb39-d9ca8344abd"
//#else
//        static let hostname                                 = "api.soyou.io"
//        static let shareBaseURL                             = "http://share.soyou.io:8090/#"
//        static let reqAPIKey                                = "\(1155919*2*3*7)"+"-f079-4c57-bb39-d9ca8344abd7"
//#endif
        
        // Count of News to load for each request
        static let reqCnt                                   = 5
        
        static let reqAuthorizationKey                      = "reqAuthorizationKey"
    }
    
    struct Usr {
        static let uuid                                     = "uuid"
        static let token                                    = "token"
        static let deviceToken                              = "deviceToken"
        static let roleCode                                 = "roleCode"
        static let DidRegisterForRemoteNotifications        = "DidRegisterForRemoteNotifications"
        static let genderSecret                             = 1
        static let genderMale                               = 2
        static let genderFemale                             = 3
        static let genderSecretIndex                        = 0
        static let genderMaleIndex                          = 1
        static let genderFemaleIndex                        = 2
    }
    
    struct App {
        static let username                                 = "username"                                // Stored in keychain
        static let deviceToken                              = "deviceToken"                             // Stored in keychain
        static let hasRegisteredForNotification             = "hasRegisteredForNotification"            // Stored in NSUserDefaults
        static let lastIntroVersion                         = "lastIntroVersion"                        // Stored in database
        static let lastInstalledVersion                     = "lastInstalledVersion"                    // Stored in NSUserDefaults
        static let lastInstalledBuild                       = "lastInstalledBuild"                      // Stored in NSUserDefaults
        static let userCurrency                             = "userCurrency"                            // Stored in NSUserDefaults
        static let lastUpdateDate                           = "lastUpdateDate"                          // Stored in NSUserDefaults
        static let updateInterval                           = 0.0                                       // 0 second
        static let productsPageSize                         = 100                                       // the number of products / page
        static let lastServerIPAddress                      = "lastServerIPAddress"                     // Stored in NSUserDefaults, the IP address of the server
    }
    
    struct DB {
        static let lastRequestTimestampProductIDs           = "lastRequestTimestampProductIDs"          // Stored in database
        static let lastRequestTimestampDeletedProductIDs    = "lastRequestTimestampDeletedProductIDs"   // Stored in database
        static let lastRequestTimestampStores               = "lastRequestTimestampStores"              // Stored in database
        
        static let newsUpdatingDidFinishNotification        = "newsUpdatingDidFinishNotification"       // Notification to reload News
        static let brandsUpdatingDidFinishNotification      = "brandsUpdatingDidFinishNotification"     // Notification to reload Brands
        static let productsUpdatingDidFinishNotification    = "productsUpdatingDidFinishNotification"   // Notification to reload Products
    }
    
    struct UI {
        static let colorWindow                              = "#545454"
        static let colorNavBar                              = "#000000"
        static let colorToolbar                             = "#545454"
        static let colorTab                                 = "#545454"
        static let colorBGNavBar                            = "#F5F4F2"
        static let colorBG                                  = "#EDEAE5"
        static let colorTheme                               = "#FFB94B"
        static let colorLike                                = "#00B8F4"
        static let colorHeart                               = "#FF5EAA"
        static let colorStore                               = "#E84917"
        static let colorStoreMapCopy                        = "#59C843"
        static let colorStoreMapOpen                        = "#0095FF"
    }
    
    static var utcDateFormatter: NSDateFormatter {
        get {
            let _utcDateFormatter = NSDateFormatter()
            _utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            _utcDateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")
            return _utcDateFormatter
        }
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

func CompoundAndPredicate(predicates: [NSPredicate]) -> NSCompoundPredicate {
    return NSCompoundPredicate(type: NSCompoundPredicateType.AndPredicateType, subpredicates: predicates)
}

func CompoundOrPredicate(predicates: [NSPredicate]) -> NSCompoundPredicate {
    return NSCompoundPredicate(type: NSCompoundPredicateType.OrPredicateType, subpredicates: predicates)
}

var _emptyError = NSError(domain: "SoyouError", code: 0, userInfo: nil)
func FmtError(code: Int, _ msg: String?, _ args: CVarArgType...) -> NSError {
    if code == 0 && msg == nil {
        return _emptyError
    } else {
        return NSError(domain: "SoyouError", code: code, userInfo: ((msg != nil) ? [NSLocalizedDescriptionKey:FmtString(msg!, args)] : nil))
    }
}

func NSLocalizedString(key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

func DispatchAfter(delay:Double, closure:()->()) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
}

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
func DLog<T>(@autoclosure object: () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
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
