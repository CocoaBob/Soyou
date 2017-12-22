//
//  FileManager.swift
//  Soyou
//
//  Created by CocoaBob on 15/11/15.
//  Copyright © 2015 Soyou. All rights reserved.
//

import Foundation

class FileManager: NSObject {
    
    static var docDir: URL = {
        let urls = Foundation.FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.first!
    }()
    
    static var appSupportDir: URL = {
        let urls = Foundation.FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        return urls.first!
    }()
    
    static var dbDir: URL = {
        let url = FileManager.appSupportDir.appendingPathComponent("Soyou")
        if !Foundation.FileManager.default.fileExists(atPath: url.path) {
            do {
                try Foundation.FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                DLog(error)
            }
        }
        return url
    }()
    
    static var dbURL: URL = {
        return FileManager.dbDir.appendingPathComponent("Soyou.sqlite")
    }()
    
    static var cacheURL: URL {
        return FileManager.dbDir.appendingPathComponent("cache")
    }
    
    @discardableResult static func excludeFromBackup(_ pathURL: URL) -> Bool {
        if let _ = try? (pathURL as NSURL).setResourceValue(NSNumber(value: true as Bool), forKey: URLResourceKey.isExcludedFromBackupKey) {
            return true
        } else {
            return false
        }
    }
}
