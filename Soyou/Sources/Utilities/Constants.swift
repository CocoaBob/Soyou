//
//  Constants.swift
//  Soyou
//
//  Created by CocoaBob on 17/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

public struct Cons {
    struct Svr {
        static let serverVersion                            = "0.0.6"
        static let apiVersion                               = "v1"
        
        static let hostnameSTG                              = "test-api.soyou.io"
        static let shareBaseURLSTG                          = "http://test-api.soyou.io/#"
        static let reqAPIKeySTG                             = "17843599-f079-4c57-bb39-d9ca8344abd"
        static let hostnamePROD                             = "api.soyou.io"
        static let shareBaseURLPROD                         = "http://share.soyou.io/#"
        static let reqAPIKeyPROD                            = "48548598-f079-4c57-bb39-d9ca8344abd7"
        
        // Number of News/Discounts for each request
        static let infoRequestSize                          = 10
        // Number of Comments for each request
        static let commentRequestSize                       = 32
        
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
        static let lastIntroVersion                         = "lastIntroVersion"                        // Stored in NSUserDefaults
        static let lastInstalledBuild                       = "lastInstalledBuild"                      // Stored in NSUserDefaults
        static let userCurrency                             = "userCurrency"                            // Stored in NSUserDefaults
        static let lastUpdateDate                           = "lastUpdateDate"                          // Stored in NSUserDefaults
        static let updateInterval                           = 0.0                                       // 0 second
        static let productsPageSize                         = 100                                       // the number of products / page
        static let isSTGMode                                = "isSTGMode"                               // Stored in NSUserDefaults
    }
    
    struct DB {
        static let lastRequestTimestampProductIDs           = "lastRequestTimestampProductIDs"          // Stored in database
        static let lastRequestTimestampDeletedProductIDs    = "lastRequestTimestampDeletedProductIDs"   // Stored in database
        static let lastRequestTimestampStores               = "lastRequestTimestampStores"              // Stored in database
        
        static let discountsUpdatingDidFinishNotification   = "discountsUpdatingDidFinishNotification"       // Notification to reload Discount
        static let newsUpdatingDidFinishNotification        = "newsUpdatingDidFinishNotification"       // Notification to reload News
        static let brandsUpdatingDidFinishNotification      = "brandsUpdatingDidFinishNotification"     // Notification to reload Brands
        static let productsUpdatingDidFinishNotification    = "productsUpdatingDidFinishNotification"   // Notification to reload Products
    }
    
    struct UI {
        static let colorWindow                              = UIColor(hex8: 0x545454FF)
        static let colorNavBar                              = UIColor(hex8: 0x000000FF)
        static let colorToolbar                             = UIColor(hex8: 0x545454FF)
        static let colorTab                                 = UIColor(hex8: 0x545454FF)
        static let colorBGNavBar                            = UIColor(hex8: 0xF5F4F2FF)
        static let colorBG                                  = UIColor(hex8: 0xE9E6E0FF)
        static let colorTheme                               = UIColor(hex8: 0xFFB94BFF)
        static let colorLike                                = UIColor(hex8: 0x00B8F4FF)
        static let colorHeart                               = UIColor(hex8: 0xFF5EAAFF)
        static let colorComment                             = UIColor(hex8: 0x20B4F1FF)
        static let colorStore                               = UIColor(hex8: 0xE84917FF)
        static let colorStoreMapCopy                        = UIColor(hex8: 0x59C843FF)
        static let colorStoreMapOpen                        = UIColor(hex8: 0x0095FFFF)
        static let heightPageMenuProduct                    = CGFloat(30.0)
        static let heightPageMenuInfo                       = CGFloat(44.0)
        static let statusBarHeight                          = CGFloat(UIDevice.isX() ? 44.0 : 20.0)
//        static let statusBarHeight                          = CGFloat(UIApplication.shared.isStatusBarHidden ? 0 : UIApplication.shared.statusBarFrame.height)
    }
    
    static var utcDateFormatter: DateFormatter {
        get {
            let _utcDateFormatter = DateFormatter()
            _utcDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            _utcDateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            return _utcDateFormatter
        }
    }
}

typealias DataClosure = (Any?)->()
typealias ErrorClosure = (NSError?)->()
typealias VoidClosure = ()->()
typealias CompletionClosure = (Any?, NSError?)->()

func FmtPredicate(_ fmt: String, _ args: CVarArg...) -> NSPredicate {
    return NSPredicate(format: fmt, arguments: getVaList(args))
}

func FmtString(_ fmt: String, _ args: CVarArg...) -> String {
    return String(format: fmt, arguments: args)
}

func FmtString(_ fmt: String, _ args: [CVarArg]) -> String {
    return String(format: fmt, arguments: args)
}

func CompoundAndPredicate(_ predicates: [NSPredicate]) -> NSCompoundPredicate {
    return NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.and, subpredicates: predicates)
}

func CompoundOrPredicate(_ predicates: [NSPredicate]) -> NSCompoundPredicate {
    return NSCompoundPredicate(type: NSCompoundPredicate.LogicalType.or, subpredicates: predicates)
}


var _emptyError = NSError(domain: "SoyouError", code: 0, userInfo: nil)
func FmtError(_ code: Int, _ msg: String?, _ args: CVarArg...) -> NSError {
    if code == 0 && msg == nil {
        return _emptyError
    } else {
        return NSError(domain: "SoyouError", code: code, userInfo: ((msg != nil) ? [NSLocalizedDescriptionKey:FmtString(msg!, args)] : nil))
    }
}

func NSLocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

func DispatchAfter(_ delay:Double, closure:@escaping ()->()) {
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
        closure()
    }
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
func DLog<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    #if DEBUG
        let value = object()
        
        let fileURL = URL(string: file)?.lastPathComponent ?? "Unknown"
        let queue = Thread.isMainThread ? "UI" : "BG"
        
        let strFileName = fileURL.padding(toLength: 40, withPad: " ", startingAt: 0)
        let strFunction = (function+"()").padding(toLength: 32, withPad: " ", startingAt: 0)
        let strLineNmbr = FmtString("%04d", line)
        
        print("[\(queue)] \(strFileName) \(strFunction) [-\(strLineNmbr)]: \(value)")
    #endif
}
