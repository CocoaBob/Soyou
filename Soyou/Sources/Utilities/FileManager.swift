//
//  FileManager.swift
//  Soyou
//
//  Created by CocoaBob on 15/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

import Foundation

class FileManager: NSObject {
    
    static var docDir: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls.first!
    }()
    
    static var appSupportDir: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask)
        return urls.first!
    }()
    
    static var dbDir: NSURL = {
        let url = FileManager.appSupportDir.URLByAppendingPathComponent("Soyou")
        if !NSFileManager.defaultManager().fileExistsAtPath(url.path!) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(url.path!, withIntermediateDirectories: true, attributes: nil)
            } catch {
                DLog(error)
            }
        }
        return url
    }()
    
    static var dbURL: NSURL = {
        return FileManager.dbDir.URLByAppendingPathComponent("Soyou.sqlite")
    }()
    
    static func excludeFromBackup(pathURL: NSURL) -> Bool {
        if let _ = try? pathURL.setResourceValue(NSNumber(bool: true), forKey: NSURLIsExcludedFromBackupKey) {
            return true
        } else {
            return false
        }
    }
}